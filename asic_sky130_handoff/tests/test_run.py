"""Check that the entry point dispatches the requested paired experiments."""
import importlib.util
from pathlib import Path
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('asic_run', ROOT / 'run.py')
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)


class RunTests(unittest.TestCase):
    def test_validation_uses_both_modes_and_requested_trials(self):
        with patch.object(runner.subprocess, 'run') as run:
            runner.main(['--validate-only', '--cases', 'maxcut128', 'sat128', 'maxcut128',
                         '--trials', '3', '--work', 'build/rtl'])
        self.assertEqual(run.call_count, 2)
        for call, case in zip(run.call_args_list, ('maxcut128', 'sat128')):
            command = call.args[0]
            self.assertEqual(Path(command[1]), ROOT / 'cases' / case / 'portable.py')
            self.assertEqual(command[command.index('--mode') + 1], 'both')
            self.assertEqual(command[command.index('--trials') + 1], '3')
            self.assertEqual(Path(command[command.index('--work-dir') + 1]).name, case)

    def test_energy_keeps_priority_order_and_selected_profile(self):
        with patch.object(runner.subprocess, 'run') as run:
            runner.main(['--profile', 'pilot', '--work', 'runs/pilot'])
        command = run.call_args.args[0]
        self.assertEqual(Path(command[1]), ROOT / 'scripts/run_energy_suite.py')
        start, end = command.index('--cases') + 1, command.index('--case-jobs')
        self.assertEqual(command[start:end], list(runner.RUN_ORDER))
        self.assertEqual(command[command.index('--profile') + 1], 'pilot')


if __name__ == '__main__':
    unittest.main()
