# key_data.R

# KEYS

#' Chlorpromazine equivalent key from Gardner et al. 2010 data
#'
#' A list of antipsychotics and their chlorpromazine equivalent doses, generated
#' from the following file included with the package:
#' system.file("extdata", "gardner2010.csv", package="chlorpromazineR").
#'
#' The SAI data is not included in this key, because the original study did not
#' specify a conversion factor from chlorpromazine LAI to oral. The alternative
#' key gardner2010_withsai can be used, which includes the SAI data, but the
#' chlorpromazine equivalent doses produced are equivalent to chlorpromazine SAI
#' not chlorpromazine oral. They could be manually converted (e.g. by
#' multiplying the SAI doses by 3 per equivalence noted by Davis 1974
#' <https://doi.org/10.1016/0022-3956(74)90071-5>)
#'
#' @format A named list of 3 named lists (1 for each route) and each sub-list
#' contains the conversion factors for each antipsychotic. The 3 top-level lists
#' are named `oral`, `sai`, and `lai` (route), and the lists they contain have
#' names corresponding to the antipsychotic, e.g. `olanzapine`.
#' @source Gardner, D. M., Murphy, A. L., O’Donnell, H., Centorrino, F., &
#' Baldessarini, R. J. (2010). International consensus study of antipsychotic
#' dosing. The American Journal of Psychiatry, 167(6), 686–693.
#' <https://doi.org/10.1176/appi.ajp.2009.09060802>
"gardner2010"

#' Chlorpromazine equivalent key from Gardner et al. 2010 data
#'
#' A list of antipsychotics and their chlorpromazine equivalent doses, generated
#' from the following file included with the package:
#' system.file("extdata", "gardner2010.csv", package="chlorpromazineR").
#'
#' The SAI equivalents produced by this key are equivalent to chlorpromazine SAI
#' not oral. They could be manually converted.
#'
#' @format A named list of 3 named lists (1 for each route) and each sub-list
#' contains the conversion factors for each antipsychotic. The 3 top-level lists
#' are named `oral`, `sai`, and `lai` (route), and the lists they contain have
#' names corresponding to the antipsychotic, e.g. `olanzapine`.
#' @source Gardner, D. M., Murphy, A. L., O’Donnell, H., Centorrino, F., &
#' Baldessarini, R. J. (2010). International consensus study of antipsychotic
#' dosing. The American Journal of #' Psychiatry, 167(6), 686–693.
#' <https://doi.org/10.1176/appi.ajp.2009.09060802>
"gardner2010_withsai"

#' Chlorpromazine equivalent key from Leucht et al. 2016 data
#'
#' A list of antipsychotics and their chlorpromazine equivalent doses, generated
#' from the following file included with the package:
#' system.file("extdata", "leucht2016.csv", package="chlorpromazineR"). 
#' 
#' @format A named list of 3 named lists (1 for each route) and each sub-list 
#' contains the conversion factors for each antipsychotic. The 3 top-level lists
#' are named `oral`, `sai`, and `lai` (route), and the lists they contain have
#' names corresponding to the antipsychotic, e.g. `olanzapine`.
#' @source Leucht, S., Samara, M., Heres, S., & Davis, J. M. (2016). Dose 
#' Equivalents for Antipsychotic Drugs: The DDD Method. Schizophrenia Bulletin,
#' 42(suppl_1), S90–S94. <https://doi.org/10.1093/schbul/sbv167>
"leucht2016"

#' Chlorpromazine equivalent key from Davis 1974 data
#'
#' A list of antipsychotics and their chlorpromazine equivalent doses, generated
#' from the following file included with the package:
#' system.file("extdata", "davis1974.csv", package="chlorpromazineR").
#'
#' @format A named list of 3 named lists (1 for each route) and each sub-list
#' contains the conversion factors for each antipsychotic. The 3 top-level lists
#' are named `oral`, `sai`, and `lai` (route), and the lists they contain have
#' names corresponding to the antipsychotic, e.g. `olanzapine`.
#' @source John Davis (1974). Dose equivalence of the anti-psychotic drugs.
#' Journal of Psychiatric Research, 11, 65-69.
#' <https://doi.org/10.1016/0022-3956(74)90071-5>
"davis1974"

#' Chlorpromazine equivalent key from Woods 2003 data
#'
#' A list of antipsychotics and their chlorpromazine equivalent doses, generated
#' from the following file included with the package:
#' system.file("extdata", "woods2003.csv", package="chlorpromazineR").
#'
#' @format A named list of 3 named lists (1 for each route) and each sub-list
#' contains the conversion factors for each antipsychotic. The 3 top-level lists
#' are named `oral`, `sai`, and `lai` (route), and the lists they contain have
#' names corresponding to the antipsychotic, e.g. `olanzapine`.
#' @source Scott Woods (2003). Chlorpromazine Equivalent Doses for the Newer
#' Atypical Antipsychotics. Journal of Clinical Psychiatry. 64(6). 663-667.
#' <https://doi.org/10.4088/JCP.v64n0607>
"woods2003"

# gardner2010gen <- function() {
#   g <- read.csv(system.file("extdata", "gardner2010.csv", 
#                             package="chlorpromazineR"), 
#                 stringsAsFactors = FALSE)
#   g_oral <- as.list(600 / g[g[,"route"]=="oral",]$median) 
#   names(g_oral) <- tolower(g[g[,"route"]=="oral",]$drug) 
#   g_sai <- as.list(100 / g[g[,"route"]=="SAI",]$median) 
#   names(g_sai) <- tolower(g[g[,"route"]=="SAI",]$drug) 
#   g_lai <- as.list((600 / ((g[g[,"route"]=="LAI",]$median) / 
#                                      g[g[,"route"]=="LAI",]$days)))
#   names(g_lai) <- tolower(g[g[,"route"]=="LAI",]$drug) 
#   return(list(oral=g_oral, sai=g_sai, lai=g_lai)) 
# }

# leucht2016gen <- function() {
# l <- read.csv(system.file("extdata", "leucht2016.csv",
#                           package="chlorpromazineR"),
#               stringsAsFactors = FALSE)
# l_oral <- as.list(100 / l[l[,"route"]=="oral",]$CPZ100MGEQ)
# names(l_oral) <- tolower(l[l[,"route"]=="oral",]$drug) 
# l_sai <- as.list(100 / l[l[,"route"]=="SAI",]$CPZ100MGEQ)
# names(l_sai) <- tolower(l[l[,"route"]=="SAI",]$drug)
# l_lai <- as.list(100 / l[l[,"route"]=="LAI",]$CPZ100MGEQ)
# names(l_lai) <- tolower(l[l[,"route"]=="LAI",]$drug)
# return(list(oral=l_oral, sai=l_sai, lai=l_lai))
#}

#davis1974gen <- function() {
#  d <- read.csv(system.file("extdata", "davis1974.csv",
#                            package="chlorpromazineR"),
#                stringsAsFactors = FALSE)
#  d_oral <- as.list(100 / d$CPZ100)
#  names(d_oral) <- tolower(d$Antipsychotic)
#  d_sai <- as.list(300 / d$CPZ100)
#  names(d_sai) <- names(d_oral)
#  d_lai <- list()
#  return(list(oral=d_oral, sai=d_sai, lai=d_lai))
#}

#woods2003gen <- function() {
#  w <- read.csv(system.file("extdata", "woods2003.csv",
#                package="chlorpromazineR"),
#                stringsAsFactors = FALSE)
#  w_oral <- as.list(100 / w$CPZ100)
#  names(w_oral) <- tolower(w$Antipsychotic)
#  w_sai <- list()
#  w_lai <- list()
#  return(list(oral=w_oral, sai=w_sai, lai=w_lai))
#}
