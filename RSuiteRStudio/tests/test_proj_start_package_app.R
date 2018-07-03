#----------------------------------------------------------------------------
# RSuite
# Copyright (c) 2017, WLOG Solutions
#----------------------------------------------------------------------------

library(shinytest)
library(testthat)

source("R/test_utils.R")
source("R/project_managment.R")
app_dir = "apps/rstudio_02_prj_start_package/"

context("Checking if addin for RSuite package creation works properly")


test_that_shiny_app(app_dir, "Correct package creation", {
  # Create test project
  prj <- init_test_project()
  params <- prj$load_params()

  # Add package to created project
  app <- ShinyDriver$new(app_dir)
  app$setInputs(package_name = "TestPackage")
  app$setInputs(project_folder = file.path("$wspace_dir", "TestProject"))
  app$setInputs(skip_rc = TRUE)
  app$setInputs(start_btn = "click", wait_ = FALSE, values_ = FALSE)
  app$refresh()
  app$stop()

  expect_true(dir.exists(file.path(params$pkgs_path, "TestPackage")))
})


test_that_shiny_app(app_dir, "Existing pkg handling", {
  prj <- init_test_project()
  create_test_package("TestPackage", prj = prj)

  expect_pass(testApp(appDir = app_dir, testnames = "existing_pkg",
              interactive = FALSE, compareImages = FALSE))
})


test_that_shiny_app(app_dir, "Testing if rstudio_02_prj_start_package() error handling works", {
  testnames <- c("no_folder_and_pkg_name",
                 "no_pkg_name",
                 "non_existing_folder",
                 "non_existing_prj")

  expect_pass(testApp(appDir = app_dir, testnames = testnames,
                      interactive = FALSE, compareImages = FALSE))
})
