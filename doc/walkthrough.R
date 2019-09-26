## ----setup, include = FALSE----------------------------------------------
library(chlorpromazineR)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
names(gardner2010)

## ------------------------------------------------------------------------
names(gardner2010$oral)[1:5]

## ------------------------------------------------------------------------
gardner2010$oral$aripiprazole

## ------------------------------------------------------------------------
participant_ID <- c("P01", "P02", "P03", "P04")
age <- c(42, 29, 30, 60)
antipsychotic <- c("olanzapine", "olanzapine", "quetiapine", "ziprasidone")
dose <- c(10, 12.5, 300, 60)
example_oral <- data.frame(participant_ID, age, antipsychotic, dose, 
                           stringsAsFactors = FALSE)

example_oral

## ------------------------------------------------------------------------
to_cpz(example_oral, ap_label = "antipsychotic", dose_label = "dose", 
       route = "oral")

## ------------------------------------------------------------------------
example_lai <- example_oral
example_lai$participant_ID <- c("P05", "P06", "P07", "P08")
example_lai$antipsychotic <- c("zuclopenthixol decanoate", 
                               "zuclopenthixol decanoate", 
                               "perphenazine enanthate", "fluspirilene")
example_lai$q <- c(14, 21, 14, 14)
example_lai$dose <- c(200, 200, 50, 6)

example_sai <- example_oral
example_sai$participant_ID <- c("P09", "P10", "P11", "P12")
example_sai$antipsychotic <- c("Chlorpromazine HCl", "Loxapine HCl", 
                               "Olanzapine tartrate", "Olanzapine tartrate")
example_sai$dose <- c(100, 50, 10, 5)

example_oral$q <- NA
example_sai$q <- NA

example_oral$route <- "oral"
example_lai$route <- "lai"
example_sai$route <- "sai"

example_mixed <- rbind(example_oral, example_sai, example_lai)

example_mixed

## ------------------------------------------------------------------------
to_cpz(example_mixed, ap_label = "antipsychotic", dose_label = "dose", 
       route = "mixed", route_label = "route", q_label = "q", key=gardner2010_withsai) 

## ------------------------------------------------------------------------
check_ap(example_oral, ap_label = "antipsychotic", route = "oral", key=gardner2010)

## ------------------------------------------------------------------------
example_sai <- example_sai
check_ap(example_sai, ap_label = "antipsychotic", route = "sai", key=gardner2010)

## ------------------------------------------------------------------------
example_mixed_bad <- example_mixed
example_mixed_bad[1,3] <- "olanzzzzapine"
example_mixed_bad[4,3] <- "Seroquel"
example_mixed_bad[5,3] <- "chlorpromazineHCl"
example_mixed_bad[9,3] <- "zuclo decanoate"
check_ap(example_mixed_bad, ap_label = "antipsychotic", 
         route = "mixed", route_label = "route", key=gardner2010_withsai)

## ------------------------------------------------------------------------
names(gardner2010$lai)

## ------------------------------------------------------------------------
trimmed_gardner <- trim_key(gardner2010)

names(trimmed_gardner$lai)

## ------------------------------------------------------------------------
to_cpz(example_oral, ap_label = "antipsychotic", dose_label = "dose", 
       route = "oral", key = leucht2016)

## ------------------------------------------------------------------------
gardner_leucht <- add_key(base = gardner2010, add = leucht2016, trim = TRUE)

names(gardner_leucht$sai)

## ------------------------------------------------------------------------
other_oral <- example_oral
other_oral[2,3] <- "asenapine"
other_oral[2,4] <- 10

check_ap(other_oral, ap_label = "antipsychotic", route = "oral")

## ------------------------------------------------------------------------
to_cpz(other_oral, ap_label = "antipsychotic", dose_label = "dose", 
       route = "oral", key = gardner_leucht)

## ------------------------------------------------------------------------
to_ap(other_oral, convert_to_ap = "olanzapine", convert_to_route = "oral", 
      ap_label = "antipsychotic", dose_label = "dose", 
      route = "oral", key = gardner_leucht)

