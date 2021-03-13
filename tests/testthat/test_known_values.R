# chlorpromazineR package
# See README.md
# test_known_values.R

context("Comparing result to Leucht spreadsheet")

#http://www.cfdm.de/media/doc/Antipsychotic%20dose%20conversion%20calculator.xls

test_that("oral dose conversion is accurate with Gardner 2010", {

  antipsychotic <- c("Amisulpride", "Aripiprazole", "Benperidol",
                     "Chlorpromazine", "Clorprothixene", "Clopenthixol",
                     "Clotiapine", "Clozapine", "Droperidol",
                     "Flupenthixol", "Fluphenazine",
                     "Haloperidol", "Levomepromazine", "Loxapine",
                      "Mesoridazine","Molindone",  "Olanzapine",
                #     "Oxypertine",
                     "Paliperidone", "Pericyazine", "Perphenazine", "Pimozide",
                     "Prochlorperazine",  "Quetiapine", "Remoxipride",
                     "Risperidone", "Sertindole", "Sulpiride",  "Thioridazine",
                     "Thiothixene", "Trifluoperazine", "Trifluperidol",
                     "Triflupromazine", "Ziprasidone", "Zotepine",
                     "Zuclopenthixol")
  dose <- c(10)
  oral <- data.frame(antipsychotic, dose, stringsAsFactors = FALSE)

  answers <- c(0.29, 6.71, 40, 0.33, 0.4, 3.3, 2, 0.5, 20, 20,
               16.67, 20, 0.5, 3.3, 0.67, 2, 10,
               #8.33,
               22.2, 4, 6.71, 25, 2.3,
               0.27, 0.94, 33.33, 10, 0.25, 0.4, 6.7, 10, 100, 2, 1.25, 0.67,
               4)

  # excluding oxypertine as there appears to be an error in the spreadsheet
  # vs. the Gardner paper

  test <- to_ap(oral, ap_label = "antipsychotic", dose_label = "dose",
                route = "oral", key = gardner2010, convert_to_ap="olanzapine")

  expect_equal(answers, test$ap_eq, tolerance = 0.01)

})

test_that("LAI dose conversion is accurate with Gardner 2010", {

  antipsychotic <- c("risperidone microspheres")
  dose <- c(50)
  q <- c(14)
  lai <- data.frame(antipsychotic, dose, q, stringsAsFactors = FALSE)

  answers <- 19.84

  test <- to_ap(lai, convert_to_route = "oral", q_label = "q",
                ap_label = "antipsychotic", dose_label = "dose",
                route = "lai", key = gardner2010, convert_to_ap="olanzapine")

  expect_equal(answers, test$ap_eq, tolerance = .01)

})

test_that("oral dose conversion is accurate with Leucht 2020", {

  antipsychotic <- c("Aripiprazole", "Asenapine", "Brexpiprazole",
                     "Cariprazine",
                     "Haloperidol", "Iloperidone",  "Lurasidone",
                     "Olanzapine", "Paliperidone", "Quetiapine",
                     "Risperidone", "Sertindole", "Ziprasidone")
  dose <- c(10)
  oral <- data.frame(antipsychotic, dose, stringsAsFactors = FALSE)

  answers <- c(13.19, 10.13, 45.1, 19.88, 23.97, 7.54, 1.03, 10, 11.36,
               0.31, 24.23, 6.73, 0.81)

  test <- to_ap(oral, ap_label = "antipsychotic", dose_label = "dose",
                route = "oral", key = leucht2020, convert_to_ap="olanzapine")

  expect_equal(answers, test$ap_eq, tolerance = .01)

  answers_risp <- c(5.44, 4.18, 18.61, 8.20, 9.89, 3.11, 0.43,
                    4.13, 4.69, 0.13, 10.00, 2.78, 0.34)

  test_risp <- to_ap(oral, ap_label = "antipsychotic", dose_label = "dose",
                route = "oral", key = leucht2020, convert_to_ap="risperidone")

  expect_equal(answers_risp, test_risp$ap_eq, tolerance = .01)

})

test_that("LAI dose conversion is accurate with Leucht 2020", {

  antipsychotic <- c("aripiprazole lauroxil", "olanzapine", "paliperidone",
                     "risperidone")
  dose <- c(50)
  q <- c(14)

  # in spreadsheet, entered dose is 50/14, so 3.571429

  lai <- data.frame(antipsychotic, dose, q, stringsAsFactors = FALSE)

  answers <- c(3.28, 2.74, 5.65, 20.75)

  test <- to_ap(lai, convert_to_route = "oral", q_label = "q",
                ap_label = "antipsychotic", dose_label = "dose",
                route = "lai", key = leucht2020, convert_to_ap="olanzapine")

  expect_equal(answers, test$ap_eq, tolerance = .01)

  answers_risp <- c(1.35, 1.13, 2.33, 8.56)
  test_risp <- to_ap(lai, convert_to_route = "oral", q_label = "q",
                     ap_label = "antipsychotic", dose_label = "dose",
                     route = "lai", key = leucht2020,
                     convert_to_ap="risperidone")
  expect_equal(answers_risp, test_risp$ap_eq, tolerance = .01)

})


test_that("oral dose conversion is accurate with Davis 1974", {

  antipsychotic <- c("Acetophenazine", "Butaperazine", "Chlorprothixene",
                     "Fluphenazine", "Haloperidol", "Mesoridazine",
                     "Perphenazine", "Prochlorperazine", "Thioridazine",
                     "Thiothixene", "Trifluoperazine", "Triflupromazine")
  dose <- c(10)
  oral <- data.frame(antipsychotic, dose, stringsAsFactors = FALSE)

  answers <- c(42.55, 112.36, 22.78, 833.33, 625, 18.08, 112.36, 69.93, 10.49,
               192.31, 357.14, 35.21)

  test <- to_cpz(oral, ap_label = "antipsychotic", dose_label = "dose",
                route = "oral", key = davis1974)

  expect_equal(answers, test$cpz_eq, tolerance = 0.001)

})
