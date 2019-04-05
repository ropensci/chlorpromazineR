# key_data.R

# KEYS

#' Chlorpromazine equivalent key from Gardner et al. 2010 data
#'
#' A list of antipsychotics and their chlorpromazine equivalent doses, generated
#' from the following file included with the package:
#' system.file("extdata", "gardner2010.csv", package="chlorpromazineR"). The
#' data was generated with the following function: |cr |cr
#' # gardner2010 <- function() { |cr
#' #   g <- read.csv(system.file("extdata", "gardner2010.csv", |cr
#' #                             package="chlorpromazineR"), |cr
#' #                 stringsAsFactors = FALSE) |cr
#' #   g_oral <- as.list(600 / g[g[,"route"]=="oral",]$median) |cr
#' #   names(g_oral) <- tolower(g[g[,"route"]=="oral",]$drug) |cr
#' #   g_sai <- as.list(100 / g[g[,"route"]=="SAI",]$median) |cr
#' #   names(g_sai) <- tolower(g[g[,"route"]=="SAI",]$drug) |cr
#' #   g_lai <- as.list((600 / ((g[g[,"route"]=="LAI",]$median) |cr
#' #                                 / g[g[,"route"]=="LAI",]$days))) |cr
#' #   names(g_lai) <- tolower(g[g[,"route"]=="LAI",]$drug) |cr
#' #   return(list(oral=g_oral, sai=g_sai, lai=g_lai)) |cr
#' # }
#' 
#' @format A named list of 3 named lists (1 for each route) and each sub-list 
#' contains the conversion factors for each antipsychotic. The 3 top-level lists
#' are named `oral`, `sai`, and `lai` (route), and the lists they contain have
#' names corresponding to the antipsychotic, e.g. `olanzapine`.
#' @source Reference
"gardner2010"


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