#----------------------------------------------------------------------------
# RSuite
# Copyright (c) 2017, WLOG Solutions
#----------------------------------------------------------------------------

library(shinytest)
library(testthat)

source("R/test_utils.R")
source("R/project_managment.R")
app_dir = "apps/rstudio_05_prj_clean_deps/"

context("Checking if addin for cleaning dependencies in RSuite projects works properly")

test_that_shiny_app(app_dir, "Correct deps cleaning", {
  # Prepare project
  prj <- init_test_project(repo_adapters = c("Dir"))
  params <- prj$load_params()

  # Prepare repo
  deploy_package_to_lrepo(pkg_file = "logging_0.7-103.tar.gz", prj = prj, type = "source")

  # Prepare package
  create_test_package("TestPackage", prj)

  # Install dependencies
  RSuite::prj_install_deps(prj = prj)
  expect_that_packages_installed(c("logging"), prj)

  # Build project
  RSuite::prj_build(prj = prj)
  expect_that_packages_installed(c("logging", "TestPackage"), prj)

  # Remove Package
  unlink(file.path(params$pkgs_path, "TestPackage"), recursive = T, force = T)

  # Clean deps using RStudio addin
  app <- ShinyDriver$new(app_dir)
  app$setInputs(project_folder = params$prj_path)
  app$setInputs(start_btn = "click", wait_ = FALSE, values_ = FALSE)
  app$refresh()
  app$stop()

  expect_that_packages_installed(c("logging"), prj)
})

test_that_shiny_app(app_dir, "Testing if rstudio_05_clean_deps() error handling works", {
  testnames <- c("non_existing_folder.R",
                 "non_existing_prj")
  expect_pass(testApp(appDir = app_dir, testnames = testnames,
                      interactive = FALSE, compareImages = FALSE))
})
