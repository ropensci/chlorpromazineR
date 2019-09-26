# chlorpromazineR package
# See README.md
# test_convert.R

context("CPZ-equivalent conversion")

test_that("to_cpz() produces accurate values with oral example", {

  participant_ID <- c("P01", "P02", "P03", "P04")
  antipsychotic <- c("olanzapine", "olanzapine", "quetiapine", "ziprasidone")
  dose <- c(10, 12.5, 300, 60)
  example_oral <- data.frame(participant_ID, antipsychotic, dose, 
                             stringsAsFactors = FALSE)

  answers <- c(300, 375, 240, 225)

  test <- to_cpz(example_oral, "antipsychotic", "dose", "oral", 
                 key = gardner2010)

  expect_equal(answers, test$cpz_eq)

})

test_that("to_cpz() produces accurate values with mixed example", {

  participant_ID <- c(1:15)
  antipsychotic <- c("Amisulpride", "Aripiprazole", "Benperidol", 
                     "Chlorpromazine", "Clopenthixol",

                     "Chlorpromazine HCl", "Clotiapine injectable", 
                     "Fluphenazine HCl", "Haloperidol lactate",
                     "Loxapine HCl",

                     "Clopenthixol decanoate", "Flupenthixol decanoate", 
                     "Fluphenazine decanoate", "Fluphenazine enanthate", 
                     "Fluspirilene")
  dose <- c(700, 30, 5, 600, 60,
            100, 40, 5, 5, 25,
            300, 40, 25, 25, 6)

  route <- c(rep("oral", 5), rep("sai", 5), rep("lai", 5))

  q_label <- c(rep(NA, 10), 14,14,14,14,7)

  example <- data.frame(participant_ID, antipsychotic, dose, q_label, route,
                             stringsAsFactors = FALSE)

  answers <- c(rep(600, 5), rep(100, 5), rep(600, 5))

  test <- to_cpz(example, "antipsychotic", "dose", "mixed", 
                 route_label = "route", q_label ="q_label",
                 key = gardner2010_withsai)

  expect_equal(answers, test$cpz_eq)

  # and below, errors occur with malformed data

  expect_error(to_cpz(example, "antipsychotic", "dose", route = "not_route", 
               route_label = "route", q_label ="q_label",
               key = gardner2010_withsai))

  expect_error(to_cpz(example, "antipsychotic", "dose", route = "mixed", 
               route_label = "route", q_label = NULL,
               key = gardner2010_withsai))
  
  expect_error(to_cpz(example, "antipsychotic", "dose", route = "mixed", 
               route_label = NULL, q_label = "q_label",
               key = gardner2010_withsai))

  q_label <- c(rep(NA, 10), 14,"notnumber",14,14,7)
  example <- data.frame(antipsychotic, dose, q_label, route,
                        stringsAsFactors = FALSE)

  expect_error(to_cpz(example, "antipsychotic", "dose", "mixed", 
                 route_label = "route", q_label ="q_label",
                 key = ggardner2010_withsai))


})

test_that("to_cpz() produces accurate values with mixed example with 
           pre-adjusted depot frequencies", {

  participant_ID <- c(1:15)
  antipsychotic <- c("Amisulpride", "Aripiprazole", "Benperidol", 
                     "Chlorpromazine", "Clopenthixol",

                     "Chlorpromazine HCl", "Clotiapine injectable", 
                     "Fluphenazine HCl", "Haloperidol lactate",
                     "Loxapine HCl",

                     "Clopenthixol decanoate", "Flupenthixol decanoate", 
                     "Fluphenazine decanoate", "Fluphenazine enanthate", 
                     "Fluspirilene")

  dose <- c(700, 30, 5, 600, 60,
            100, 40, 5, 5, 25,
            300, 40, 25, 25, 6)

  route <- c(rep("oral", 5), rep("sai", 5), rep("lai", 5))

  q_label <- c(14,14,14,14,7)

  dose[11:15] <- dose[11:15]/q_label

  example <- data.frame(participant_ID, antipsychotic, dose, route,
                             stringsAsFactors = FALSE)

  answers <- c(rep(600, 5), rep(100, 5), rep(600, 5))

  test <- to_cpz(example, "antipsychotic", "dose", "mixed", 
                 route_label = "route", q_label =1, key = gardner2010_withsai)

  expect_equal(answers, test$cpz_eq)

})

test_that("to_ap() rejects invalid reference antipsychotics and works", {
  
  participant_ID <- c("P01", "P02", "P03", "P04")
  antipsychotic <- c("olanzapine", "olanzapine", "quetiapine", "ziprasidone")
  dose <- c(10, 12.5, 300, 60)
  example_oral <- data.frame(participant_ID, antipsychotic, dose,
                             stringsAsFactors = FALSE)
  
  olanz_answers <- c(10, 12.5, 8, 7.5)
  
  expect_error(to_ap(example_oral, convert_to_ap = "olANZ",
                     convert_to_route = "oral", ap_label = "antipsychotic",
                     dose_label = "dose", route = "oral",
                     key = chlorpromazineR::gardner2010))
  
  expect_error(to_ap(example_oral, convert_to_ap = "olanzapine",
                     convert_to_route = "nai", ap_label = "antipsychotic",
                     dose_label = "dose", route = "oral",
                     key = chlorpromazineR::gardner2010))
  
  test_olanz <- to_ap(example_oral, convert_to_ap = "olanzapine",
                   convert_to_route = "oral", ap_label = "antipsychotic",
                   dose_label = "dose", route = "oral",
                   key = chlorpromazineR::gardner2010)
                   
  expect_equal(test_olanz$ap_eq, olanz_answers)
})
