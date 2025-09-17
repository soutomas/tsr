
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tsr

<!-- badges: start -->
<!-- badges: end -->

The goal of tsr is to provide some convenient functions for users on
some common tasks during exploratory graphical analysis (EDA).

## Installation

You can install the development version of tsr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("soutomas/tsr")
```

## Example

Commonly, we want to add a label indicating the source file in the
output.

``` r
library(tsr)

# Generate label of current file with run time 
lab1 = label_src(1)
```

<!-- You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this. -->
