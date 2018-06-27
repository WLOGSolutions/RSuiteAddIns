#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Test supporting tools.
#----------------------------------------------------------------------------

.test_env <- new.env()
assign("cleanup", c(), envir = .test_env)

test_that_shiny_app <- function(app_dir, desc, ...) {
  tryCatch({
    # setup environment variables
    old_wspace_dir <- Sys.getenv("wspace_dir")
    old_ghost_dir <- Sys.getenv("ghost_dir")
    Sys.setenv(wspace_dir = get_wspace_dir())
    Sys.setenv(ghost_dir = get_non_existing_dir())

    # setup logging
    root_level <- logging::getLogger()$level
    rsuite_level <- RSuite::rsuite_getLogger()$level

    on_test_exit(function() {
      # environment variables cleaning
      Sys.setenv(wspace_dir = old_wspace_dir)
      Sys.setenv(old_ghost_dir = old_ghost_dir)

      # loggers cleaning
      logging::setLevel(root_level)
      logging::setLevel(rsuite_level, RSuite::rsuite_getLogger())

      unlink(get_wspace_dir(), recursive = T, force = T)
    })

    log_file <- file.path(.get_create_dir("logs"), sprintf("test_%s.log", Sys.Date()))
    cat(sprintf("====> %s <====\n", desc), file = log_file, append = T)

    logging::setLevel("CRITICAL")
    logging::setLevel("DEBUG", logging::getLogger('rsuite'))
    logging::addHandler(action = logging::writeToFile,
                        file = log_file,
                        handler = "RSuite.tests.file.logger", level = "DEBUG",
                        logger = RSuite::rsuite_getLogger())


    test_that(desc, ...)
  }, finally = {
    fire_cleanups()
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
get_non_existing_dir <- function() { return(file.path(get_wspace_dir(), "non_existing"))}

