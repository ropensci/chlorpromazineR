# chlorpromazineR package
# See README.md
# test_key.R

context("checking key manipulation functions")

test_that("trim_key() works with gardner2010 data", {

  trimmed <- trim_key(gardner2010_withsai)

  original_sai <-  c("chlorpromazine hcl", "clotiapine injectable", 
                     "fluphenazine hcl", "haloperidol lactate", "loxapine hcl")

  expected_sai <- c("chlorpromazine", "clotiapine", "fluphenazine", 
                    "haloperidol", "loxapine")

  original_lai <- c("clopenthixol decanoate", "flupenthixol decanoate",  
                    "fluphenazine decanoate", "fluphenazine enanthate", 
                    "fluspirilene")

  expected_lai <- c("clopenthixol", "flupenthixol", "fluphenazine", 
                    "fluphenazine", "fluspirilene")

  expect_equal(names(gardner2010_withsai$sai)[1:5], original_sai)
  expect_equal(names(trimmed$sai)[1:5], expected_sai)
  expect_equal(names(gardner2010_withsai$lai)[1:5], original_lai)
  expect_equal(names(trimmed$lai)[1:5], expected_lai)
})

test_that("add_key() works with gardner2010 and leucht2016", {

  merged <- add_key(gardner2010, leucht2016, trim=TRUE)

  expect_equal(merged$oral$haloperidol, gardner2010$oral$haloperidol)
  expect_equal(merged$oral$tiapride, leucht2016$oral$tiapride)

  expect_warning(add_key(gardner2010, leucht2016, trim=FALSE))

})

test_that("has_long_name() does as it says", {

  expect_equal(has_long_name(gardner2010), TRUE)
  expect_equal(has_long_name(gardner2010_withsai), TRUE)
  expect_equal(has_long_name(leucht2016), FALSE)
    
})

test_that("included keys are valid format", {
  expect_equal(check_key(gardner2010), TRUE)
  expect_equal(check_key(gardner2010_withsai), TRUE)
  expect_equal(check_key(leucht2016), TRUE)
  expect_equal(check_key(davis1974), TRUE)
  expect_equal(check_key(woods2003), TRUE)
  expect_equal(check_key(yu2023), TRUE)
  expect_equal(check_key(yu2023_scz), TRUE)
})

test_that("yu2023 contains chlorpromazine-equivalent doses for oral drugs", {
  expect_equal(yu2023$oral$chlorpromazine, 1)
  expect_equal(yu2023$oral$olanzapine, 30)
  expect_equal(yu2023$oral$haloperidol, 30 / 0.68)
  expect_equal(yu2023$oral$risperidone, 30 / 0.32)
  expect_length(yu2023$sai, 0)
  expect_length(yu2023$lai, 0)
})

test_that("yu2023_scz contains schizophrenia chlorpromazine-equivalent doses", {
  expect_equal(yu2023_scz$oral$chlorpromazine, 1)
  expect_equal(yu2023_scz$oral$olanzapine, 30)
  expect_equal(yu2023_scz$oral$haloperidol, 30 / 0.74)
  expect_equal(yu2023_scz$oral$risperidone, 30 / 0.38)
  expect_equal(yu2023_scz$oral$ziprasidone, 30 / 7.92)
  expect_equal(yu2023_scz$oral$quetiapine, 30 / 32.27)
  expect_equal(yu2023_scz$oral$aripiprazole, 30 / 1.41)
  expect_equal(yu2023_scz$oral$asenapine, 30 / 0.89)
  expect_length(yu2023_scz$sai, 0)
  expect_length(yu2023_scz$lai, 0)
})
