#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Package API related to RStudio integration.
#----------------------------------------------------------------------------

#'
#' RStudio addin which asks user for project parameters and starts the project.
#'
#' @details
#' Starts a project with the specified parameters.
#'
#' The following parameters can be specified by the user:
#' \itemize{
#'     \item{New project} - specifies whether a new project is being created
#'     \item{Existing project} - specifies whether the start operation will be made on an existing project
#'     \item{Project Name} - specifies the name of the started project
#'     \item{Folder} - path to the directory where the project will be started
#'     \item{Verbose Logging} - if checked additional messages will be printed during project starting
#'     \item{Skip adding RC} - if checked adding the started project under revision control will be skipped
#'     \item{Open started project} - if checked a new instance of RStudio will open the started project
#' }
#' @examples
#' \donttest{
#' rstudio_01_prj_start()
#' }
#'
#' @export
#'
rstudio_01_prj_start <- function() {
  assert(rstudioapi::isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(rstudioapi::getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         paste0("RStudio version(%s) is too old.",
                " RStudio v1.1.287 at least is required."),
         rstudio_ver)

  params <- run_gadget(caption = "Start RSuite project ...",
                       create_start_project_app()) # from 90_gadget_utils.R

  if (is.null(params)) {
    return(invisible())
  }

  projs <- list.files(params$prj_path, pattern = "*.Rproj", full.names = T)
  if (!length(projs)) {
    return(invisible())
  }

  if (params$open_prj) {
    rstudioapi::openProject(projs[1], newSession = T)
  }

}

#'
#' RStudio addin which asks user for package parameters and starts it.
#'
#' @details
#' Starts a package in a specific project
#'
#' The following parameters can be specified by the user
#' \itemize{
#'     \item{Package Name} - specifies the name of the started package
#'     \item{Project Folder} - specifies the project folder in which the package will be started
#'     \item{Verbose Logging} - if checked additional messages will be printed during package starting
#'     \item{Skip adding RC} - if checked adding the started package under revision control will be skipped
#' }
#'
#' @examples
#' \donttest{
#' rstudio_02_prj_start_package()
#' }
#'
#' @export
#'
rstudio_02_prj_start_package <- function() {
  assert(rstudioapi::isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(rstudioapi::getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         paste0("RStudio version(%s) is too old.",
                " RStudio v1.1.287 at least is required."),
         rstudio_ver)

  run_gadget(caption = "Start RSuite package...",
                       create_start_package_app()) # from 90_gadget_utils.R
  invisible()
}

#'
#' RStudio addin which installs project dependencies.
#'
#' @details
#'
#' If there is no project in context a dialog to select the project directory is shown.
#'
#' The following parameters can be specified by the user:
#' \itemize{
#'     \item{Project Folder} - specifies the project folder in which dependencies will be installed
#'     \item{Verbose Logging} - if checked additional messages will be printed during package starting
#' }
#'
#' @examples
#' \donttest{
#' rstudio_03_prj_install_deps()
#' }
#'
#' @export
#'
rstudio_03_prj_install_deps <- function() {
  assert(rstudioapi::isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(rstudioapi::getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         paste0("RStudio version(%s) is too old.",
                " RStudio v1.1.287 at least is required."),
         rstudio_ver)

  app <- create_prj_install_deps_app() # from 13_rsuite_project_run_gadget

  run_gadget(
    "Instaling project dependencies ...",
    app) # from 90_gadget_utils.R

  invisible()
}

#'
#' RStudio addin which builds the project.
#'
#' @details
#' If no project in context shows dialog to select project directory.
#'
#' The following parameters can be specified by the user:
#' \itemize{
#'     \item{Project Folder} - specifies the project which will be built
#'     \item{Verbose Logging} - if checked additional messages will be printed during package starting
#' }
#'
#' @examples
#' \donttest{
#' rstudio_04_prj_build()
#' }
#'
#' @export
#'
rstudio_04_prj_build <- function() {
  assert(rstudioapi::isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(rstudioapi::getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         paste0("RStudio version(%s) is too old.",
                " RStudio v1.1.287 at least is required."),
         rstudio_ver)

  app <- create_prj_build_app() # from 13_rsuite_project_run_gadget.R

  run_gadget(
    "Building project packages ...",
    app) # from 90_gadget_utils.R

  invisible()
}

#'
#' RStudio addin which cleans up project dependencies.
#'
#' @details
#' If no project in context shows dialog to select project directory.
#'
#' The following parameters can be specified by the user:
#' \itemize{
#'     \item{Project Folder} - specifies the project whose dependencies will be cleaned
#'     \item{Verbose Logging} - if checked additional messages will be printed during package starting
#' }
#'
#' @examples
#' \donttest{
#' rstudio_05_prj_clean_deps()
#' }
#'
#' @export
#'
rstudio_05_prj_clean_deps <- function() {
  assert(rstudioapi::isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(rstudioapi::getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         paste0("RStudio version(%s) is too old.",
                " RStudio v1.1.287 at least is required."),
         rstudio_ver)

  app <- create_prj_clean_deps_app()

  run_gadget(
    "Cleaning project dependencies ...",
    app) # from 90_gadget_utils.R

  invisible()
}


#'
#' RStudio addin which creates project deployment zip.
#'
#' @details
#' If no project in context shows dialog to select project directory.
#'
#' The following parameters can be specified by the user:
#' \itemize{
#'     \item{Specify Version} - specifies whether the zip version will be enforced
#'     \item{Detect Version} - specifies whether the zip version will be taken from RC
#'     \item{Zip Version} - specifies the zip version number. The expected form of the version is DD.DD
#'     \item{Project Folder} - specifies the project that will be zipped
#'     \item{Verbose Logging} - if checked additional messages will be printed during package starting
#' }
#'
#' @examples
#' \donttest{
#' rstudio_06_prj_zip()
#' }
#'
#' @export
#'
rstudio_06_prj_zip <- function() {
  assert(rstudioapi::isAvailable(), "No RStudio available")
  rstudio_ver <- as.character(rstudioapi::getVersion())
  assert(utils::compareVersion(rstudio_ver, "1.1.287") >= 0,
         paste0("RStudio version(%s) is too old.",
                " RStudio v1.1.287 at least is required."),
         rstudio_ver)

  app <- create_prj_zip_app() # from 16_prj_zip_run_gadget.R

  run_gadget(
    "Building project deployment zip ...",
    app) # from 90_gadget_utils.R

  invisible()
}
