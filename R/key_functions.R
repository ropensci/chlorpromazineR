# chlorpromazineR package
# See README.md

#' Check whether a conversion key is the expected format
#' 
#' chlorpromazineR uses conversion factors stored in a named list of 3 named
#' lists. This verifies that the key is in a usable format, which can be helpful
#' when creating custom keys or modifying included keys.
#' 
#' @export
#' @param key the key to check
#' @return TRUE if the key is valid, otherwise a error is thrown.
#' @family key functions
#' @examples check_key(gardner2010)
check_key <- function(key) {
 
  if (!(is.list(key))) stop("Key is not a list.")
  if (length(key) != 3) stop("Key is not 3 lists.")
  
  if (!all(names(key) == c("oral", "sai", "lai"))) {
    stop("Key list names should be oral, sai and lai")  
  } 
  
  if (!all(unlist(lapply(key, is.list)))) {
    stop("Each element of key should be a list")
  }
  
  if (!is.numeric(unlist(lapply(unlist(key), unlist)))) {
    stop("Each key list should have numeric data.")
  }
  
  return(TRUE)
}

#' Modify the names in a conversion key to only include the first word
#' 
#' For parenteral (sai) and long-acting/depot (lai) antipsychotics, the name 
#' consists of the usual generic name (such as haloperidol) and a second word
#' describing the formulation (e.g. haloperidol decanoate). Since to_cpz() and
#' add_key() require exact matches to work properly, removing the second word
#' may be required, but should be done with care as it can add ambiguity (e.g.
#' fluphenazine enanthate and decanoate).
#' 
#' @export
#' @param key the key to trim
#' @return the key that was trimmed (a named list of 3 named lists)
#' @family key functions
#' @examples trim_key(gardner2010)
trim_key <- function(key) {

  if (!check_key(key)) stop("Input key did not validate.")  

  names(key$oral) <- sub("([A-Za-z]+).*", "\\1", names(key$oral))
  names(key$sai) <- sub("([A-Za-z]+).*", "\\1", names(key$sai))
  names(key$lai) <- sub("([A-Za-z]+).*", "\\1", names(key$lai))
  
  if (!check_key(key)) stop("Output key did not validate.")

  return(key) 
}

#' Combine 2 keys with base key taking precedence
#' 
#' Use this to combine 2 keys by using the whole "base" key, and adding any
#' antipsychotics from the "added" key that are not in the "base" key.
#' 
#' @export
#' @param base the base key
#' @param added the key from which other antipsychotics are found to add 
#' @param trim TRUE to use trim_key on both the base and added key, needed when
#' one does not use the full names (e.g. leucht2016).
#' @return a merged key
#' @family key functions
#' @examples add_key(gardner2010, leucht2016, trim = TRUE)
add_key <- function(base, added, trim) {
 
  if (!check_key(base)) stop("base key did not validate.")
  if (!check_key(added)) stop("added key did not validate.")      

  if (trim) {
    base <- trim_key(base)
    added <- trim_key(added)
  }
  
  merged <- base
  
  merged$oral <- c(base$oral, 
                   added$oral[!(names(added$oral) %in% names(base$oral))])
  merged$sai <- c(base$sai, added$sai[!(names(added$sai) %in% names(base$sai))])
  merged$lai <- c(base$lai, added$lai[!(names(added$lai) %in% names(base$lai))])
  
  if (!check_key(merged)) stop("Output key did not validate.")   

  return(merged)
}
