# chlorpromazineR: Convert antipsychotic doses to chlorpromazine equivalents

[![Travis build status](https://travis-ci.org/ropensci/chlorpromazineR.svg?branch=master)](https://travis-ci.org/ropensci/chlorpromazineR) [![Coverage status](https://codecov.io/gh/ropensci/chlorpromazineR/branch/master/graph/badge.svg)](https://codecov.io/github/ropensci/chlorpromazineR?branch=master) [![DOI](https://zenodo.org/badge/175675220.svg)](https://zenodo.org/badge/latestdoi/175675220) [![](https://badges.ropensci.org/307_status.svg)](https://github.com/ropensci/onboarding/issues/307)

Studies investigating or controlling for the impact of antipsychotic medications often need to quantify the amount of medication to which an individual is or has been exposed. As different antipsychotics have different potencies, the task is more complicated than using each medication’s daily dosage in milligrams, for example. `chlorpromazineR` is an R package to calculate dose equivalents for common oral and injectable antipsychotic medications based on conversion factors from the published literature. We do not propose to suggest which conversion factors are appropriate to use, or how to interpret the converted data. All users should also refer to the papers from which the conversion factor data originates to determine whether the use of such data is appropriate for their study.

We hope that this package is of use to scientists who do clinical research involving antipsychotic medications. Specifically, the goals of this package are:

* to improve transparency and consistency in calculating chlorpromazine equivalents,
* to reduce human error and improve accuracy,
* and to simplify workflows for large datasets, as from chart reviews of electronic health records.

For further details and usage, please see the [walkthrough vignette](https://htmlpreview.github.io/?https://github.com/ropensci/chlorpromazineR/blob/master/doc/walkthrough.html).

This package is in production and not yet suitable for production use. We welcome feedback--please contact via eb@ericebrown.com or file an issue.

## Installation

The development version of this package can be installed via the command:  `devtools::install_github("ropensci/chlorpromazineR")`.

## Usage

Once installed, load package with `library(chlorpromazineR)`. The package's main conversion functions are documented and usage and examples can be seen with `help(to_cpz)` and `help(to_ap)`.

### Convert data to chlorpromazine equivalents

    participant_ID <- c("P01", "P02", "P03", "P04")
    age <- c(42, 29, 30, 60) # not used in calculation
    antipsychotic <- c("olanzapine", "olanzapine", "quetiapine", "ziprasidone")
    dose <- c(10, 12.5, 300, 60)
    example_oral <- data.frame(participant_ID, age, antipsychotic, dose, 
                               stringsAsFactors = FALSE)
    to_cpz(example_oral, ap_label = "antipsychotic", dose_label = "dose", 
           route = "oral")

## Disclaimer

This package is not for clinical use. The authors assume no liability. All work must be verified independently. Use at own risk.

## Licence

    Copyright (C) 2019 Eric E. Brown

    This software is licensed under the GPL-3, please see the LICENSE file.

## Citation

If you use this package in your scientific paper, please cite the original papers from which the conversion factors are derived, in addition to citing this R package. The references can be viewed by using the built-in help function, e.g. `help(gardner2010)`.

The keys included in this package are derived from the following publications. In addition, a spreadsheet-based tool facilitating dose equivalence conversion has been published by Leucht et al. (2016).

    Davis, J. (1974). Dose equivalence of the anti-psychotic drugs.
    Journal of Psychiatric Research, 11, 65-69.
    <https://doi.org/10.1016/0022-3956(74)90071-5>

    Gardner, D. M., Murphy, A. L., O’Donnell, H., Centorrino, F., & 
    Baldessarini, R. J. (2010). International consensus study of 
    antipsychotic dosing. The American Journal of Psychiatry, 167(6),
    686–693. <https://doi.org/10.1176/appi.ajp.2009.09060802>

    Leucht, S., Samara, M., Heres, S., & Davis, J. M. (2016). Dose
    Equivalents for Antipsychotic Drugs: The DDD Method. Schizophrenia
    Bulletin, 42(suppl_1), S90–S94. <https://doi.org/10.1093/schbul/sbv167>

    Woods, S. (2003). Chlorpromazine Equivalent Doses for the Newer
    Atypical Antipsychotics. Journal of Clinical Psychiatry. 64(6).
    663-667. <https://doi.org/10.4088/JCP.v64n0607>

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)

