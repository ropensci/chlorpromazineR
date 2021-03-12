# chlorpromazineR package
# See README.md
# test_known_values.R

context("Comparing result to Leucht spreadsheet")

test_that("oral doses conversion is accurate with Gardner 2010", {

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

  # different calculation methods, so need to round to 1 decimal to compare
  expect_equal(round(answers, 1), round(test$ap_eq, 1))

})
