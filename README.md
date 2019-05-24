# chlorpromazineR: Convert antipsychotic doses to chlorpromazine equivalents

[![Travis build status](https://travis-ci.org/eebrown/chlorpromazineR.svg?branch=master)](https://travis-ci.org/eebrown/chlorpromazineR) [![Coverage status](https://codecov.io/gh/eebrown/chlorpromazineR/branch/master/graph/badge.svg)](https://codecov.io/github/eebrown/chlorpromazineR?branch=master)

Studies investigating or controlling for the impact of antipsychotic medications often need to quantify the amount of medication to which an individual is or has been exposed. As different antipsychotics have different potencies, the task is more complicated than using each medication’s daily dosage in milligrams, for example. `chlorpromazineR` is an R package to calculate dose equivalents for common oral and injectable antipsychotic medications based on conversion factors from the published literature. We do not propose to suggest which conversion factors are appropriate to use, or how to interpret the converted data. All users should also refer to the papers from which the conversion factor data originates to determine whether the use of such data is appropriate for their study.

With this package, he hope:

* to improve transparency and consistency in calculating CPZ equivalents,
* to reduce human error and improve accuracy,
* and to simplify workflows for large datasets, as from chart reviews of electronic health records.

For further details and usage, please see the [walkthrough vignette](https://htmlpreview.github.io/?https://github.com/eebrown/chlorpromazineR/blob/master/doc/walkthrough.html).

This package is in production and not yet suitable for production use. We welcome feedback--please contact via eb@ericebrown.com or file an issue.

## Installation

The development version of this package can be installed via the command:  `devtools::install_github("eebrown/chlorpromazineR")`.

## Disclaimer

This package is not for clinical use. The authors assume no liability. All work must be verified independently. Use at own risk.

## Licence

    Copyright (C) 2019 Eric E. Brown

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

## Citation

In addition to citing this package, please cite the original papers from which the conversion factors are derived. The references can be viewed by using the built-in help function, e.g. `help(gardner2010)`.
