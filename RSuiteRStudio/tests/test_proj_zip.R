#----------------------------------------------------------------------------
# RSuite
# Copyright (c) 2017, WLOG Solutions
#----------------------------------------------------------------------------

library(shinytest)
library(testthat)

source("R/test_utils.R")
source("R/project_managment.R")
app_dir = "apps/rstudio_06_prj_zip/"

context("Checking if addin for RSuite pkgzip creation works properly")

test_that_shiny_app(app_dir, "Testing if rstudio_04_prj_build() error handling works", {
  testnames <- c("non_existing_folder.R",
                 "non_existing_prj")
  expect_pass(testApp(appDir = app_dir, testnames = testnames,
                      interactive = FALSE, compareImages = FALSE))
})
