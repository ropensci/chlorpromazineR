
#' @export
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

#' @export
trim_key <- function(key) {
  
  names(key$oral) <- sub("([A-Za-z]+).*", "\\1", names(key$oral))
  names(key$sai) <- sub("([A-Za-z]+).*", "\\1", names(key$sai))
  names(key$lai) <- sub("([A-Za-z]+).*", "\\1", names(key$lai))
  
  return(key) 
}

#' @export
add_key <- function(base, added, trim = TRUE) {
  
  if (trim) {
    base <- trim_key(base)
    added <- trim_key(added)
  }
  
  merged <- base
  
  merged$oral <- c(base$oral, added$oral[!(names(added$oral) %in% names(base$oral))])
  merged$sai <- c(base$sai, added$sai[!(names(added$sai) %in% names(base$sai))])
  merged$lai <- c(base$lai, added$lai[!(names(added$lai) %in% names(base$lai))])
  
  return(merged)
}