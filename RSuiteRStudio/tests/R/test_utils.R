#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Test supporting tools.
#----------------------------------------------------------------------------

.test_env <- new.env()
assign("cleanup", c(), envir = .test_env)

test_that_managed <- function(desc, ...) {
  tryCatch({
    # setup logging
    on_test_exit(function() {
      unlink(get_wspace_dir(), recursive = T, force = T)
    })
    test_that(desc, ...)
  }, finally = {
    fire_cleanups()
      unlink(get_wspace_dir(), recursive = T, force = T)
  })
}

fire_cleanups <- function() {
  cleanups <- get("cleanup", envir = .test_env)
  for(cup in cleanups) {
    cup()
  }
  assign("cleanup", c(), envir = .test_env)
}

on_test_exit <- function(cup) {
  cleanups <- get("cleanup", envir = .test_env)
  assign("cleanup", c(cup, cleanups), envir = .test_env)
}

.get_create_dir <- function(name) {
  dpath <- file.path(RSuite::prj_init()$path, "tests", name)
  if (!dir.exists(dpath)) {
    dir.create(dpath, recursive = T)
  }
  return(dpath)
}

get_wspace_dir <- function() { .get_create_dir("wspace") }

