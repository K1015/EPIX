#!/usr/bin/env python3
"""Verify a complete paired energy record and write a compact comparison."""
import argparse
import csv
import hashlib
import json
import math
import re
from pathlib import Path

import activity

MODES = ('baseline', 'epix')
WINDOWS = ('search', 'with_setup')


def require(ok, message):
    if not ok:
        raise ValueError(message)


def finite(value, name, positive=False):
    require(type(value) in (float, int) and math.isfinite(value), name + ' must be finite')
    require(value > 0 if positive else value >= 0, name + ' must be nonnegative')
    return value


def saving(a, b):
    return None if a == 0 else 100 * (1 - b / a)


def wilson(hits, n):
    z = 1.959963984540054
    p = hits / n
    den = 1 + z*z/n
    center = (p + z*z/(2*n))/den
    half = z*math.sqrt(p*(1-p)/n + z*z/(4*n*n))/den
    return [center-half, center+half]


def bound_results(record, mode, config, base, pilot=False):
    """Re-derive report values from the exact artifacts in this result bundle.

    Hashes attest bytes, not claims about unrelated numbers. These checks bind
    the displayed population, outcomes, cycles, area and power to those bytes.
    """
    evidence = config['evidence']
    def paths(category):
        return [(base / item['path']).resolve() for item in evidence[category]]
    def one(category, name):
        found = [p for p in paths(category) if p.name == name or p.name.endswith('_' + name)]
        require(len(found) == 1, mode + ': require unique bound ' + category + '/' + name)
        return found[0]
    def read(category, name):
        return json.loads(one(category, name).read_text())
    def table(category, name):
        with one(category, name).open() as stream:
            return list(csv.DictReader(stream, delimiter='\t'))
    def digest(category, name):
        return hashlib.sha256(one(category, name).read_bytes()).hexdigest()
    def same(a, b, name):
        require(math.isclose(float(a), float(b), rel_tol=1e-10, abs_tol=1e-15), mode + ': unbound ' + name)

    reference_trials = 3 if pilot else 1000
    spec = read('run_spec', 'RUN_SPEC.json')
    ids = record['trial_ids']
    require(spec.get('smoke') is pilot, 'run profile differs from reporting profile')
    require(spec.get('case_id') == record['case_id'], 'run case differs')
    require(spec.get('boundary') == record['boundary'], 'run boundary differs')
    require(spec.get('measurement_model') == record['measurement_model'], 'run measurement model differs')
    require(spec.get('trial_ids') == ids and spec.get('trials') == len(ids) and (len(ids) == 3 if pilot else len(ids) >= 32),
            'production requires the bound predeclared population of at least 32 trials')
    require(ids == list(range(len(ids))), 'production population must preserve the predeclared trial prefix')
    vector = read('inputs', mode + '.json')
    require(vector.get('passed') is True and vector.get('mode') == mode and vector.get('trials', 0) >= reference_trials,
            mode + ': full reference receipt required')
    outcomes = vector.get('outcomes', [])
    require([row['trial'] for row in outcomes[:reference_trials]] == list(range(reference_trials)), 'reference population incomplete')
    rtl = read('rtl_validation', 'validation.json')
    require(rtl.get('passed') is True and rtl.get('trials', 0) >= reference_trials, 'complete functional trial population required')
    require(rtl.get('vector_sha256') == vector['sha256'], 'functional/vector binding differs')
    require(rtl.get('receipt_sha256') == digest('rtl_validation', 'trials.tsv'), 'functional receipt binding differs')
    rtl_rows = table('rtl_validation', 'trials.tsv')
    require([int(row['trial']) for row in rtl_rows[:reference_trials]] == list(range(reference_trials)), 'functional trial population incomplete')
    gate = read('mapped_validation', 'validation.json')
    require(gate.get('passed') is True and gate.get('trials') == len(ids), 'mapped validation population differs')
    require(gate.get('receipt_sha256') == digest('mapped_validation', 'trials.tsv'), 'mapped receipt binding differs')
    require(gate.get('vector_sha256') == vector['sha256'], 'mapped/vector binding differs')
    rows = table('mapped_validation', 'trials.tsv')
    require([int(row['trial']) for row in rows] == ids, 'mapped trial population differs')

    manifest = read('source', 'asic.json')
    model = manifest.get('simulation')
    if model is None:
        require(record['case_id'] == 'maxcut128', 'simulation adapter missing')
        model = dict(compare_fields=['trial', 'success', 'sweeps', 'local_words', 'swap_words', 'icm_words', 'visits', 'events'],
                     fresh_word_fields=['local_words', 'swap_words', 'icm_words'], setup_rng_words=226)
    require(spec['fresh_words'] == dict(counter_fields=model['fresh_word_fields'], setup_words=model['setup_rng_words']),
            'fresh-word boundary differs from bound case adapter')
    metadata = read('inputs', 'metadata.json')
    require(metadata['case_id'] == record['case_id'], 'input metadata case differs')
    if 'max_flips' in metadata:
        require(all(o.get('full_software_flip_budget') is True and o.get('flip_limit') == metadata['max_flips']
                    for o in outcomes[:reference_trials]), 'shortened functional budgets are diagnostic only')
    if metadata.get('family', '').lower() == 'maxcut' and 'maximum_sweeps' in metadata:
        require(all(o.get('full_software_budget') is True and
                    o.get('canonical_maximum_sweeps') == metadata['maximum_sweeps']
                    for o in outcomes[:reference_trials]), 'shortened sweep budgets are diagnostic only')
    for row, original, trial, outcome in zip(rows, rtl_rows, config['trials'], outcomes):
        for field in model['compare_fields']:
            require(row[field] == original[field], 'mapped/functional field differs: ' + field)
        require(int(row['success']) in (0, 1) and trial['success'] == bool(int(row['success'])), 'success differs from mapped evidence')
        for field, begin in [('search_cycles', 'search_begin'), ('setup_cycles', 'setup_begin')]:
            end = 'end' if field == 'search_cycles' else 'search_begin'
            value = int(row[end]) - int(row[begin])
            require(trial[field] == value, 'cycle count differs from mapped evidence: ' + field)
            require(value == int(original[end]) - int(original[begin]), 'mapped/functional duration differs')
        require(trial['fresh_words'] == sum(int(row[k]) for k in model['fresh_word_fields']) + model['setup_rng_words'],
                'fresh-word count differs from mapped evidence')
        require(trial['seed'] == outcome['seed'], 'seed differs from reference evidence')
        require(trial['initial_state_sha256'] == outcome['initial_state_sha256'], 'initial state differs from reference evidence')

    resolved = read('mapped_validation', 'resolved.json')
    synth = read('mapped_validation', 'synthesis.json')
    timing = read('timing', 'timing_validation.json')
    require(resolved['case_name'] == record['case_id'] and resolved['mode'] == mode, 'mapped design is a different case/mode')
    require(resolved['config']['id'] == record['technology']['id'] and resolved['config']['liberty_sha256'] == record['technology']['liberty_sha256'], 'mapped technology differs')
    same(resolved['config']['clock']['period_ns'], record['period_ns'], 'clock period')
    for key, value in record['technology'].items():
        require(resolved['config'].get(key) == value, 'technology field differs from mapped evidence: ' + key)
    technology_digests = {hashlib.sha256(p.read_bytes()).hexdigest() for p in paths('technology')}
    require(record['technology']['liberty_sha256'] in technology_digests, 'bound Liberty bytes do not match reported technology')
    require(spec['technology_sha256'] in technology_digests, 'run technology configuration bytes are missing')
    require(resolved['binding'].get('technology_config_sha256') == spec['technology_sha256'], 'run/mapped technology configuration differs')
    require(synth.get('passed') is True and timing.get('passed') is True, 'mapped synthesis/timing did not pass')
    fingerprint = hashlib.sha256(json.dumps(resolved['binding'], sort_keys=True).encode()).hexdigest()
    require(resolved['design_fingerprint'] == synth['design_fingerprint'] == timing['design_fingerprint'] == fingerprint,
            'mapped design fingerprint differs')
    require(timing['binding'] == resolved['binding'], 'timing/source binding differs')
    require(resolved['binding']['case_manifest_sha256'] == digest('source', 'asic.json'), 'mapped case adapter differs')
    source_digests = {hashlib.sha256(p.read_bytes()).hexdigest() for p in paths('source')}
    mapped_digests = {hashlib.sha256(p.read_bytes()).hexdigest() for p in paths('mapped_validation')}
    linked_digests = {hashlib.sha256(p.read_bytes()).hexdigest()
                      for p in paths('linked_libraries')} if 'linked_libraries' in evidence else set()
    gate_sources = set(gate['sources'].values())
    require(gate_sources <= (source_digests | mapped_digests | linked_digests), 'mapped simulation input bytes differ')
    require(linked_digests <= gate_sources, 'linked library was not bound to the mapped build')
    require(digest('mapped_validation', 'mapped.v') in gate_sources, 'mapped simulation used another netlist')
    headers={value for name,value in rtl['sources'].items()
             if Path(name).suffix.lower() in ('.h','.hh','.hpp','.hxx')}
    headers.update(digest('source',Path(name).name) for name in model.get('dependency_sources',[]))
    require(headers <= gate_sources, 'mapped build lacks bound C++ header bytes')
    for receipt in (vector, rtl):
        require(set(receipt['sources'].values()) <= source_digests, 'reference or RTL source bytes missing from bundle')
    require(set(resolved['binding']['source_sha256'].values()) <= source_digests, 'mapped source bytes missing from bundle')
    for name, value in synth['outputs_sha256'].items():
        require(digest('mapped_validation', name) == value, 'synthesis artifact differs: ' + name)
    same(read('mapped_validation', 'stat.json')['design']['area'], config['area_um2'], 'mapped area')
    for field in ('setup', 'hold', 'max_capacitance', 'max_transition', 'constraint_coverage'):
        require(timing['checks'].get(field) is True, 'timing check is not supported by bound evidence: ' + field)
    for name, value in timing['hashes'].items():
        category = 'mapped_validation' if name in ('mapped.v', 'mapped.json', 'synthesis.json') else 'timing'
        require(digest(category, name) == value, 'timing artifact differs: ' + name)
    expected_activity = {window: read('activity', window + '.counts.json') for window in WINDOWS}
    readback = read('activity', 'activity_readback.json')
    power_log = one('power', 'power.log').read_text()
    verified = activity.validate_readback(power_log, expected_activity)
    require(all(readback.get(key) == value for key, value in verified.items()),
            'activity readback receipt differs from the bound power log and counts')
    require(readback.get('log_sha256') == digest('power', 'power.log'),
            'activity readback power log changed')
    input_hashes = set(readback.get('input_hashes', {}).values())
    for window in WINDOWS:
        require(digest('activity', window + '.counts.json') in input_hashes,
                'activity counts were not bound to the power analysis')
    for window in WINDOWS:
        counts = read('activity', window + '.counts.json')
        require(counts['trial_count'] == len(ids), 'activity population differs')
        same(counts['duration_ps'] / 1000, config['windows'][window]['duration_ns'], 'activity duration')
        report = one('power', window + '.power.txt').read_text()
        require('Power (Watts)' in report, 'power report must explicitly use Watts')
        totals = [line.split()[1:5] for line in report.splitlines() if line.startswith('Total ')]
        require(len(totals) == 1 and len(totals[0]) == 4, 'power report lacks a unique total')
        for key, value in zip(('internal', 'switching', 'leakage', 'total'), map(float, totals[0])):
            same(value, config['windows'][window]['power_w'][key], window + ' ' + key + ' power')
        if 'rng_register_power_w' in config['windows'][window]:
            text = one('power', window + '.rng.txt').read_text()
            lines = [line.split() for line in text.splitlines() if re.match(r'^\s*\d\.\d+e[+-]\d+', line)]
            require(len(lines) == synth['netlist_audit']['local_rng_registers'], 'RNG report population differs')
            same(sum(float(line[3]) for line in lines), config['windows'][window]['rng_register_power_w'], 'RNG subtotal')


def summarize(record, base, *, pilot=False):
    require(record['schema'] == 'asic_energy_v1', 'unsupported schema')
    require(record['status'] == ('diagnostic_smoke' if pilot else 'complete'), 'energy record has another profile or is incomplete')
    require(re.fullmatch(r'[0-9a-f]{64}', record['technology']['liberty_sha256']) is not None, 'Liberty hash required')
    finite(record['period_ns'], 'period_ns', True)
    require(record['measurement_model'] in ('prelayout_zero_delay', 'postroute', 'silicon'), 'measurement model required')
    require(record['activity_population'] == 'paired_predeclared', 'declare the activity population')
    require(record['boundary'], 'measurement boundary required')
    require(set(record['configurations']) == set(MODES), 'both modes required')
    ids = record['trial_ids']
    require(ids and all(type(i) is int and i >= 0 for i in ids) and len(ids) == len(set(ids)), 'unique trial IDs required')
    required = {'inputs', 'source', 'technology', 'rtl_validation', 'mapped_validation', 'timing', 'activity', 'power', 'run_spec'}
    all_modes = {}
    for mode in MODES:
        c = record['configurations'][mode]
        require(required <= set(c['evidence']), mode + ': missing evidence categories')
        for category, files in c['evidence'].items():
            require(isinstance(files, list) and files, category + ': evidence files required')
            for f in files:
                path = (base / f['path']).resolve()
                require(path.is_relative_to(base.resolve()), 'evidence must be inside result bundle')
                require(path.is_file(), 'missing evidence: ' + f['path'])
                require(hashlib.sha256(path.read_bytes()).hexdigest() == f['sha256'], 'evidence hash mismatch: ' + f['path'])
        checks = c['checks']
        for check in ('rtl_match', 'mapped_match', 'setup', 'hold', 'max_capacitance', 'max_transition', 'constraint_coverage', 'all_cell_pin_activity', 'zero_unknown_activity', 'power_activity_readback'):
            require(checks.get(check) is True, mode + ': failed or absent ' + check)
        trials = c['trials']
        require([t['trial'] for t in trials] == ids, mode + ': trial set differs')
        require(all(type(t['success']) is bool for t in trials), 'boolean success required')
        for t in trials:
            require(type(t['seed']) is int and t['seed'] >= 0, 'nonnegative integer seed required')
            require(re.fullmatch(r'[0-9a-f]{64}', t['initial_state_sha256']) is not None, 'initial-state SHA-256 required')
            for name in ('search_cycles', 'setup_cycles', 'fresh_words'):
                require(type(t[name]) is int, name + ' must be an integer')
            finite(t['search_cycles'], 'search cycles', True)
            finite(t['setup_cycles'], 'setup cycles')
            finite(t['fresh_words'], 'fresh words')
        bound_results(record, mode, c, base, pilot=pilot)
        n = len(ids)
        hits = sum(t['success'] for t in trials)
        p = hits/n
        finite(c['area_um2'], 'area', True)
        energies, powers, latencies = {}, {}, {}
        for window in WINDOWS:
            w = c['windows'][window]
            duration = sum(t['search_cycles'] + (t['setup_cycles'] if window == 'with_setup' else 0) for t in trials)*record['period_ns']
            require(math.isclose(duration, w['duration_ns'], rel_tol=1e-10, abs_tol=1e-3), 'activity duration and trial cycles differ')
            components = {k:finite(w['power_w'][k], k) for k in ('internal', 'switching', 'leakage', 'total')}
            require(math.isclose(sum(components[k] for k in ('internal', 'switching', 'leakage')), components['total'], rel_tol=1e-5, abs_tol=1e-15), 'power components do not sum to total')
            energies[window] = {k: v*duration/n for k,v in components.items()}
            powers[window] = {k: v*1000 for k,v in components.items()}
            latencies[window] = duration/n/1000
            if 'rng_register_power_w' in w:
                rng_power=finite(w['rng_register_power_w'], 'RNG register power')
                require(rng_power <= components['total']*(1+1e-5)+1e-15, 'RNG subtotal exceeds total')
                energies[window]['rng_registers']=rng_power*duration/n
        all_modes[mode] = dict(trials=n, successes=hits, success_rate=p, success_wilson95=wilson(hits,n),
                              mean_search_cycles=sum(t['search_cycles'] for t in trials)/n,
                              mean_fresh_words=sum(t['fresh_words'] for t in trials)/n,
                              area_um2=c['area_um2'], mean_energy_nj=energies,
                              mean_power_mw=powers, mean_latency_us=latencies,
                              expected_energy_to_success_nj=energies['with_setup']['total']/p if p else None,
                              K99_empirical=1 if p==1 else math.ceil(math.log(.01)/math.log1p(-p)) if p else None)
    for a,b in zip(record['configurations']['baseline']['trials'], record['configurations']['epix']['trials']):
        require(a['seed'] == b['seed'] and a['initial_state_sha256'] == b['initial_state_sha256'], 'seed/state pairing differs')
    a,b = [all_modes[m] for m in MODES]
    comparison = dict(status=record['status'], profile='pilot' if pilot else 'full', case_id=record['case_id'], technology=record['technology'], period_ns=record['period_ns'],
                      measurement_model=record['measurement_model'], boundary=record['boundary'], configurations=all_modes,
                      search_energy_saving_percent=saving(a['mean_energy_nj']['search']['total'], b['mean_energy_nj']['search']['total']),
                      setup_inclusive_energy_saving_percent=saving(a['mean_energy_nj']['with_setup']['total'], b['mean_energy_nj']['with_setup']['total']),
                      setup_inclusive_power_saving_percent=saving(a['mean_power_mw']['with_setup']['total'], b['mean_power_mw']['with_setup']['total']),
                      setup_inclusive_latency_saving_percent=saving(a['mean_latency_us']['with_setup'], b['mean_latency_us']['with_setup']),
                      area_saving_percent=saving(a['area_um2'], b['area_um2']),
                      fresh_word_saving_percent=saving(a['mean_fresh_words'], b['mean_fresh_words']),
                      expected_energy_to_success_saving_percent=saving(a['expected_energy_to_success_nj'], b['expected_energy_to_success_nj']) if a['success_rate'] and b['success_rate'] else None,
                      energy_uncertainty='Not estimated from pooled activity; success intervals are reported separately.')
    return comparison


def render(x):
    a,b = [x['configurations'][m] for m in MODES]
    rows = [('Attempted trials',a['trials'],b['trials']),('Exact successes', a['successes'], b['successes']), ('Success rate',a['success_rate'],b['success_rate']), ('Mean search cycles', a['mean_search_cycles'], b['mean_search_cycles']),
            ('Mean fresh words', a['mean_fresh_words'], b['mean_fresh_words']), ('Mapped area (um2)',a['area_um2'],b['area_um2'])]
    for w in WINDOWS:
        rows.append((w+' mean power (mW)',a['mean_power_mw'][w]['total'],b['mean_power_mw'][w]['total']))
        rows.append((w+' mean latency (us)',a['mean_latency_us'][w],b['mean_latency_us'][w]))
        for k in ('internal','switching','leakage','total'):
            rows.append((w+' '+k+' energy (nJ)',a['mean_energy_nj'][w][k],b['mean_energy_nj'][w][k]))
        if all('rng_registers' in c['mean_energy_nj'][w] for c in (a,b)):
            rows.append((w+' local RNG-register energy (nJ)',a['mean_energy_nj'][w]['rng_registers'],b['mean_energy_nj'][w]['rng_registers']))
    lines = ['# '+x['case_id']+' energy comparison', '', 'Technology: '+x['technology']['id']+'. Model: '+x['measurement_model']+'.', '',
             '| Metric | IID | EPIX |', '|---|---:|---:|']
    lines += ['| %s | %.9g | %.9g |'%r for r in rows]
    for mode,c in (('IID',a),('EPIX',b)):
        interval=c['success_wilson95']
        value=c['expected_energy_to_success_nj']
        text='unresolved (zero observed successes)' if value is None else '%.9g nJ'%value
        lines += ['', '%s success rate 95%% Wilson interval: [%.6f, %.6f]. Expected energy to first success under independent restarts: %s.'%(mode,interval[0],interval[1],text)]
    saving_value = x['setup_inclusive_energy_saving_percent']
    saving_text = 'Unresolved because baseline energy is zero.' if saving_value is None else '%.6f%%. Negative means increased energy.'%saving_value
    lines += ['', 'Setup-inclusive saving: '+saving_text, '',
              x['energy_uncertainty'], '', 'Boundary: '+x['boundary'], '']
    success_saving=x['expected_energy_to_success_saving_percent']
    lines += ['Success-adjusted estimated energy saving: '+('unresolved.' if success_saving is None else '%.6f%%.'%success_saving), '']
    return '\n'.join(lines)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('record', type=Path)
    p.add_argument('--output', type=Path, required=True)
    a=p.parse_args()
    result=summarize(json.loads(a.record.read_text()),a.record.resolve().parent)
    a.output.mkdir(parents=True,exist_ok=False)
    (a.output/'SUMMARY.json').write_text(json.dumps(result,indent=2,allow_nan=False)+'\n')
    (a.output/'RESULTS.md').write_text(render(result))
    print(a.output/'RESULTS.md')

if __name__=='__main__': main()
