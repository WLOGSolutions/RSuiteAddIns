#----------------------------------------------------------------------------
# RSuiteRStudio
#
# Global package definitions and imports
#----------------------------------------------------------------------------

#' @import RSuite
#' @import rstudioapi
#' @import miniUI
#' @import logging
#' @import utils
#' @rawNamespace import(shiny, except = runExample)
#' @rawNamespace import(shinyjs, except = runExample)
NULL


#' RStudio addin for the RSuite package
#'
#' Provides GUI for safe and reproducible solutions development with RSuite. \cr
#'
#'
#' @section RStudio addins
#' These functions provide RStudio addins for the RSuite API. They will help
#' you start a new project and a package inside of it, build the project,
#' install dependencies and prepare a deployment zip
#'
#' \describe{
#'     \item{\code{\link{rstudio_01_prj_start}}}{Addin for creating project structure at specified path.}
#'     \item{\code{\link{rstudio_02_prj_start_package}}}{Addin for creating package structure inside specified project.}
#'     \item{\code{\link{rstudio_03_prj_install_deps}}}{Addin for installing project dependencies and needed supportive packages.}
#'     \item{\code{\link{rstudio_04_prj_build}}}{Addin for building project internal packages and install them.}
#'     \item{\code{\link{rstudio_05_prj_clean_deps}}}{Addin for uninstalling unused packages from local project environment}
#'     \item{\code{\link{rstudio_06_prj_zip}}}{Addin for preparing deployment zip with tagged version}
