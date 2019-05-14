# chlorpromazineR package
# See README.md
# test_checks.R

context("checking functions behave")

test_that("check_ap() works with all matching example", {

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

  q <- c(14,14,14,14,7)

  example <- data.frame(antipsychotic, dose, q, route,
                        stringsAsFactors = FALSE)

  result <- check_ap(example, gardner2010_withsai, "antipsychotic", "mixed",
                     "route")

  expect_equal(0, result)

})

test_that("check_ap() works with single route example, sai", {

  antipsychotic <- c("Chlorpromazine HCl", "Clotiapine injectable", 
                     "Fluphenazine HCl", "Haloperidol lactate",
                     "Loxapine HCl")

  dose <- c(100, 40, 5, 5, 25)

  example <- data.frame(antipsychotic, dose, stringsAsFactors = FALSE)

  result <- check_ap(example, gardner2010_withsai, "antipsychotic", "sai")

  expect_equal(0, result)

  antipsychotic[2] <- "not real"
  example <- data.frame(antipsychotic, dose, stringsAsFactors = FALSE)
  result <- check_ap(example, gardner2010_withsai, "antipsychotic", "sai")
  expect_equal(1, result)


})

test_that("check_ap() works with single route example, oral", {
    
    antipsychotic <- c("Amisulpride", "Aripiprazole", "Benperidol",
                       "Chlorpromazine", "Clopenthixol")
    
    dose <- c(700, 30, 5, 600, 60)
    
    example <- data.frame(antipsychotic, dose, stringsAsFactors = FALSE)
    
    result <- check_ap(example, gardner2010, "antipsychotic", "oral")
    
    expect_equal(0, result)
    
    antipsychotic[2] <- "not real"
    example <- data.frame(antipsychotic, dose, stringsAsFactors = FALSE)
    result <- check_ap(example, gardner2010, "antipsychotic", "oral")
    expect_equal(1, result)
    
    
})

test_that("check_ap() works with mismatches in each route", {

  antipsychotic <- c("Amisulpride", "Aripiprazole", "Benperidol", 
                     "Chlorpromazine HCl", "Clopenthixol",

                     "Chlorpromazine HCl", "Clotiapine injectable", 
                     "Fluphenazine HCl", "Haloperidol",
                     "Loxapine HCl",

                     "Clopenthixol decanoate", "Flupenthixol", 
                     "Fluphenazine decanoate", "Fluphenazine enanthate", 
                     "Fluspirilene")

  dose <- c(700, 30, 5, 600, 60,
            100, 40, 5, 5, 25,
            300, 40, 25, 25, 6)

  route <- c(rep("oral", 5), rep("sai", 5), rep("lai", 5))

  q <- c(14,14,14,14,7)

  example <- data.frame(antipsychotic, dose, q, route,
                        stringsAsFactors = FALSE)

  result <- check_ap(example, gardner2010_withsai, "antipsychotic", "mixed",
                     "route")

  expect_equal(3, result)

})

test_that("included keys validate with check_key()", {

  expect_equal(TRUE, check_key(gardner2010))
  expect_equal(TRUE, check_key(leucht2016))

})

test_that("bad keys don't validate with check_key()", {

  expect_equal(TRUE, check_key(gardner2010))
  expect_equal(TRUE, check_key(leucht2016))

  gbad <- gardner2010
  names(gbad) <- c("oral", "sai", "depot")
  expect_error(check_key(gbad))

  expect_error(check_key(list(oral=1, sai=2)))

  expect_error(check_key(4))
  expect_error(check_key(c(4,4,4)))

  close <- list(oral=1,sai=2,lai=3)
  expect_error(check_key(close))

  closer <- list(oral=list(a="hi"),sai=list(a="hi"),lai=list(a="hi"))
  expect_error(check_key(closer))
})

test_that("trim_key() doesn't try to work on bad key", {

  expect_error(trim_key(3))

})

test_that("add_key() doesn't try to work on bad key", {

  expect_error(add_key(gardner2010, 3, trim = T))
  expect_error(add_key(3, gardner2010, trim = T))

})

