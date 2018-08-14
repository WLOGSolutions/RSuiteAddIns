#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# PKGZIP creation wizard.
#----------------------------------------------------------------------------

#'
#' Creates a shiny app object which provides a GUI for creating deployment zips.
#'
#' @keywords internal
#' @noRd
#'
create_prj_zip_app <- function() {
  ui_config <- list(
    extra_js = c("$('#project_folder').focus();",
                 paste0("$('#zip_version')",
                        ".parent()",
                        ".addClass('shiny-input-container-inline');")),
    bottom_panel = div(
      shiny::textInput("zip_version", "Zip Version:",
                       placeholder = "Zip version to create"),
      shiny::radioButtons("version_detection",
                          choices = list("Detect version" = "detect", "Specify Version" = "specify"),
                          selected = "detect", label = NULL, inline = TRUE)
    ),
    options_panel = shiny::fillRow(
      shiny::checkboxInput("run_verbose",
                           label = "Verbose logging",
                           value = TRUE),
      height = "20px"
    ),
    start_btn_caption = "Build",

    prj_fld_label = "Project folder:",
    prj_fld_placeholder = "Enter project folder path"
  )

  srv_config <- list(
    select_folder_caption = "Select RSuite project folder",

    observe = function(input, output = NULL, session = NULL) {
      observe({
        shinyjs::toggleState("zip_version", input$version_detection == "specify")
        if (input$version_detection == "detect") {
          updateTextInput(session, "zip_version", value = NULL)
        }
      })
    },

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
      zip_ver <- input$zip_version
      if (nchar(input$zip_version) == 0 && input$version_detection == "detect") {
        zip_ver <- NULL
      }

      ret_val <- RSuite::prj_zip(prj = valid_result$prj, zip_ver = zip_ver)
      return(ret_val)
    }
  )

  return(create_shiny_app(ui_config, srv_config)) # from 90_gadget_utils.R
}
