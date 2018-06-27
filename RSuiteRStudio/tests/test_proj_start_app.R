#----------------------------------------------------------------------------
# RSuite
# Copyright (c) 2017, WLOG Solutions
#----------------------------------------------------------------------------

library(shinytest)
library(testthat)

source("R/test_utils.R")
source("R/project_managment.R")
app_dir = "apps/rstudio_01_prj_start/"

context("Checking if addin for installing dependencies in RSuite projects works properly")


test_that_shiny_app(app_dir, "Correct project creation", {
  app <- ShinyDriver$new(app_dir)
  app$setInputs(project_name = "TestProject")
  app$setInputs(project_folder = "$wspace_dir")
  app$setInputs(skip_rc = TRUE)
  app$setInputs(start_btn = "click", wait_ = FALSE, values_ = FALSE)
  app$refresh()
  app$stop()

  # check if project exists
  expect_true(dir.exists(file.path(get_wspace_dir(), "TestProject")))

})


test_that_shiny_app(app_dir, "Testing if rstudio_01_prj_start() error handling works", {
  testnames <- c("non_existing_folder",
                 "no_prj_name_provided",
                 "no_folder_and_prj_name")
  expect_pass(testApp(appDir = app_dir, testnames = testnames,
                      interactive = FALSE, compareImages = FALSE))
})
