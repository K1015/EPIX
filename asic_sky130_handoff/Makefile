PYTHON ?= python3
CASES ?= $(foreach size,128 288 512 800 32,$(addsuffix $(size),maxcut chimera sat xorsat))
TRIALS ?= 3
JOBS ?= 2
BUILD_TIMEOUT ?= 14400
RUN_TIMEOUT ?= 7200
TECH ?= tech/sky130_hd/config_200ns.json
PROFILE ?= full
WORK ?= build/energy_$(PROFILE)
.PHONY: check prepare validate-suite energy
check:
	$(PYTHON) scripts/verify_cases.py
	$(PYTHON) scripts/verify_rng_architecture.py
	$(PYTHON) flow/test_cad.py
	$(PYTHON) flow/test_power_contract.py
	$(PYTHON) -m unittest discover -s tests -p 'test_*.py'
	$(PYTHON) -m unittest discover -s software/categorical_hardware -p 'test_*.py'
	$(PYTHON) -m unittest discover -s software/categorical_hardware/sized -p 'test_*.py'
	$(PYTHON) software/chimera_hardware/test_generalized.py
	$(PYTHON) software/maxcut_hardware/test_reference.py
	$(PYTHON) software/maxcut_hardware/test_banked_rng.py
prepare:
	@for case_id in $(CASES); do \
	  for mode in baseline epix; do \
	    $(PYTHON) flow/cad.py prepare --case cases/$$case_id --tech $(TECH) --mode $$mode --work build/cad_prepared || exit $$?; \
	  done; \
	done
validate-suite:
	$(PYTHON) run.py --validate-only --cases $(CASES) --trials $(TRIALS) --jobs $(JOBS) --build-timeout $(BUILD_TIMEOUT) --run-timeout $(RUN_TIMEOUT) --work build/rtl
energy:
	$(PYTHON) run.py --work $(WORK) --profile $(PROFILE) --cases $(CASES) --jobs $(JOBS)
