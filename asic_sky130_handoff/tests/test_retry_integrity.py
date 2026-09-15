"""Synthetic guard/evidence tests; no solver, compiler or CAD jobs are run."""
import argparse
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

import test_energy_reporting as fixture_module

parser = argparse.ArgumentParser()
parser.add_argument('--flow', type=Path, default=Path(__file__).resolve().parents[1] / 'flow')
options, remaining = parser.parse_known_args()
sys.path.insert(0, str(options.flow.resolve()))
import power
report = power.report_energy


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class RetryGuards(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix='synthetic-retry-')
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name).resolve()
        self.out = self.root / 'out'
        self.out.mkdir()
        self.tech = self.root / 'tech.json'
        self.tech.write_text('{}')
        self.model = dict(prefix='Vcorrected_solver', boundary='Synthetic guard only',
                          fresh_word_fields=['local_words'], setup_rng_words=0)
        saved = dict(case_id='case', boundary=self.model['boundary'], trials=1,
                     trial_ids=[0], smoke=True, technology_sha256=sha(self.tech),
                     measurement_model='prelayout_zero_delay',
                     fresh_words=dict(counter_fields=['local_words'], setup_words=0))
        (self.out / 'RUN_SPEC.json').write_text(json.dumps(saved))
        for mode in ('baseline', 'epix'):
            (self.out / (mode + '_gate')).mkdir()

    def call_main(self):
        args = ['power.py', '--case', str(self.root / 'case'), '--tech', str(self.tech),
                '--reference-work', str(self.root / 'reference'),
                '--mapped-root', str(self.root / 'mapped'), '--output', str(self.out),
                '--smoke', '--trials', '1', '--resume-build']
        with patch.object(sys, 'argv', args), patch.object(power, 'adapter', return_value=self.model), \
                patch.object(power, 'validate_inputs'), patch.object(power, 'simulate') as simulation, \
                patch.object(power, 'energy'):
            power.main()
            self.assertTrue(simulation.called)

    def test_retry_accepts_an_unlinked_build(self):
        self.call_main()

    def test_retry_rejects_a_linked_binary_in_either_mode(self):
        for mode in ('baseline', 'epix'):
            executable = self.out / (mode + '_gate') / 'Vcorrected_solver'
            executable.write_bytes(b'synthetic existing executable')
            with self.subTest(mode=mode), self.assertRaisesRegex(ValueError, 'already exists'):
                self.call_main()
            executable.unlink()

    def test_retry_still_rejects_started_simulation(self):
        (self.out / 'baseline_gate' / 'simulation.log').write_text('started')
        with self.assertRaisesRegex(ValueError, 'simulation already started'):
            self.call_main()

    def test_linked_archive_is_checked_again_before_copying(self):
        library = self.root / 'liblz4.a'
        library.write_bytes(b'synthetic linked archive')
        (self.out / 'validation.json').write_text(json.dumps({'sources': {str(library): sha(library)}}))
        self.assertEqual(power.linked_libraries(self.out, library), [library])
        library.write_bytes(b'different archive after simulation')
        with self.assertRaisesRegex(ValueError, 'changed after mapped simulation'):
            power.linked_libraries(self.out, library)

    def test_no_optional_archive_requires_no_library_evidence(self):
        self.assertEqual(power.linked_libraries(self.out, None), [])


class LinkedEvidenceClosure(unittest.TestCase):
    def setUp(self):
        fixture = fixture_module.EnergyReportingTests()
        fixture.setUp()
        self.addCleanup(fixture.doCleanups)
        self.base = fixture.base.resolve()
        self.record = fixture.record

    def archive(self, *, included=True, bound=True):
        configuration = self.record['configurations']['baseline']
        evidence = configuration['evidence']
        library = self.base / 'baseline' / 'linked_libraries_liblz4.a'
        library.write_bytes(b'synthetic LZ4 archive, not executable code')
        digest = sha(library)
        if included:
            evidence['linked_libraries'] = [dict(path=str(library.relative_to(self.base)), sha256=digest)]
        if bound:
            entry = next(item for item in evidence['mapped_validation']
                         if item['path'].endswith('_validation.json'))
            receipt_path = self.base / entry['path']
            receipt = json.loads(receipt_path.read_text())
            receipt['sources']['/synthetic/link/liblz4.a'] = digest
            receipt_path.write_text(json.dumps(receipt))
            entry['sha256'] = sha(receipt_path)
        return library

    def test_complete_linked_source_bytes_are_accepted(self):
        self.archive()
        result = report.summarize(self.record, self.base)
        self.assertEqual(result['configurations']['baseline']['trials'], 32)

    def test_missing_library_category_breaks_build_source_closure(self):
        self.archive(included=False)
        with self.assertRaisesRegex(ValueError, 'mapped simulation input bytes differ'):
            report.summarize(self.record, self.base)

    def test_replaced_archive_rejected_even_when_its_bundle_hash_is_updated(self):
        library = self.archive()
        library.write_bytes(b'replacement library')
        self.record['configurations']['baseline']['evidence']['linked_libraries'][0]['sha256'] = sha(library)
        with self.assertRaisesRegex(ValueError, 'mapped simulation input bytes differ'):
            report.summarize(self.record, self.base)

    def test_unused_library_cannot_be_added_as_build_evidence(self):
        self.archive(bound=False)
        with self.assertRaisesRegex(ValueError, 'not bound to the mapped build'):
            report.summarize(self.record, self.base)


if __name__ == '__main__':
    unittest.main(argv=[sys.argv[0], *remaining], verbosity=2)
