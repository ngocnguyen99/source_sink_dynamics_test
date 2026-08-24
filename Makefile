PYTHON ?= python
JUPYTER ?= jupyter
R_SCRIPT ?= Rscript

.PHONY: all syntax-check validate smoke-test extract figure1 clean

all: extract figure1

syntax-check:
	$(PYTHON) scripts/validate_notebook.py \
	code/TRENDY_extraction_flux_locations_clean.ipynb
	$(R_SCRIPT) -e 'knitr::purl("code/Figure1_code_clean.Rmd", output=tempfile(fileext=".R"), quiet=TRUE)' >/dev/null

validate:
	@test -n "$(TRENDY_INPUT_DIR)" || (echo "Set TRENDY_INPUT_DIR" && exit 1)
	@test -d "$(TRENDY_INPUT_DIR)" || (echo "TRENDY_INPUT_DIR does not exist" && exit 1)
	@test -n "$(CABON_DATA_DIR)" || (echo "Set CABON_DATA_DIR" && exit 1)
	@test -d "$(CABON_DATA_DIR)" || (echo "CABON_DATA_DIR does not exist" && exit 1)

smoke-test: syntax-check validate
	SOURCE_SINK_ROOT="$(CURDIR)" \
	TRENDY_INPUT_DIR="$(TRENDY_INPUT_DIR)" \
	CABON_DATA_DIR="$(CABON_DATA_DIR)" \
	TRENDY_MODELS=CABLE-POP TRENDY_SCENARIOS=S2 \
	$(PYTHON) scripts/run_notebook.py \
	code/TRENDY_extraction_flux_locations_clean.ipynb

extract: validate
	SOURCE_SINK_ROOT="$(CURDIR)" \
	TRENDY_INPUT_DIR="$(TRENDY_INPUT_DIR)" \
	CABON_DATA_DIR="$(CABON_DATA_DIR)" \
	$(PYTHON) scripts/run_notebook.py \
	code/TRENDY_extraction_flux_locations_clean.ipynb

figure1: validate
	SOURCE_SINK_ROOT="$(CURDIR)" CABON_DATA_DIR="$(CABON_DATA_DIR)" \
	$(R_SCRIPT) -e 'rmarkdown::render("code/Figure1_code_clean.Rmd")'

clean:
	@echo "Generated results are under results/. Remove them manually if desired."
