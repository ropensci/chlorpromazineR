# chlorpromazineR package
# See README.md

#' Calculates chlorpromazine-equivalent doses
#' 
#' If the time_unit and activity_unit attributes are already in the data.frame,
#' they do not need to be set again, but otherwise they will need to be
#' specified in the input parameters.
#' 
#' @export
#' @param x data.frame with antipsychotic name and dose data
#' @param ap_label column in x that stores antipsychotic name
#' @param dose_label column in x that stores dose
#' @param route options include "oral", "sai", "lai" or "mixed"
#' @param key source of the conversion factors--defaults to Gardner et al. 2010
#' @param eq_label the name of the column to be created, to save the 
#' calculated CPZ-equivalent dose 
#' @param factor_label the name of the column to be created to store the
#' conversion factors
#' @param route_label if "mixed" route is specified, provide the column that
#' stores the route information
#' @param q if long-acting injectable doses are included, provide the column
#' that stores the injection frequency (days), or only if the doses have already
#' been divided, set q = 1.
#' @return data.frame with new variables storing conversion factor and 
#' CPZ-equivalent doses
#' @family conversion functions
#' @examples
#' participant_ID <- c("P01", "P02", "P03", "P04")
#' age <- c(42, 29, 30, 60)
#' antipsychotic <- c("olanzapine", "olanzapine", "quetiapine", "ziprasidone")
#' dose <- c(10, 12.5, 300, 60)
#' example_oral <- data.frame(participant_ID, age, antipsychotic, dose, 
#'                            stringsAsFactors = FALSE)
#' to_cpz(example_oral, ap_label = "antipsychotic", dose_label = "dose", 
#'        route = "oral")
to_cpz <- function(x, ap_label, dose_label, route="oral", 
                   key=chlorpromazineR::gardner2010, eq_label="cpz_eq", 
                   factor_label="cpz_conv_factor", route_label=NULL, q=NULL) {
    
  cpz_conv_factor <- data.frame(NA)
  cpz_eq <- data.frame(NA)
  names(cpz_conv_factor) <- factor_label
  names(cpz_eq) <- eq_label
  x <- cbind(x, cpz_conv_factor, cpz_eq)
    
  x[,ap_label] <- tolower(x[,ap_label])
    
  if ((length(route) != 1) | !(route %in% c("oral", "sai", "lai", "mixed"))) {
    stop("route must be 1 of \"oral\", \"sai\", \"lai\", or \"mixed\"")
  }

  if (route %in% c("oral", "sai", "lai")) {
    x[,factor_label] <- as.numeric(key[[route]][x[,ap_label]])
    x[,eq_label] <- apply(x[,c(dose_label, factor_label)], 1, prod)

    if (route == "lai" && q != 1) x[,eq_label] <- x[,eq_label] / x[,q]
  }

  if (route == "mixed") {
        
    if (!check_route(x, route_label)) stop("Route column must only include
                                            oral, sai or lai")
        
    if (is.null(q)) stop("A column name for the LAI frequency, q, (days)
                          must be specified")
    if (is.null(route_label)) stop("A column name for the route, 
                                   route_label, must be specified.")
    if (!is.numeric(x[, q])) stop("q column must be numeric for LAIs (days)")
        
    x <- convert_by_route(x=x, key=key, ap_label=ap_label, 
                          dose_label=dose_label, route_label=route_label, 
                          factor_label=factor_label, eq_label=eq_label)

    if (q != 1) {
      x[x$route=="lai",][, eq_label] <- x[x[,route_label]=="lai",][, eq_label] / 
                                        x[x[,route_label]=="lai",][,q]
      }
  }
    
  return(x)
}

#' @noRd
convert_by_route <- function(x, key, ap_label, dose_label, route_label, 
                             factor_label, eq_label) {

  for (r in c("oral", "sai", "lai")) {
    k <- key[[r]]
    x[x[,route_label]==r,][, factor_label] <-
                              as.numeric(k[x[x[,route_label]==r,][,ap_label]])
    
    x[x[,route_label]==r,][, eq_label] <-
            apply(x[x[,route_label]==r,][,c(dose_label, factor_label)], 1, prod)

  }
  
  return(x)
}

#' @noRd
check_route <- function(x, route_label) {
    return(all(x[,route_label] %in% c("oral", "sai", "lai")))
}

#' Checks whether antipsychotic names are in the key
#' 
#' Provided a data.frame, x, this checks that the antipsychotic names stored in
#' the x's variable ap_label are present in the key.
#' 
#' @export
#' @param x data.frame with antipsychotic name and dose data
#' @param key source of the conversion factors--defaults to Gardner et al. 2010
#' @param ap_label column in x that stores antipsychotic name
#' @param route options include "oral", "sai", "lai" or "mixed"
#' @param route_label if "mixed" route is specified, provide the column that
#' stores the route information
#' @return number of antipsychotic names in x[,ap_label] that don't match key
#' @family checking functions
#' @examples
#' participant_ID <- c("P01", "P02", "P03", "P04")
#' age <- c(42, 29, 30, 60)
#' antipsychotic <- c("olanzapine", "olanzapine", "quetiapine", "ziprasidone")
#' dose <- c(10, 12.5, 300, 60)
#' example_oral <- data.frame(participant_ID, age, antipsychotic, dose, 
#'                            stringsAsFactors = FALSE)
#' check_ap(example_oral, ap_label = "antipsychotic", route = "oral", 
#'          key = gardner2010)
check_ap <- function(x, key=chlorpromazineR::gardner2010, ap_label, route, 
                     route_label) {
    
  if (route %in% c("oral", "sai", "lai")) {
      notfound <- !(tolower(x[,ap_label]) %in% names(key[[route]]))
      bad <- paste0(x[,ap_label][notfound], " (", route, ")\n")
  } else if (route == "mixed") {
      notfound_oral <- !(tolower(x[x[,route_label]=="oral",][,ap_label])
                         %in% names(key$oral))
      notfound_sai <- !(tolower(x[x[,route_label]=="sai",][,ap_label])
                        %in% names(key$sai))
      notfound_lai <- !(tolower(x[x[,route_label]=="lai",][,ap_label])
                        %in% names(key$lai))
      notfound <- c(notfound_oral, notfound_sai, notfound_lai)
        
      if (any(notfound_oral)) {
          bad1 <- paste(x[x[,route_label]=="oral",][,ap_label][notfound_oral],
                        "(oral)\n")
      } else bad1 <- NULL

      if (any(notfound_sai)) {
          bad2 <- paste(x[x[,route_label]=="sai",][,ap_label][notfound_sai],
                        "(sai)\n")
      } else bad2 <- NULL

      if (any(notfound_lai)) {
          bad3 <- paste(x[x[,route_label]=="lai",][,ap_label][notfound_lai],
                        "(lai)\n")
      } else bad3 <- NULL

      bad <- c(bad1, bad2, bad3)
    }
    
  if (sum(notfound) > 0) {
      message("The following antipsychotics were not found in the key:")
      message(bad)
  }
    
  return(sum(notfound))
}

