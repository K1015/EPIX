#!/usr/bin/env python3
from pathlib import Path
import sys
CASE = Path(__file__).resolve().parent
sys.path.insert(0, str(CASE.parents[1] / "software/categorical_hardware"))
from portable import main
if __name__ == "__main__":
    main(CASE)
