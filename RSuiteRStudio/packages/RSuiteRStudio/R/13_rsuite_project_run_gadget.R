#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Retrieves project in context.
#----------------------------------------------------------------------------


#'
#' Creates a shiny app asking to provide the project folder
#'
#' @param ok_caption caption of the 'OK' button (type: character(1))
#'
#' @param run_func function to run when all parameters have been provided. Accepts
#'   single argument which is named list of following structure (type: closure)
#'
#' @return shiny app object created in accordance with the provided arguments.
#'
#' @keywords internal
#' @noRd
#'
create_rsuite_project_app <- function(run_func, ok_caption) {
  ui_config <- list(
    extra_js = "$('#project_folder').focus();",
    options_panel = shiny::fillRow(
      shiny::checkboxInput("run_verbose",
                           label = "Verbose logging",
                           value = TRUE),
      height = "20px"
    ),
    start_btn_caption = ok_caption,

    prj_fld_label = "Project folder:",
    prj_fld_placeholder = "Enter project folder path"
  )

  srv_config <- list(
    select_folder_caption = "Select RSuite project folder",
    validate = function(input, output, session) {
      success <- TRUE
      project_folder <- replace_env_markers(input$project_folder)

      if (!validate_input(dir.exists(project_folder),
                          "project_folder", output,
                          "project_folder_err", "Folder does not exist")) {
        success <- FALSE
      } else {
        prj <- tryCatch({
          RSuite::prj_init(project_folder)
        },
        error = function(e) NULL)
        success <- validate_input(!is.null(prj), "project_folder",
                                  output, "project_folder_err",
                                  "Failed to detect project at the folder")
      }

      if (!success) {
        return()
      }

      set_default_folder(prj$path)
      return(list(prj = prj))
    },
    run = function(valid_result, input) {
      params <- list(prj = valid_result$prj, verbose = input$run_verbose)
      ret_val <- run_func(params)
      return(ret_val)
    }
  )

  return(create_shiny_app(ui_config, srv_config)) # from 90_gadget_utils.R
}


#'
#' Creates a shiny app object which provides a GUI for installing project dependencies.
#'
#' @return shiny app object for installing project dependencies.
#'
#' @keywords internal
#' @noRd
#'
create_prj_install_deps_app <- function() {
  run_func <- function(params) {
    rstudioapi::sendToConsole("") # make console visible
    RSuite::prj_install_deps(prj = params$prj)
  }

  return(create_rsuite_project_app(run_func, "Install"))
}


#'
#' Creates a shiny app object which provides a GUI for cleaning project dependencies.
#'
#' @return shiny app object for cleaning project dependencies.
#'
#' @keywords internal
#' @noRd
#'
create_prj_clean_deps_app <- function() {
  run_func <- function(params) {
    rstudioapi::sendToConsole("") # make console visible
    RSuite::prj_clean_deps(prj = params$prj)
  }

  return(create_rsuite_project_app(run_func, "Clean"))
}
