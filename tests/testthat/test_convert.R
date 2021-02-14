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

  original_dose <- c(700, 30, 5, 600, 60,
            100, 40, 5, 5, 25,
            300, 40, 25, 25, 6)

  route <- c(rep("oral", 5), rep("sai", 5), rep("lai", 5))

  q_label <- c(14,14,14,14,7)

  dose <- original_dose
  dose[11:15] <- dose[11:15]/q_label

  example <- data.frame(participant_ID, antipsychotic, dose, route,
                             stringsAsFactors = FALSE)

  answers <- c(rep(600, 5), rep(100, 5), rep(600, 5))

  test <- to_cpz(example, "antipsychotic", "dose", "mixed",
                 route_label = "route", q_label =1, key = gardner2010_withsai)

  expect_equal(answers, test$cpz_eq)

  example_lai <- data.frame(ID = participant_ID[11:15],
                            ap = antipsychotic[11:15],
                            dose = original_dose[11:15], route = route[11:15],
                            q = q_label, stringsAsFactors = FALSE)

  test_lai <- to_cpz(example_lai, ap_label="ap", dose_label="dose",
                     route="lai", q_label = "q", key = gardner2010_withsai)

  expect_equal(answers[11:15], test_lai$cpz_eq)

  faster_q <- q_label / 2

  strong_lai <- data.frame(ID = participant_ID[11:15],
                            ap = antipsychotic[11:15],
                            dose = original_dose[11:15], route = route[11:15],
                            q = faster_q, stringsAsFactors = FALSE)

  test_strong_lai <- to_cpz(strong_lai, ap_label="ap", dose_label="dose",
                     route="lai", q_label = "q", key = gardner2010_withsai)

  expect_equal(answers[11:15] * 2, test_strong_lai$cpz_eq)

  example_lai2 <- data.frame(ID = c(1,2,3,4),
                             ap = c("aripiprazole lauroxil", "paliperidone",
                                    "risperidone", "olanzapine"),
                             dose = c(441, 25, 2, 210),
                             route = c("lai", "lai", "lai", "lai"),
                             q = c(28, 28, 14, 14), stringsAsFactors = FALSE)

  test_lai_2 <- to_cpz(example_lai2, ap_label="ap", dose_label="dose",
                       route="lai", q_label = "q", key = leucht2020)
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
                     key = chlorpromazineR::gardner2010),
                "convert_to antipsychotic/route is not in the key")

  expect_error(to_ap(example_oral, convert_to_ap = "olanzapine",
                     convert_to_route = "nai", ap_label = "antipsychotic",
                     dose_label = "dose", route = "oral",
                     key = chlorpromazineR::gardner2010),
                "convert_to antipsychotic/route is not in the key")

  test_olanz <- to_ap(example_oral, convert_to_ap = "olanzapine",
                   convert_to_route = "oral", ap_label = "antipsychotic",
                   dose_label = "dose", route = "oral",
                   key = chlorpromazineR::gardner2010)

  expect_equal(test_olanz$ap_eq, olanz_answers)
})

test_that("to_ap() works with sai", {

  antipsychotic <- c("chlorpromazine HCl", "olanzapine tartrate",
                     "haloperidol lactate", "perphenazine USP")
  dose <- c(50, 5, 2.5, 5)
  example_sai <- data.frame(antipsychotic, dose, stringsAsFactors = FALSE)

  sai_answers <- c(2.5, 2.5, 2.5, 2.5)

  test_sai <- to_ap(example_sai, convert_to_ap = "haloperidol lactate",
                   convert_to_route = "sai", ap_label = "antipsychotic",
                   dose_label = "dose", route = "sai",
                   key = chlorpromazineR::gardner2010_withsai)

  expect_equal(test_sai$ap_eq, sai_answers)

  expect_error(to_ap(example_sai, convert_to_ap = "haloperidol lactate",
                   ap_label = "antipsychotic",
                   dose_label = "dose", route = "sai",
                   key = chlorpromazineR::gardner2010_withsai),
               "convert_to_route must be \"sai\" as well")

})
