# TRENDY extraction → Figure 1 test repository

This repository tests the reproducible pipeline for:

1. extracting annual GPP and wood carbon (`cWood`) from TRENDYv10 at the
   31 Cabon et al. flux-tower/tree-ring sites; and
2. generating manuscript Figure 1 from those extracted files.

Large TRENDY NetCDF files are deliberately kept outside Git. Their location is
provided through `TRENDY_INPUT_DIR`.

## Repository layout

```text
.
├── code/
│   ├── TRENDY_extraction_flux_locations_clean.ipynb
│   └── Figure1_code_clean.Rmd
├── data/README.md
├── results/README.md
├── environment.yml
├── install-r-packages.R
└── Makefile
```

## 1. Create the Python environment

```bash
conda env create -f environment.yml
conda activate source-sink-trendy
```

## 2. Install R packages

```bash
Rscript install-r-packages.R
```

## 3. Configure external data

```bash
export TRENDY_INPUT_DIR="/path/to/TRENDYv10/downloads"
export CABON_DATA_DIR="/path/to/cabon"
```

`TRENDY_INPUT_DIR` must contain one directory per model, with files named
`<MODEL>_<SCENARIO>_<VARIABLE>.nc`. `CABON_DATA_DIR` must contain
`Cabonetal_site_info.csv`, `rw_onsite.csv`, and `flux_onsite.csv`.

## 4. Validate and run

Run a small extraction test using CABLE-POP/S2:

```bash
make smoke-test
```

Run the complete nine-model, three-scenario extraction:

```bash
make extract
```

Generate Figure 1 after the complete extraction finishes:

```bash
make figure1
```

Run extraction followed by Figure 1:

```bash
make all
```

Generated CSV files and plots are written under `results/` and ignored by Git.

## Output contract

The extraction notebook creates:

```text
results/TRENDYv10/31_site_weighted/<MODEL>/
├── <MODEL>_site_info.csv
├── gpp_<SCENARIO>_31_site_weighted_yearly_mean.csv
└── cWood_<SCENARIO>_31_site_weighted_yearly_mean.csv
```

`Figure1_code_clean.Rmd` reads exactly these paths.
