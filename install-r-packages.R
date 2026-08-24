packages <- c("dplyr", "ggplot2", "knitr", "patchwork", "purrr", "rmarkdown", "tidyr")
missing <- setdiff(packages, rownames(installed.packages()))

if (length(missing) > 0) {
  install.packages(missing, repos = "https://cloud.r-project.org")
}
