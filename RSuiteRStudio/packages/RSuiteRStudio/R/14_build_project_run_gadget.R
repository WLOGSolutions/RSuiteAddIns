#'
#' Creates a shiny app object which provides a GUI for building the project.
#'
#' @return shiny app object for building the project.
#'
#' @keywords internal
#' @noRd
#'
create_prj_build_app <- function() {
  ui_config <- list(
    extra_js = "$('#project_folder').focus();",
    options_panel = shiny::fillRow(
      shiny::checkboxInput("run_verbose",
                           label = "Verbose logging",
                           value = TRUE),
      shiny::checkboxInput("build_vignettes",
                           label = "Build vignettes",
                           value = FALSE),
      height = "20px"
    ),
    start_btn_caption = "Build",

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
      rstudioapi::sendToConsole("") # make console visible
      ret_val <- RSuite::prj_build(prj = valid_result$prj, vignettes = input$build_vignettes)
      return(ret_val)
    }
  )

  return(create_shiny_app(ui_config, srv_config)) # from 90_gadget_utils.R
}
