#----------------------------------------------------------------------------
# RSuite
# Copyright (c) 2017, WLOG Solutions
#----------------------------------------------------------------------------

library(shinytest)
library(testthat)

source("R/test_utils.R")
source("R/project_managment.R")
app_dir = "apps/rstudio_03_prj_install_deps/"

context("Checking if addin for installing dependencies in RSuite projects works properly")


test_that_shiny_app(app_dir, "Correct dependencies install", {
  # Prepare project
  prj <- init_test_project()
  params <- prj$load_params()

  # Prepare repo
  deploy_package_to_lrepo(pkg_file = "logging_0.7-103.tar.gz", prj = prj, type = "source")
  create_test_package("TestPackage", prj = prj, deps = "logging")

  app <- ShinyDriver$new(app_dir)
  app$setInputs(project_folder = params$prj_path)
  app$setInputs(start_btn = "click", wait_ = FALSE, values_ = FALSE)
  app$refresh()
  app$stop()

  expect_that_packages_installed(names = "logging", prj = prj, versions = "0.7-103")
})


test_that_shiny_app(app_dir, "Testing if rstudio_02_prj_install_deps() error handling works", {
  testnames <- c("non_existing_folder.R",
                 "non_existing_prj")
  expect_pass(testApp(appDir = app_dir, testnames = testnames,
                      interactive = FALSE, compareImages = FALSE))
})
