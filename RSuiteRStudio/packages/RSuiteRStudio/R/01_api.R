#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Package API related to RStudio integration.
#----------------------------------------------------------------------------

#'
#' RStudio addin which asks user for project parameters and starts the project.
#'
#' @export
#'
rstudio_01_prj_start <- function() {
  assert(isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         "RStudio version(%s) is too old. RStudio v1.1.287 at least is required.",
         rstudio_ver)

  params <- start_project_run_gadget()
  if (is.null(params)) {
    return(invisible())
  }

  projs <- list.files(params$prj_path, pattern = "*.Rproj", full.names = T)
  if (!length(projs)) {
    return(invisible())
  }

  if (params$open_prj) {
    openProject(projs[1], newSession = T)
  }
}

#'
#' RStudio addin which asks user for package parameters and starts it.
#'
#' @export
#'
rstudio_02_prj_start_package <- function() {
  assert(isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         "RStudio version(%s) is too old. RStudio v1.1.287 at least is required.",
         rstudio_ver)

  start_package_run_gadget()
  invisible()
}

#'
#' RStudio addin which installs project dependencies.
#'
#' If no project in context shows dialog to select project directory.
#'
#' @export
#'
rstudio_03_prj_install_deps <- function() {
  assert(isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         "RStudio version(%s) is too old. RStudio v1.1.287 at least is required.",
         rstudio_ver)

  rsuite_project_run_gadget(
    "Instaling project dependencies ...",
    function(params) { prj_install_deps(prj = params$prj) },
    ok_caption = "Install")
  invisible()
}

#'
#' RStudio addin which builds the project.
#'
#' If no project in context shows dialog to select project directory.
#'
#' @export
#'
rstudio_04_prj_build <- function() {
  assert(isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         "RStudio version(%s) is too old. RStudio v1.1.287 at least is required.",
         rstudio_ver)

  rsuite_project_run_gadget(
    "Building project packages ...",
    function(params) { RSuite::prj_build(prj = params$prj) })
  invisible()
}

#'
#' RStudio addin which cleans up project dependencies.
#'
#' If no project in context shows dialog to select project directory.
#'
#' @export
#'
rstudio_05_prj_clean_deps <- function() {
  assert(isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         "RStudio version(%s) is too old. RStudio v1.1.287 at least is required.",
         rstudio_ver)

  rsuite_project_run_gadget(
    "Cleaning project dependencies ...",
    function(params) { RSuite::prj_clean_deps(prj = params$prj) },
    ok_caption = "Clean")
  invisible()
}


#'
#' RStudio addin which creates project deployment zip.
#'
#' If no project in context shows dialog to select project directory.
#'
#' @export
#'
rstudio_06_prj_zip <- function() {
  assert(isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         "RStudio version(%s) is too old. RStudio v1.1.287 at least is required.",
         rstudio_ver)

  rsuite_project_run_gadget(
    "Building project deployment zip ...",
    function(params) { RSuite::prj_zip(prj = params$prj) })
  invisible()
}
