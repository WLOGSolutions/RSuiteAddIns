#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Retrieves project in context.
#----------------------------------------------------------------------------

#'
#' Asks user to provide project folder.
#'
#' @param run_func function to run then all parameters have been provided. Accepts
#'   single argument which is named list of following structure
#' \describe{
#'   \item{prj}{RSuite projects.}
#'   \item{verbose}{If creation of project should be run with verbose logging. (type: logical)}
#' }
#'
#' @return the result of run_func.
#'
#' @keywords internal
#' @noRd
#'
rsuite_project_run_gadget <- function(caption, run_func, ok_caption = "Build") {
  run_gadget(
    caption = caption,
    ui_config = list(
      extra_js = "$('#project_folder').focus();",
      options_panel = fillRow(
        checkboxInput("run_verbose", label = "Verbose logging", value = TRUE),
        height = "20px"
      ),
      start_btn_caption = ok_caption,

      prj_fld_label = "Project folder:",
      prj_fld_placeholder = "Enter project folder path"
    ),
    srv_config = list(
      select_folder_caption = "Select RSuite project folder",
      validate = function(input, output, session) {
        success <- TRUE

        if (!validate_input(dir.exists(input$project_folder),
                            "project_folder", output, "project_folder_err", "Folder does not exist")) {
          success <- FALSE
        } else {
          prj <- tryCatch({ RSuite::prj_init(input$project_folder) }, error = function(e) { NULL })
          success <- validate_input(!is.null(prj),
                                    "project_folder", output, "project_folder_err", "Failed to detect project at the folder")
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
    ))
}
