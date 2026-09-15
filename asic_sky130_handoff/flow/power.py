#!/usr/bin/env python3
"""Case-adapted mapped simulation, complete cell-pin activity and OpenSTA energy."""
from __future__ import annotations
import argparse
import csv
import hashlib
import json
import os
import platform
from pathlib import Path
import re
import shlex
import shutil
import struct
import subprocess
import sys

import activity
import cad
import report_energy
ROOT=Path(__file__).resolve().parents[1]
MODES=('baseline','epix')


def sha(p):
    digest=hashlib.sha256()
    with Path(p).open('rb') as stream:
        for chunk in iter(lambda:stream.read(1024*1024),b''): digest.update(chunk)
    return digest.hexdigest()
def read(p): return json.loads(Path(p).read_text())
def write(p,x): Path(p).write_text(json.dumps(x,indent=2,allow_nan=False)+'\n')
def require(x,msg):
    if not x: raise ValueError(msg)

def command(cmd,log,env=None,timeout=7200):
    with Path(log).open('w') as f:
        subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,env=env,check=True,timeout=timeout)

def binary_initials(path, count):
    """Hash actual 24-state initial words rather than reconstructing RNG state."""
    out=[]
    with path.open('rb') as f:
        def take(n):
            b=f.read(n);require(len(b)==n,'truncated vectors');return b
        total=struct.unpack('<I',take(4))[0]
        require(total>=count,'too few vectors')
        for _ in range(count):
            trial=struct.unpack('<I',take(4))[0]
            take(130*4)
            initial=take(96*4)
            take((7+96)*4)
            events=struct.unpack('<I',take(4))[0]
            take(events*(1+96)*4)
            out.append((trial,hashlib.sha256(initial).hexdigest()))
    return out


def adapter(case):
    """Read simulation details while keeping the original Max-Cut interface."""
    design=read(case/'asic.json')
    if 'simulation' in design:
        options=dict(design['simulation'])
    elif case.name=='maxcut128':
        options=dict(driver='sim_main.cpp',prefix='Vcorrected_solver',vector_suffix='.bin',
                     compare_fields=['trial','success','sweeps','local_words','swap_words','icm_words','visits','events'],
                     fresh_word_fields=['local_words','swap_words','icm_words'],setup_rng_words=226,
                     boundary='Complete 128-lane APT/ICM solver with 24 time-shared states, local RNGs, metadata, auxiliary RNGs, control and on-chip reset/seed/state loading. Ideal root clock; excludes host generation/transport, routed wires and physical root clock distribution.')
    else:
        raise ValueError('Case lacks a mapped-simulation adapter: '+case.name)
    for key in ('driver','prefix','compare_fields','fresh_word_fields','setup_rng_words','boundary'):
        require(key in options,'simulation adapter missing '+key)
    options['top']=design['top']
    options.setdefault('vector_suffix','.bin')
    require(options['vector_suffix']=='.bin','only the binary vector adapter is supported')
    require(type(options['setup_rng_words']) is int and options['setup_rng_words']>=0,'invalid initialization word count')
    require({'trial','success'}<=set(options['compare_fields']),'must compare trial identity and success')
    require(options['fresh_word_fields'],'fresh-word counter fields required')
    return options


def simulation_dependencies(case, model, rtl_receipt):
    """Include C++ headers in the build binding without treating them as RTL."""
    names=set(model.get('dependency_sources', []))
    names.update(name for name in rtl_receipt['sources']
                 if Path(name).suffix.lower() in ('.h', '.hh', '.hpp', '.hxx'))
    dependencies=[]
    for name in sorted(names):
        path=(case/name).resolve()
        require(path.is_file(), 'missing simulation dependency: '+name)
        if name in rtl_receipt['sources']:
            require(sha(path)==rtl_receipt['sources'][name], 'simulation dependency changed: '+name)
        dependencies.append(path)
    return dependencies


def validate_inputs(case,reference,mapped_root,config,trials,smoke):
    period=config['clock']['period_ns']
    require(period>0 and period*1000==round(period*1000) and round(period*1000)%2==0,'clock must be positive and an even integer in ps')
    for mode in MODES:
        vector=read(reference/'vectors'/f'{mode}.json')
        require(vector['passed'] and vector['trials']>=trials,'reference vectors incomplete')
        if not smoke:
            require(vector['trials']>=1000,'production requires 1000 reference trials')
            outcomes=vector.get('outcomes',[])
            require([r['trial'] for r in outcomes[:1000]]==list(range(1000)),
                    'production reference trial set incomplete or out of order')
            metadata=read(case/'metadata.json')
            if 'max_flips' in metadata:
                require(all(r.get('full_software_flip_budget') is True and
                            r.get('flip_limit')==metadata['max_flips'] for r in outcomes[:1000]),
                        'shortened flip budgets are diagnostic only; regenerate full-budget vectors')
            if metadata.get('family', '').lower() == 'maxcut' and 'maximum_sweeps' in metadata:
                require(all(r.get('full_software_budget') is True and
                            r.get('canonical_maximum_sweeps') == metadata['maximum_sweeps']
                            for r in outcomes[:1000]),
                        'shortened sweep budgets are diagnostic only; regenerate full-budget vectors')
        require(sha(reference/'vectors'/f'{mode}.bin')==vector['sha256'],'vector hash differs')
        for name,value in vector['sources'].items(): require(sha(case/name)==value,'reference source drift: '+name)
        rtl=read(reference/f'rtl_{mode}'/'validation.json')
        require(rtl['passed'] and rtl['trials'] >= (trials if smoke else 1000),'need complete RTL validation; use --smoke only for diagnostic runs')
        require(rtl['vector_sha256']==vector['sha256'],'RTL used different vectors')
        require(sha(reference/f'rtl_{mode}'/'trials.tsv')==rtl['receipt_sha256'],'RTL receipts changed')
        for name,value in rtl['sources'].items(): require(sha(case/name)==value,'RTL source drift: '+name)
        d=mapped_root/mode
        timing=read(d/'timing_validation.json')
        require(timing['passed'],'timing not passed')
        for name,value in timing['hashes'].items():
            require(sha(d/name)==value,'timing artifact changed: '+name)
        require(timing['checks']==dict(setup=True,hold=True,max_capacitance=True,max_transition=True,constraint_coverage=True),'timing/electrical checks incomplete')
        # Bind elaborated/mapped source to current case and technology through the CAD receipt.
        resolved=read(d/'resolved.json')
        require(resolved['mode']==mode,'mapped mode mismatch')
        require(resolved['config']==config,'mapped technology mismatch')
        require(timing['design_fingerprint']==resolved['design_fingerprint'],'timing/source fingerprint differs')
        require(timing['binding']==resolved['binding'],'timing/source binding differs')
        require(resolved['binding']['case_manifest_sha256']==sha(case/'asic.json'),'case manifest changed')
        for name,value in resolved['binding']['source_sha256'].items():
            require(sha(case/name)==value,'mapped source drift: '+name)
        for name,value in resolved['binding']['flow_sha256'].items():
            require(sha(Path(__file__).parent/name)==value,'CAD flow changed: '+name)
        require(resolved['binding']['technology_config_sha256']==sha(resolved['technology_config']),'technology config changed')
        for name,value in resolved['scripts_sha256'].items():
            require(sha(d/name)==value,'CAD script changed: '+name)
        cad.require_timing(resolved)
        for f in ('mapped.v','mapped.json','cells_sim.v','clock_gate_sim.sv','constraints.sdc'):
            require((d/f).is_file(),'missing mapped artifact: '+f)


def linked_libraries(gate, archive):
    if archive is None:
        return []
    library=archive.resolve()
    expected=read(gate/'validation.json')['sources'].get(str(library))
    require(sha(library)==expected,'linked library changed after mapped simulation')
    return [library]


def simulate(case,reference,mapped_root,out,config,args):
    model=adapter(case)
    verilator=shutil.which(args.verilator)
    require(verilator,'Verilator not available')
    for mode in MODES:
        d=mapped_root/mode
        gate=out/(mode+'_gate');gate.mkdir(exist_ok=args.resume_build)
        net=out/mode;net.mkdir(exist_ok=args.resume_build)
        shutil.copy2(d/'mapped.json',net/'mapped.json')
        sources=[d/'mapped.v',d/'cells_sim.v',d/'clock_gate_sim.sv',case/model['driver']]
        dependencies=simulation_dependencies(case,model,read(reference/f'rtl_{mode}'/'validation.json'))
        bound_sources=list(dict.fromkeys(sources+dependencies))
        if args.lz4_static:
            bound_sources.append(args.lz4_static.resolve())
        before={str(p):sha(p) for p in bound_sources}
        if args.resume_build:
            for name in ('generate.log','build.log'):
                prior=gate/name
                if prior.exists():
                    saved=gate/(name+'.failed')
                    require(not saved.exists(),'failed build log already preserved: '+str(saved))
                    prior.rename(saved)
        command([verilator,'--cc','--exe','--trace-fst','--trace-structs','-Wno-fatal',
                 '--top-module',model['top'],'--prefix',model['prefix'],'--Mdir',str(gate),
                 *map(str,sources)],gate/'generate.log',timeout=args.build_timeout)
        native_make=shutil.which(os.environ.get('MAKE','make'))
        require(native_make,'Make unavailable')
        make_prefix=[native_make]
        if sys.platform=='darwin' and platform.machine()=='arm64':
            make_prefix=['/usr/bin/arch','-arm64',native_make]
        build=[*make_prefix,'-C',str(gate),'-f',model['prefix']+'.mk','-j',str(args.jobs)]
        if args.lz4_static:
            build.append('LDLIBS=-pthread -lpthread '+shlex.quote(str(args.lz4_static.resolve()))+' -lz')
        write(gate/'build_binding.json',dict(command=build,verilator_sha256=sha(verilator),sources=before))
        command(build,gate/'build.log',timeout=args.build_timeout)
        receipt=gate/'trials.tsv'
        env=dict(os.environ,CLOCK_PERIOD_PS=str(round(config['clock']['period_ns']*1000)),TRIAL_START='0')
        command([str(gate/model['prefix']),str(reference/'vectors'/f'{mode}.bin'),str(args.trials),str(receipt),str(gate/'activity.fst')],
                gate/'simulation.log',env=env,timeout=args.run_timeout)
        require(before=={str(p):sha(p) for p in bound_sources},'sources changed during simulation')
        with receipt.open() as f: rows=list(csv.DictReader(f,delimiter='\t'))
        with (reference/f'rtl_{mode}'/'trials.tsv').open() as f: ref=list(csv.DictReader(f,delimiter='\t'))[:args.trials]
        require([int(r['trial']) for r in rows]==list(range(args.trials)),'mapped trial set incomplete')
        require([int(r['trial']) for r in ref]==list(range(args.trials)),'RTL trial set incomplete or out of order')
        for r,v in zip(rows,ref):
            for key in model['compare_fields']:
                require(r[key]==v[key],mode+': mapped/RTL mismatch '+key)
            require(int(r['end'])-int(r['search_begin'])==int(v['end'])-int(v['search_begin']),'search duration differs')
        trial_windows=[dict(trial=int(r['trial']),trial_begin_cycle=int(r['setup_begin']),search_begin_cycle=int(r['search_begin']),end_cycle=int(r['end']),success=bool(int(r['success']))) for r in rows]
        write(gate/'receipt.json',dict(workloads=[dict(trials=trial_windows)]))
        write(gate/'validation.json',dict(passed=True,trials=args.trials,sources=before,receipt_sha256=sha(receipt),trace_sha256=sha(gate/'activity.fst'),
                                        vector_sha256=sha(reference/'vectors'/f'{mode}.bin'),
                                        checks='Mapped final state and all outcome/counter fields match software; durations match RTL.'))
        print('MAPPED_PASS',mode,args.trials,flush=True)
        activity.prepare(out,mode,config['clock']['period_ns'],model['top'],cad.liberty_units(Path(read(d/'resolved.json')['liberty']).read_text())['ns_per_time_unit'])


def energy(case,reference,mapped_root,out,config,technology_path,args):
    model=adapter(case)
    sta=shutil.which(args.sta);require(sta,'OpenSTA not available')
    liberty=(technology_path.parent/config['liberty']).resolve()
    require(sha(liberty)==config['liberty_sha256'],'Liberty hash mismatch')
    record=dict(schema='asic_energy_v1',status='diagnostic_smoke' if args.smoke else 'complete',case_id=case.name,
                technology={k:config[k] for k in ('id','liberty_sha256','voltage_v','temperature_c','corner')},
                period_ns=config['clock']['period_ns'],measurement_model='prelayout_zero_delay',activity_population='paired_predeclared',
                trial_ids=list(range(args.trials)),boundary=model['boundary'],
                configurations={})
    for mode in MODES:
        d=mapped_root/mode;q=out/(mode+'_power');gate=out/(mode+'_gate')
        m=read(d/'mapped.json')['modules'][model['top']]
        expected_pins=sum(len(c['port_directions']) for c in m['cells'].values())
        expected_inputs=sum(len(p['bits']) for name,p in m['ports'].items() if p['direction']=='input' and name!='clk')
        expected={w:read(q/(w+'.counts.json')) for w in ('search','with_setup')}
        for counts in expected.values():
            require((counts['cell_pins'],counts['input_ports'],counts['annotated_targets'])==
                    (expected_pins,expected_inputs,expected_pins+expected_inputs),'activity target coverage differs from mapped design')
            require(counts['trial_count']==args.trials,'activity population differs')
            require(counts['ns_per_library_time_unit']==cad.liberty_units(liberty.read_text())['ns_per_time_unit'],
                    'activity Liberty time unit differs')
            require(counts['root_clock']==dict(density_hz=2e9/config['clock']['period_ns'],duty=0.5),
                    'activity root clock differs')
        tcl=[f'read_liberty {{{liberty}}}',f'read_verilog {{{d/"mapped.v"}}}','link_design '+model['top'],f'source {{{d/"constraints.sdc"}}}',
             f'source {{{q/"activity_readback.tcl"}}}']
        rng_cells=read(d/'synthesis.json')['netlist_audit']['local_rng_cells']
        expected_rng=read(d/'synthesis.json')['netlist_audit']['local_rng_registers']
        require(len(rng_cells)==len(set(rng_cells))==expected_rng and expected_rng>0,'RNG register audit incomplete')
        tcl.append('set rng_cells [get_cells [list '+' '.join(cad.tquote(n) for n in rng_cells)+']]')
        for window in ('search','with_setup'):
            tcl += ['sta::clear_power',f'source {{{q/(window+".activity.tcl")}}}',
                    f'report_activity_annotation > {{{q/(window+".annotation.txt")}}}',
                    f'report_power -digits 12 > {{{q/(window+".power.txt")}}}',
                    'set epix_readback_phase total',f'source {{{q/(window+".readback.tcl")}}}',
                    f'report_power -instances $rng_cells -digits 12 > {{{q/(window+".rng.txt")}}}',
                    'set epix_readback_phase rng',f'source {{{q/(window+".readback.tcl")}}}']
        tcl+=['exit'];script=q/'power.tcl';script.write_text('\n'.join(tcl)+'\n')
        activity_files=[q/name for name in ('counts.tsv','targets.tsv','windows.tsv','reader.json','activity_readback.tcl')]
        activity_files += [q/(w+suffix) for w in expected for suffix in ('.activity.tcl','.readback.tcl','.counts.json')]
        counter_source=Path(activity.__file__).with_name('activity_fast.cpp')
        require(sha(counter_source)==read(q/'reader.json')['source_sha256'],'activity-counter source changed')
        bound=[Path(sta),liberty,d/'mapped.v',d/'mapped.json',d/'constraints.sdc',script,*activity_files,
               Path(__file__),Path(activity.__file__),counter_source]
        before={str(p):sha(p) for p in bound}
        command([sta,'-exit',str(script)],q/'power.log')
        require(before=={str(p):sha(p) for p in bound},'power inputs or tool changed during analysis')
        cad.require_timing(read(d/'resolved.json'))
        require(sha(liberty)==config['liberty_sha256'],'Liberty changed during power analysis')
        power_log=(q/'power.log').read_text()
        require(not re.search(r'(^|\n)\s*(Error|Warning)',power_log),'OpenSTA warning/error: inspect power.log')
        readback=activity.validate_readback(power_log,expected)
        readback.update(input_hashes=before,log_sha256=sha(q/'power.log'),sta_binary_sha256=sha(Path(sta)))
        write(q/'activity_readback.json',readback)
        windows={}
        outputs=sum(len(p['bits']) for p in m['ports'].values() if p['direction']=='output')
        for w in ('search','with_setup'):
            annotation=(q/(w+'.annotation.txt')).read_text()
            unannotated=re.search(r'unannotated\s+(\d+)',annotation)
            require(unannotated and int(unannotated[1])==outputs+1,'unexpected unannotated activity')
            lines=[line for line in (q/(w+'.power.txt')).read_text().splitlines() if line.startswith('Total ')]
            require(len(lines)==1,'no unique total power row')
            vals=list(map(float,lines[0].split()[1:5]))
            counts=read(q/(w+'.counts.json'))
            require(counts['trial_count']==args.trials,'activity population differs')
            windows[w]=dict(duration_ns=counts['duration_ps']/1000,power_w=dict(zip(('internal','switching','leakage','total'),vals)))
            rng_rows=[line.split() for line in (q/(w+'.rng.txt')).read_text().splitlines() if re.match(r'^\s*\d\.\d+e[+-]\d+',line)]
            require(len(rng_rows)==expected_rng,'incomplete RNG-register power rows')
            windows[w]['rng_register_power_w']=sum(float(row[3]) for row in rng_rows)
        outcomes=read(reference/'vectors'/f'{mode}.json')['outcomes']
        require([r['trial'] for r in outcomes[:args.trials]]==list(range(args.trials)),'reference outcomes incomplete or out of order')
        if case.name=='maxcut128':
            initials=binary_initials(reference/'vectors'/f'{mode}.bin',args.trials)
        else:
            initials=[(r['trial'],r['initial_state_sha256']) for r in outcomes[:args.trials]]
        with (gate/'trials.tsv').open() as f: rows=list(csv.DictReader(f,delimiter='\t'))
        trials=[]
        for r,initial,ref in zip(rows,initials,outcomes):
            require(int(r['trial'])==initial[0]==ref['trial'],'trial identity mismatch')
            trials.append(dict(trial=int(r['trial']),seed=ref['seed'],initial_state_sha256=initial[1],success=bool(int(r['success'])),
                               search_cycles=int(r['end'])-int(r['search_begin']),setup_cycles=int(r['search_begin'])-int(r['setup_begin']),
                               fresh_words=sum(int(r[k]) for k in model['fresh_word_fields'])+model['setup_rng_words']))
        evidence={}; dest=out/'evidence'/mode;dest.mkdir(parents=True)
        def add(category,paths):
            evidence[category]=[]
            for i,p in enumerate(paths):
                target=dest/(category+'_'+str(i)+'_'+p.name);shutil.copy2(p,target)
                evidence[category].append(dict(path=str(target.relative_to(out)),sha256=sha(target)))
        meta=read(case/'metadata.json')
        inputs=[case/f for f in meta['input_files']]
        inputs += [case/'metadata.json',case/meta['certificate_file'], reference/'vectors'/f'{mode}.json']
        add('inputs',list(dict.fromkeys(inputs)))
        add('run_spec',[out/'RUN_SPEC.json'])
        sources=[case/'asic.json',case/model['driver']]
        sources += [case/f for f in read(reference/f'rtl_{mode}'/'validation.json')['sources']]
        sources += [case/f for f in read(reference/'vectors'/f'{mode}.json')['sources']]
        sources += simulation_dependencies(case,model,read(reference/f'rtl_{mode}'/'validation.json'))
        add('source',list(dict.fromkeys(sources)))
        libraries=linked_libraries(gate,args.lz4_static)
        if libraries:
            add('linked_libraries',libraries)
        add('technology',[technology_path,liberty])
        add('rtl_validation',[reference/f'rtl_{mode}'/'validation.json',reference/f'rtl_{mode}'/'trials.tsv'])
        add('mapped_validation',[d/'resolved.json',d/'synthesis.json',d/'stat.json',d/'mapped.v',d/'mapped.json',d/'cells_sim.v',d/'clock_gate_sim.sv',gate/'validation.json',gate/'trials.tsv',gate/'build_binding.json'])
        add('timing',[d/'timing_validation.json',d/'timing.json',d/'constraints.sdc',d/'timing.tcl',d/'setup.txt',d/'hold.txt',d/'electrical.txt',d/'check_setup.txt',d/'timing.log'])
        add('activity',[*activity_files,q/'activity_readback.json'])
        add('activity_source',[counter_source])
        add('power',[q/'search.power.txt',q/'with_setup.power.txt',q/'search.rng.txt',q/'with_setup.rng.txt',q/'search.annotation.txt',q/'with_setup.annotation.txt',script,q/'power.log',Path(__file__),Path(activity.__file__)])
        record['configurations'][mode]=dict(trials=trials,area_um2=read(d/'stat.json')['design']['area'],windows=windows,evidence=evidence,
            checks=dict(rtl_match=True,mapped_match=True,setup=True,hold=True,max_capacitance=True,max_transition=True,constraint_coverage=True,all_cell_pin_activity=True,zero_unknown_activity=True,power_activity_readback=True))
    validate_inputs(case,reference,mapped_root,config,args.trials,args.smoke)
    write(out/'energy_record.json',record)
    if not args.smoke:
        summary=report_energy.summarize(record,out)
        write(out/'SUMMARY.json',summary);(out/'RESULTS.md').write_text(report_energy.render(summary))
    print('DIAGNOSTIC_SMOKE_ONLY' if args.smoke else 'ENERGY_COMPLETE',out,flush=True)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--case',type=Path,default=ROOT/'cases/maxcut128')
    p.add_argument('--tech',type=Path,default=ROOT/'tech/sky130_hd/config_200ns.json')
    p.add_argument('--reference-work',type=Path,required=True)
    p.add_argument('--mapped-root',type=Path,required=True,help='Directory containing baseline/ and epix/ CAD outputs')
    p.add_argument('--output',type=Path,required=True,help='New directory, or a failed build with --resume-build')
    p.add_argument('--resume-build',action='store_true',help='Retry a build only if no mapped simulation has started')
    p.add_argument('--lz4-library','--lz4-static',dest='lz4_static',type=Path,default=os.environ.get('LZ4_LIBRARY',os.environ.get('LZ4_STATIC')),help='Optional native LZ4 static or shared library for FST linking')
    p.add_argument('--trials',type=int,default=32)
    p.add_argument('--smoke',action='store_true',help='Diagnostic only, cannot create an accepted energy report')
    p.add_argument('--jobs',type=int,default=2)
    p.add_argument('--verilator',default=os.environ.get('VERILATOR','verilator'))
    p.add_argument('--sta',default=os.environ.get('OPENSTA','sta'))
    p.add_argument('--build-timeout',type=int,default=7200)
    p.add_argument('--run-timeout',type=int,default=7200)
    args=p.parse_args()
    model=adapter(args.case.resolve())
    require(1<=args.trials<=1000 and (args.smoke or args.trials>=32),'production needs at least 32 predeclared trials')
    require(1<=args.jobs<=64,'jobs must be 1..64')
    case=args.case.resolve();reference=args.reference_work.resolve();mapped=args.mapped_root.resolve();out=args.output.resolve();tech=args.tech.resolve()
    config=read(tech)
    validate_inputs(case,reference,mapped,config,args.trials,args.smoke)
    spec=dict(case_id=case.name,boundary=model['boundary'],trials=args.trials,trial_ids=list(range(args.trials)),smoke=args.smoke,technology_sha256=sha(tech),
              measurement_model='prelayout_zero_delay',fresh_words=dict(counter_fields=model['fresh_word_fields'],setup_words=model['setup_rng_words']))
    if args.resume_build:
        require(out.is_dir() and read(out/'RUN_SPEC.json')==spec,'retry requires the identical saved run specification')
        require(not (out/'energy_record.json').exists(),'energy result already exists')
        for mode in MODES:
            require(not (out/(mode+'_gate')/model['prefix']).exists(),
                    'mapped executable already exists; resume-build requires an unlinked build')
            for name in ('simulation.log','activity.fst','trials.tsv','validation.json'):
                require(not (out/(mode+'_gate')/name).exists(),'mapped simulation already started; choose a new output directory')
    else:
        require(not out.exists(),'output already exists; choose a new directory')
        out.mkdir(parents=True)
        write(out/'RUN_SPEC.json',spec)
    simulate(case,reference,mapped,out,config,args)
    validate_inputs(case,reference,mapped,config,args.trials,args.smoke)
    energy(case,reference,mapped,out,config,tech,args)

if __name__=='__main__':main()
