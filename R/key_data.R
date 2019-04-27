# key_data.R

# KEYS

#' Chlorpromazine equivalent key from Gardner et al. 2010 data
#'
#' A list of antipsychotics and their chlorpromazine equivalent doses, generated
#' from the following file included with the package:
#' system.file("extdata", "gardner2010.csv", package="chlorpromazineR"). 
#' 
#' @format A named list of 3 named lists (1 for each route) and each sub-list 
#' contains the conversion factors for each antipsychotic. The 3 top-level lists
#' are named `oral`, `sai`, and `lai` (route), and the lists they contain have
#' names corresponding to the antipsychotic, e.g. `olanzapine`.
#' @source Reference
"gardner2010"

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
#' @source Reference
"leucht2016"


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

