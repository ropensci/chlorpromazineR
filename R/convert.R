# chlorpromazineR package
# See README.md

#' Calculates chlorpromazine-equivalent doses
#' 
#' Given a data.frame containing doses of antipsychotics to_cpz() converts the
#' doses into the equivalent chlorpromazine (CPZ) doses, using the conversion
#' factors specified in the key.
#'
#' The default key is gardner2010 which has data for both oral and long-acting
#' antipsychotic medications. See help(gardner2010) for the source reference.
#' 
#' @export
#' @param input_data data.frame with antipsychotic name and dose data
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
#' @param q_label if long-acting injectable doses are included, provide the column
#' that stores the injection frequency (days), or only if the doses have already
#' been divided, set q_label = 1.
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
to_cpz <- function(input_data, ap_label, dose_label, route="oral",
                   key=chlorpromazineR::gardner2010, eq_label="cpz_eq", 
                   factor_label="cpz_conv_factor", route_label=NULL,
                   q_label=NULL) {
  
  x <- input_data
  
  check_params(x, ap_label, dose_label, route, eq_label, factor_label,
               route_label, q_label)
  check_key(key)
  
  if (check_ap(x, key = key, ap_label = ap_label, route = route,
               route_label = route_label) != 0) {
    stop("Data contains antipsychotics not in the key")
  }
  
  cpz_conv_factor <- data.frame(NA)
  cpz_eq <- data.frame(NA)
  names(cpz_conv_factor) <- factor_label
  names(cpz_eq) <- eq_label
  x <- cbind(x, cpz_conv_factor, cpz_eq)
    
  x[,ap_label] <- tolower(x[,ap_label])
  
  if (route %in% c("oral", "sai", "lai")) {
    x[, factor_label] <- as.numeric(key[[route]][x[, ap_label]])
    x[, eq_label] <- apply(x[, c(dose_label, factor_label)], 1, prod)

    if (route == "lai" && q_label != 1) x[, eq_label] <- x[, eq_label] /
                                                                   x[, q_label]
  }

  if (route == "mixed") {
        
    if (!check_route(x, route_label)) stop("Route column must only include
                                            oral, sai or lai")
        
    if (is.null(q_label)) stop("A column name for the LAI frequency, q_label,
                                (days) must be specified")
    if (is.null(route_label)) stop("A column name for the route, 
                                   route_label, must be specified.")
    if (!is.numeric(x[, q_label])) stop("q_label column must be numeric for
                                         LAIs (days)")
        
    x <- convert_by_route(x=x, key=key, ap_label=ap_label, 
                          dose_label=dose_label, route_label=route_label, 
                          factor_label=factor_label, eq_label=eq_label)

    if (q_label != 1) {
      x[x$route == "lai", ][, eq_label] <-
                                  x[x[, route_label] == "lai", ][, eq_label] /
                                  x[x[, route_label] == "lai", ][, q_label]
      }
  }
    
  return(x)
}

#' @noRd
convert_by_route <- function(x, key, ap_label, dose_label, route_label, 
                             factor_label, eq_label) {

  for (r in c("oral", "sai", "lai")) {
    k <- key[[r]]
    x[x[, route_label] == r, ][, factor_label] <-
                           as.numeric(k[x[x[, route_label] == r,][, ap_label]])
    
    x[x[,route_label] == r, ][, eq_label] <-
         apply(x[x[, route_label] == r,][,c(dose_label, factor_label)], 1, prod)

  }
  
  return(x)
}


#' Checks whether antipsychotic names are in the key
#' 
#' Provided a data.frame, x, this checks that the antipsychotic names stored in
#' the x's variable ap_label are present in the key.
#' 
#' @export
#' @param input_data data.frame with antipsychotic name and dose data
#' @param key source of the conversion factors--defaults to Gardner et al. 2010
#' @param ap_label column in x that stores antipsychotic name
#' @param route options include "oral", "sai", "lai" or "mixed"
#' @param route_label if "mixed" route is specified, provide the column that
#' stores the route information
#' @return number of antipsychotic names in x[,ap_label] that don't match key
#' @family checking functions
#' @examples
#' participant_ID <- c("P01", "P02", "P03", "P04")
#' age <- c(42, 29, 30, 60) # not used in calculation, just shows other data
#'                          # can exist in the data.frame
#' antipsychotic <- c("olanzapine", "olanzapine", "quetiapine", "ziprasidone")
#' dose <- c(10, 12.5, 300, 60)
#' example_oral <- data.frame(participant_ID, age, antipsychotic, dose, 
#'                            stringsAsFactors = FALSE)
#' check_ap(example_oral, ap_label = "antipsychotic", route = "oral", 
#'          key = gardner2010)
check_ap <- function(input_data, key=chlorpromazineR::gardner2010, ap_label,
                     route, route_label) {
  
  x <- input_data
  check_key(key)
  
  if (route %in% c("oral", "sai", "lai")) {
      notfound <- !(tolower(x[, ap_label]) %in% names(key[[route]]))
      bad <- paste0(x[, ap_label][notfound], " (", route, ")\n")
  } else if (route == "mixed") {
      notfound_oral <- !(tolower(x[x[, route_label] == "oral",][, ap_label])
                         %in% names(key$oral))
      notfound_sai <- !(tolower(x[x[, route_label] == "sai",][, ap_label])
                        %in% names(key$sai))
      notfound_lai <- !(tolower(x[x[, route_label] == "lai",][, ap_label])
                        %in% names(key$lai))
      notfound <- c(notfound_oral, notfound_sai, notfound_lai)
        
      if (any(notfound_oral)) {
          bad1 <-
                paste(x[x[, route_label] == "oral",][, ap_label][notfound_oral],
                "(oral)\n")
      } else bad1 <- NULL

      if (any(notfound_sai)) {
          bad2 <- paste(x[x[, route_label] == "sai",][, ap_label][notfound_sai],
                        "(sai)\n")
      } else bad2 <- NULL

      if (any(notfound_lai)) {
          bad3 <- paste(x[x[, route_label] == "lai",][, ap_label][notfound_lai],
                        "(lai)\n")
      } else bad3 <- NULL

      bad <- c(bad1, bad2, bad3)
  } else {
    stop("route parameter must be oral, sai or lai.")
  }
    
  if (sum(notfound) > 0) {
      message("The following antipsychotics were not found in the key:")
      message(bad)
  }
    
  return(sum(notfound))
}

#' Calculates equivalent doses
#'
#' As in to_cpz(), to_ap() converts doses of antipsychotics into equivalent
#' doses to a reference antipsychotic. Whereas in to_cpz() the reference
#' antipsychotic is chlorpromazine (CPZ), to_ap() converts to equivalents of an
#' arbitrary antipsychotic specified as a string to convert_to_ap. Conversion
#' factors are specified in the key.
#'
#' @export
#' @param input_data data.frame with antipsychotic name and dose data
#' @param convert_to_ap name of desired reference antipsychotic
#' @param convert_to_route the route of the desired reference antipsychotic
#' @param ap_label column in x that stores antipsychotic name
#' @param dose_label column in x that stores dose
#' @param route options include "oral", "sai", "lai" or "mixed"
#' @param key source of the conversion factors--defaults to Gardner et al. 2010
#' @param cpz_eq_label the name of the column to be created, to save the
#' calculated CPZ-equivalent dose
#' @param ref_eq_label the name of the column to be created to save the doses in
#' terms of the specified reference antipsychotic (in convert_to_ap)
#' @param factor_label the name of the column to be created to store the
#' conversion factors
#' @param route_label if "mixed" route is specified, provide the column that
#' stores the route information
#' @param q_label if long-acting injectable doses are included, provide the
#' column that stores the injection frequency (days), or only if the doses have
#' already been divided, set q_label = 1.
#' @return data.frame with new variables storing conversion factor and
#' CPZ-equivalent doses
#' @family conversion functions
#' @examples
#' participant_ID <- c("P01", "P02", "P03", "P04")
#' age <- c(42, 29, 30, 60) # not used in calculation, just shows other data
#'                          # can exist in the data.frame
#' antipsychotic <- c("olanzapine", "olanzapine", "quetiapine", "ziprasidone")
#' dose <- c(10, 12.5, 300, 60)
#' example_oral <- data.frame(participant_ID, age, antipsychotic, dose,
#'                            stringsAsFactors = FALSE)
#' to_ap(example_oral, convert_to_ap="olanzapine", convert_to_route="oral",
#'       ap_label = "antipsychotic", dose_label = "dose", route = "oral")
to_ap <- function(input_data, convert_to_ap="olanzapine",
                  convert_to_route="oral", ap_label, dose_label, route="oral",
                  key=chlorpromazineR::gardner2010, cpz_eq_label="cpz_eq",
                  ref_eq_label="ap_eq", factor_label="cpz_conv_factor",
                  route_label=NULL, q_label=NULL) {
  
  check_params(input_data, ap_label, dose_label, route, eq_label=cpz_eq_label,
               factor_label, route_label, q_label)
  check_key(key)
  
  if (!(convert_to_ap %in% names(key[[convert_to_route]]))) {
      stop("The specified convert_to antipsychotic/route is not in the key")
  }
  
  out <- to_cpz(input_data = input_data, ap_label = ap_label,
                dose_label = dose_label, route = route, key = key,
                eq_label = cpz_eq_label, factor_label = factor_label,
                route_label = route_label, q_label = q_label)
                
  out[, ref_eq_label] <- out[, cpz_eq_label] /
                              as.numeric(key[[convert_to_route]][convert_to_ap])
  
  return(out)
}

#' @noRd
check_params <- function(x, ap_label, dose_label, route, eq_label,
                         factor_label, route_label, q_label) {
  if (!(is.data.frame(x))) stop("x must be a data.frame.")
  
  if (!(ap_label %in% names(x))) stop("ap_label must be a variable in x.")
  
  if (!(dose_label %in% names(x))) stop("dose_label must be a variable in x.")
  
  if ((length(route) != 1) | !(route %in% c("oral", "sai", "lai", "mixed"))) {
    stop("route must be 1 of \"oral\", \"sai\", \"lai\", or \"mixed\"")
  }
  
  if (route == "mixed") {
    if (!(route_label %in% names(x))) {
      stop("route_label must be a variable in x.")
    }
  } else {
    if (!(is.null(route_label))) {
      stop("route_label should be null if route is not mixed.")
    }
  }
  
  if (!(is.character(eq_label))) {
    stop("eq_label/cpz_eq_label must be a character string.")
  }
  
  if (!(is.character(factor_label))) {
    stop("factor_label must be a character string.")
  }
}

#' @noRd
check_route <- function(x, route_label) {
  return(all(x[,route_label] %in% c("oral", "sai", "lai")))
}
