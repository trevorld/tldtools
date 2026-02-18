# tldtools

[![CRAN Status Badge](https://www.r-pkg.org/badges/version/tldtools)](https://cran.r-project.org/package=tldtools)
[![R-CMD-check](https://github.com/trevorld/tldtools/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/trevorld/tldtools/actions)

### Table of Contents

* [Overview](#overview)
* [Installation](#installation)
* [Examples](#examples)
* [Related Links](#links)

## <a name="overview">Overview</a>

This package provides functions that help me set up my GitHub repositories and R packages the way I like them.

## <a name="installation">Installation</a>

```r
remotes::install_github("trevorld/tldtools")
```

You also need to install the [`gh` command](https://cli.github.com/) and
afterwards in a terminal run `gh auth login` to authenticate with your GitHub account or alternatively
set an appropriate `GITHUB_TOKEN` environmental variable.

## <a name="examples">Examples</a>


``` r
# requires `gh` installed and authenticated and working directory in Github repository
library("tldtools")
check_github_actions()
```

```
## ✔ `.github/workflows/R-CMD-check.yaml` is as expected
## ✔ `.github/workflows/air-check.yaml` is as expected
## ✖ `.github/workflows/test-coverage.yaml` does not exist
## ✔ Expected patterns in `.Rbuildignore`
## ✖ `CODECOV_TOKEN` is not a repository secret
```

``` r
check_github_labels()
```

```
## ✔ GitHub does not have extra labels
## ✔ GitHub is not missing labels
## ✔ Label descriptions are as expected
## ✔ Label colors are as expected
```

``` r
check_github_settings()
```

```
## ✔ Merge settings okay
## ✔ Has non-empty description
## ✔ Has non-empty homepage URL
## ✔ GitHub feature settings okay
```


``` r
library("tldtools")
check_air()
```

```
## ✔ `.air.toml` is as expected
## ✔ `.editorconfig` is as expected
## ✔ `.pre-commit-config.yaml` is as expected
## ✔ `.github/workflows/air-check.yaml` is as expected
## ✔ Pre-commit hook installed
## ✔ Expected patterns in `.Rbuildignore`
```


``` r
library("tldtools")
check_filenames()
```

```
## ✔ All R files use `.R` extension
## ✔ No `raw-data` directory found
```

## <a name="links">Related Links</a>

* [`{devtools}` R package](https://github.com/r-lib/devtools)
* [`{ghcli}` R package](https://github.com/trevorld/ghcli)
* [`{usethis}` R package](https://github.com/r-lib/usethis)
