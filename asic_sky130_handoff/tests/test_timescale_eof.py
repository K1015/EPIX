"""Exercise only the trace reader using tiny synthetic VCD inputs."""
import argparse
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

parser = argparse.ArgumentParser()
parser.add_argument('--source', type=Path, default=Path(__file__).resolve().parents[1] / 'flow/activity_fast.cpp')
options, remaining = parser.parse_known_args()


class TimescaleEOF(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temporary = tempfile.TemporaryDirectory(prefix='synthetic-timescale-')
        cls.addClassCleanup(cls.temporary.cleanup)
        cls.root = Path(cls.temporary.name)
        cls.executable = cls.root / 'reader'
        compiler = os.environ.get('CXX', 'c++')
        flags = []
        if sys.platform == 'darwin':
            compiler = subprocess.check_output(['xcrun', '--find', 'clang++'], text=True).strip()
            sdk = subprocess.check_output(['xcrun', '--sdk', 'macosx', '--show-sdk-path'], text=True).strip()
            flags = ['-isysroot', sdk]
        subprocess.run([compiler, *flags, '-std=c++17', '-O2', str(options.source),
                        '-o', str(cls.executable)], check=True, timeout=60)
        (cls.root / 'targets.tsv').write_text('0\t0\tcorrected_solver/clk\n')
        (cls.root / 'windows.tsv').write_text('0\t10\t20\n1\t10\t20\n')

    def run_reader(self, trace):
        output = self.root / 'counts.tsv'
        output.unlink(missing_ok=True)
        result = subprocess.run([str(self.executable), str(self.root / 'targets.tsv'),
                                 str(self.root / 'windows.tsv'), str(output)],
                                input=trace, capture_output=True, text=True, timeout=2)
        return result, output

    def test_unterminated_single_line_timescale_fails_without_hanging(self):
        result, output = self.run_reader('$timescale 1ps\n')
        self.assertEqual(result.returncode, 2)
        self.assertIn('Truncated VCD timescale declaration', result.stderr)
        self.assertFalse(output.exists())

    def test_unterminated_multiline_timescale_fails_without_hanging(self):
        result, output = self.run_reader('$timescale\n  1ps\n  \n')
        self.assertEqual(result.returncode, 2)
        self.assertIn('Truncated VCD timescale declaration', result.stderr)
        self.assertFalse(output.exists())

    def test_valid_timescales_keep_identical_counts(self):
        body = ('$scope module TOP $end\n$scope module corrected_solver $end\n'
                '$var wire 1 ! clk $end\n$upscope $end\n$upscope $end\n'
                '$enddefinitions $end\n#0\n0!\n#10\n1!\n#15\n0!\n#20\n')
        for header in ('$timescale 1ps $end\n', '$timescale\n 1ps\n$end\n'):
            with self.subTest(header=header):
                result, output = self.run_reader(header + body)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(output.read_text(), '0\t2\t5\t0\t2\t5\t0\n')


if __name__ == '__main__':
    unittest.main(argv=[sys.argv[0], *remaining], verbosity=2)
