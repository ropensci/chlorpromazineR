## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library("chlorpromazineR")

## ------------------------------------------------------------------------
participant_ID <- c("P01", "P02", "P03", "P04")
age <- c(42, 29, 30, 60)
antipsychotic <- c("olanzapine", "olanzapine", "quetiapine", "ziprasidone")
dose <- c(10, 12.5, 300, 60)
example_oral <- data.frame(participant_ID, age, antipsychotic, dose, stringsAsFactors = FALSE)

example_oral

## ------------------------------------------------------------------------
to_cpz(example_oral, ap_label = "antipsychotic", dose_label = "dose", route = "oral")

## ------------------------------------------------------------------------
example_lai <- example_oral
example_lai$participant_ID <- c("P05", "P06", "P07", "P08")
example_lai$antipsychotic <- c("zuclopenthixol decanoate", "zuclopenthixol decanoate", "perphenazine enanthate", "fluspirilene")
example_lai$q <- c(14, 21, 14, 14)
example_lai$dose <- c(200, 200, 50, 6)

example_sai <- example_oral
example_sai$participant_ID <- c("P09", "P10", "P11", "P12")
example_sai$antipsychotic <- c("Chlorpromazine HCl", "Loxapine HCl", "Olanzapine tartrate", "Olanzapine tartrate")
example_sai$dose <- c(100, 50, 10, 5)

example_oral$q <- NA
example_sai$q <- NA

example_oral$route <- "oral"
example_lai$route <- "lai"
example_sai$route <- "sai"

example_mixed <- rbind(example_oral, example_sai, example_lai)

example_mixed

## ------------------------------------------------------------------------
to_cpz(example_mixed, ap_label = "antipsychotic", dose_label = "dose", route = "mixed", 
       route_label = "route", q = "q") 

## ------------------------------------------------------------------------
check_ap(example_sai, ap_label = "antipsychotic", route = "sai")

## ------------------------------------------------------------------------
example_sai_bad <- example_sai
example_sai_bad[3,3] <- "nope"
check_ap(example_sai_bad, ap_label = "antipsychotic", route = "sai")

## ------------------------------------------------------------------------
example_mixed_bad <- example_mixed
example_mixed_bad[1,3] <- "olanzzzzapine"
example_mixed_bad[4,3] <- "Seroquel"
example_mixed_bad[5,3] <- "chlorpromazineHCl"
example_mixed_bad[9,3] <- "zuclo decanoate"
check_ap(example_mixed_bad, ap_label = "antipsychotic", route = "mixed", route_label = "route")

