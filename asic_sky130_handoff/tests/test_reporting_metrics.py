"""Check units and paired metrics in the experiment reports."""
import csv
import sys
import unittest
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path[:0] = [str(ROOT / 'scripts'), str(ROOT / 'flow')]
import report_suite
import test_energy_reporting as fixtures


class HandoffReportingTests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixtures.EnergyReportingTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)

    def test_power_latency_and_energy_share_the_activity_window(self):
        result = self.fixture.summarize()['configurations']['baseline']
        self.assertAlmostEqual(result['mean_power_mw']['with_setup']['total'], 4)
        self.assertAlmostEqual(result['mean_latency_us']['with_setup'], 2.2)
        self.assertAlmostEqual(result['mean_latency_us']['search'], 2)
        self.assertAlmostEqual(result['mean_energy_nj']['with_setup']['total'], 8.8)

    def test_comparisons_use_each_cases_iid_and_keep_area_increases(self):
        epix = self.fixture.record['configurations']['epix']
        epix['area_um2'] = 120
        for trial in epix['trials']:
            trial['search_cycles'] //= 2
        for name, window in epix['windows'].items():
            window['duration_ns'] = sum(t['search_cycles'] + (t['setup_cycles'] if name == 'with_setup' else 0)
                                        for t in epix['trials']) * 100
            window['power_w'] = dict(internal=.001, switching=.001, leakage=.001, total=.003)
        self.fixture.sync_evidence()
        result = self.fixture.summarize()
        self.assertAlmostEqual(result['setup_inclusive_power_saving_percent'], 25)
        self.assertAlmostEqual(result['setup_inclusive_latency_saving_percent'], 100*(1-1.2/2.2))
        self.assertAlmostEqual(result['setup_inclusive_energy_saving_percent'], 100*(1-3.6/8.8))
        self.assertAlmostEqual(result['area_saving_percent'], -20)

    def test_csv_exposes_the_four_metrics_with_units(self):
        result = self.fixture.summarize()
        data = dict(profile='full', functional_trials=1000, activity_trials=32, completed_cases=1,
                    note='Synthetic unit conversion fixture.', cases=[result])
        with patch.object(report_suite, 'collect', return_value=data):
            report_suite.write_reports(self.fixture.base)
        with (self.fixture.base / 'ENERGY.csv').open() as stream:
            rows = list(csv.DictReader(stream))
        self.assertEqual([r['mode'] for r in rows], ['IID', 'EPIX'])
        self.assertAlmostEqual(float(rows[0]['with_setup_power_mw']), 4)
        self.assertAlmostEqual(float(rows[0]['with_setup_latency_us']), 2.2)
        self.assertAlmostEqual(float(rows[0]['with_setup_energy_nj']), 8.8)
        self.assertEqual(float(rows[0]['area_um2']), 100)


if __name__ == '__main__':
    unittest.main()
