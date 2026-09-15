"""Synthetic checks for readback, resume safety and incomplete-suite reporting."""
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import threading
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path[:0] = [str(ROOT / 'scripts'), str(ROOT / 'flow')]
import report_energy
import report_suite
import run_energy_suite as runner
import test_energy_reporting as fixture_module


class ReadbackAndProfileTests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixture_module.EnergyReportingTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.record, self.base = self.fixture.record, self.fixture.base

    def edit(self, category, suffix, change, mode='baseline'):
        entry = next(row for row in self.record['configurations'][mode]['evidence'][category]
                     if row['path'].endswith(suffix))
        path = self.base / entry['path']
        if suffix.endswith('.json'):
            value = json.loads(path.read_text())
            change(value)
            path.write_text(json.dumps(value))
        else:
            path.write_text(change(path.read_text()))
        entry['sha256'] = hashlib.sha256(path.read_bytes()).hexdigest()

    def test_missing_readback_flag_rejected(self):
        del self.record['configurations']['baseline']['checks']['power_activity_readback']
        with self.assertRaisesRegex(ValueError, 'power_activity_readback'):
            report_energy.summarize(self.record, self.base)

    def test_missing_phase_rejected_even_with_updated_log_hash(self):
        self.edit('power', 'power.log', lambda text: '\n'.join(text.splitlines()[:-1]) + '\n')
        with self.assertRaisesRegex(ValueError, 'Missing activity readback phase'):
            report_energy.summarize(self.record, self.base)

    def test_false_readback_receipt_rejected_with_updated_file_hash(self):
        self.edit('activity', 'activity_readback.json', lambda value: value.update(passed=False))
        with self.assertRaisesRegex(ValueError, 'receipt differs'):
            report_energy.summarize(self.record, self.base)

    def test_counts_must_be_bound_to_power(self):
        self.edit('activity', 'activity_readback.json', lambda value: value.update(input_hashes={}))
        with self.assertRaisesRegex(ValueError, 'counts were not bound'):
            report_energy.summarize(self.record, self.base)

    def pilot(self):
        self.record['status'] = 'diagnostic_smoke'
        self.record['trial_ids'] = [0, 1, 2]
        for values in self.record['configurations'].values():
            values['trials'] = values['trials'][:3]
            for window in ('search', 'with_setup'):
                values['windows'][window]['duration_ns'] = sum(
                    trial['search_cycles'] + (trial['setup_cycles'] if window == 'with_setup' else 0)
                    for trial in values['trials']) * self.record['period_ns']
        self.fixture.sync_evidence()
        for mode in ('baseline', 'epix'):
            self.edit('run_spec', 'RUN_SPEC.json', lambda value: value.update(smoke=True), mode)
        return report_energy.summarize(self.record, self.base, pilot=True)

    def test_pilot_preserves_negative_savings_and_cannot_be_full(self):
        result = self.pilot()
        self.assertEqual(result['status'], 'diagnostic_smoke')
        self.assertAlmostEqual(result['setup_inclusive_energy_saving_percent'], -50)
        with self.assertRaises(ValueError):
            report_energy.summarize(self.record, self.base)

    def test_full_result_cannot_be_relabelled_pilot(self):
        with self.assertRaises(ValueError):
            report_energy.summarize(self.record, self.base, pilot=True)


class SuiteSafetyTests(unittest.TestCase):
    def test_changed_source_binding_requires_new_run(self):
        runner.require_same_binding({'solver.sv': 'a'}, {'solver.sv': 'a'})
        with self.assertRaisesRegex(ValueError, 'changed'):
            runner.require_same_binding({'solver.sv': 'a'}, {'solver.sv': 'b'})

    def test_new_attempt_never_replaces_old_outputs(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            first = runner.next_attempt(directory, 'energy')
            (first / 'result').write_text('original')
            second = runner.next_attempt(directory, 'energy')
            self.assertNotEqual(first, second)
            self.assertEqual((first / 'result').read_text(), 'original')

    def test_resource_floor_blocks_before_work(self):
        with patch.object(runner.shutil, 'disk_usage') as usage:
            usage.return_value.free = 5 * 2**30
            with self.assertRaisesRegex(ValueError, 'GiB free'):
                runner.resources(Path(tempfile.gettempdir()), 20)

    def test_pending_cases_have_empty_energy_cells(self):
        with tempfile.TemporaryDirectory() as temporary:
            work = Path(temporary)
            (work / 'SUITE.json').write_text(json.dumps(dict(profile='pilot',
                functional_trials=3, activity_trials=3, case_ids=['maxcut32', 'sat32'])))
            data = report_suite.write_reports(work)
            self.assertEqual(data['completed_cases'], 0)
            self.assertTrue(all('configurations' not in row for row in data['cases']))
            import csv
            with (work / 'ENERGY.csv').open() as stream:
                rows = list(csv.DictReader(stream))
            self.assertTrue(all(row['with_setup_energy_nj'] == '' for row in rows))
            self.assertEqual(len(rows), 4)

    def test_parallel_cases_keep_states_separate_and_report_on_main_thread(self):
        case_ids = ['maxcut32', 'sat32', 'chimera32', 'xorsat32']
        main_thread = threading.get_ident()
        barrier = threading.Barrier(2)
        mutex = threading.Lock()
        calls, report_threads = [], []
        active = peak = 0
        with tempfile.TemporaryDirectory() as temporary:
            work = Path(temporary)

            def fake_case(case_id, directory, args, suite):
                nonlocal active, peak
                with mutex:
                    calls.append(case_id)
                    active += 1
                    peak = max(peak, active)
                case = directory / case_id
                case.mkdir()
                runner.write(case / 'state.json', dict(case_id=case_id, status='running'))
                barrier.wait(timeout=5)
                state = dict(case_id=case_id, status='pending' if case_id == 'sat32' else 'done')
                if case_id == 'sat32':
                    state['error'] = 'synthetic failure'
                runner.write(case / 'state.json', state)
                with mutex:
                    active -= 1
                if case_id == 'sat32':
                    raise RuntimeError('synthetic failure')

            def report(directory):
                report_threads.append(threading.get_ident())
                return report_suite.write_reports(directory)

            arguments = ['run_energy_suite.py', '--work', str(work), '--profile', 'pilot',
                         '--case-jobs', '2', '--cases', *case_ids, 'maxcut32']
            with patch.object(sys, 'argv', arguments), patch.object(runner, 'run_case', fake_case), \
                    patch.object(runner, 'write_reports', report):
                with self.assertRaises(SystemExit) as stopped:
                    runner.main()
            self.assertEqual(stopped.exception.code, 1)
            self.assertEqual(sorted(calls), sorted(case_ids))
            self.assertEqual(peak, 2)
            self.assertEqual(report_threads, [main_thread] * len(case_ids))
            for case_id in case_ids:
                state = json.loads((work / case_id / 'state.json').read_text())
                self.assertEqual(state['case_id'], case_id)
                self.assertEqual(state['status'], 'pending' if case_id == 'sat32' else 'done')
            self.assertEqual(json.loads((work / 'ENERGY.json').read_text())['completed_cases'], 0)
            self.assertFalse(list(work.rglob('*.tmp')))

    def test_changed_energy_record_not_reused(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            (directory / 'run').mkdir()
            (directory / 'run/energy_record.json').write_text('{}')
            state = dict(energy=dict(directory='run', record_sha256='0' * 64))
            with self.assertRaisesRegex(ValueError, 'record changed'):
                report_suite.summarize_case('maxcut32', state, directory, 'pilot')


if __name__ == '__main__':
    unittest.main()
