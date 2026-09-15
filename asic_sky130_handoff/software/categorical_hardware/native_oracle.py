#!/usr/bin/env python3
"""Derive an instrumented C oracle without editing the packaged native sources."""
from __future__ import annotations

import hashlib
import os
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
NATIVE = HERE.parent / "probsat_native"

RANDOM_SOURCE = r'''
/* Portability adapter: only rand/srand are replaced; solver logic is unchanged. */
static uint32_t hw_rng_state=1;
static int hw_rand(void) {
 uint32_t x=hw_rng_state;x^=x<<13;x^=x>>17;x^=x<<5;
 hw_rng_state=x;return (int)(x>>1);
}
static void hw_srand(unsigned int seed){hw_rng_state=seed?seed:1;}
#define rand hw_rand
#define srand hw_srand
static int hw_site=0,hw_choice=0;
static unsigned hw_mass[3]={0,0,0};
'''

EMITTER = r'''
static FILE *hw_trace;
static void hw_emit(int kind) {
 if(!hw_trace)return;
 uint32_t s[4]={0,0,0,0};
 for(int j=1;j<=numVars;j++)s[(j-1)/32]|=((uint32_t)atom[j])<<((j-1)%32);
 uint64_t value=kind==2?v16_value[hw_site]:0;
 uint64_t range=kind==2?v16_range[hw_site]:0;
 fprintf(hw_trace,"%u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u\n",
 (unsigned)kind,s[0],s[1],s[2],s[3],kind==2?(unsigned)(flip+1):0,
 (unsigned)v11_fresh,(unsigned)v11_reuse,(unsigned)v16_refills,
 (unsigned)v11_init,(unsigned)numFalse,hw_rng_state,
 kind==2?(unsigned)(hw_site-1):0,kind==2?(unsigned)hw_choice:0,
 kind==2?(unsigned)breaks[0]:0,kind==2?(unsigned)breaks[1]:0,
 kind==2?(unsigned)breaks[2]:0,
 kind==2?hw_mass[0]:0,kind==2?hw_mass[1]:0,kind==2?hw_mass[2]:0,
 (unsigned)value,(unsigned)(value>>32),(unsigned)range,(unsigned)(range>>32),
 kind==2?(unsigned)v11_age[hw_site]:0);
}
'''


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def replace_once(text, old, new):
    if text.count(old) != 1:
        raise ValueError(f"Native instrumentation anchor is not unique: {old!r}")
    return text.replace(old, new, 1)


def build(directory):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    original = NATIVE / "probsat_v20.c"
    text = original.read_text()
    text = replace_once(text, '#include "conditioned.h"',
                        '#include "conditioned.h"\n' + RANDOM_SOURCE)
    text = replace_once(text, " v16_refills+=v11_fresh-before;",
                        " v16_refills+=v11_fresh-before;\n"
                        " hw_site=site;hw_choice=chosen;for(int h=0;h<3;h++)hw_mass[h]=w[h];")
    text = replace_once(text, "int main(int argc, char *argv[]) {",
                        EMITTER + "\nint main(int argc, char *argv[]) {\n"
                        ' if(getenv("HW_TRACE")){hw_trace=fopen(getenv("HW_TRACE"),"w");if(!hw_trace)return 2;}')
    text = replace_once(text, "\t\tinit();", "\t\tinit(); hw_emit(1);")
    text = replace_once(text, "\t\t\tpickAndFlipVar();", "\t\t\tpickAndFlipVar(); hw_emit(2);")
    derived = directory / "instrumented_native.c"
    derived.write_text(text)
    binary = directory / "instrumented_native"
    command = [os.environ.get("CC", "cc"), "-std=gnu99", "-O2", "-I"+str(NATIVE),
               str(derived), "-lm", "-o", str(binary)]
    result = subprocess.run(command, capture_output=True, text=True)
    (directory / "compiler.log").write_text(result.stdout + result.stderr)
    if result.returncode:
        raise RuntimeError(f"Native oracle build failed: {directory / 'compiler.log'}")
    return binary, dict(original_sha256=sha(original),
                        conditioned_sha256=sha(NATIVE / "conditioned.h"),
                        instrumented_sha256=sha(derived), binary_sha256=sha(binary),
                        compiler_command=command)


def run(binary, cnf, seed, mode, limit, output, timeout=120):
    output = Path(output)
    trace = output.with_suffix(".trace")
    env = dict(os.environ, HW_TRACE=str(trace), V11_EPIX=str(int(mode == "epix")),
               V11_AGE="254" if mode == "epix" else "1", V20_RELAX=str(int(mode == "epix")))
    command = [str(binary), "--runs", "1", "--maxflips", str(limit),
               "--printSolution", str(cnf), str(seed)]
    result = subprocess.run(command, env=env, capture_output=True, text=True, timeout=timeout)
    output.with_suffix(".stdout").write_text(result.stdout)
    output.with_suffix(".stderr").write_text(result.stderr)
    if result.returncode not in (0, 10):
        raise RuntimeError(f"Native oracle failed ({result.returncode}) at {output}")
    events = [list(map(int, line.split())) for line in trace.read_text().splitlines()]
    refresh = re.search(r"V20_REASONS ((?:\d+\s+){5}\d+)", result.stdout)
    if not refresh:
        raise RuntimeError("Missing native policy counters")
    return events, dict(command=command, exit_code=result.returncode,
                        success=result.returncode == 10, trace_sha256=sha(trace),
                        refresh_reasons=list(map(int,refresh.group(1).split())))


def native_mass_table(directory, max_break):
    """Compile the untouched native quantize function and exhaust all tuples."""
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    cfile = directory / "mass_oracle.c"
    cfile.write_text('#include <stdio.h>\n#include "conditioned.h"\n'
        'int main(void){for(int a=0;a<='+str(max_break)+';a++)'
        'for(int b=0;b<='+str(max_break)+';b++)for(int c=0;c<='+str(max_break)+';c++){'
        'double p[3]={pow(.9+a,-2.06),pow(.9+b,-2.06),pow(.9+c,-2.06)};'
        'unsigned w[3];quantize(p,w);printf("%u %u %u\\n",w[0],w[1],w[2]);}return 0;}\n')
    binary = directory / "mass_oracle"
    subprocess.run([os.environ.get("CC", "cc"), "-std=gnu99", "-O2",
                    "-I"+str(NATIVE), str(cfile), "-lm", "-o", str(binary)], check=True)
    result = subprocess.check_output([str(binary)], text=True)
    return [list(map(int, line.split())) for line in result.splitlines()]
