#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Project creation wizard.
#----------------------------------------------------------------------------


#'
#' Creates a shiny app object which provides a GUI for starting projects.
#'
#' @keywords internal
#' @noRd
#'
create_start_project_app <- function() {
  ui_config <- list(
    extra_js = c("$('#project_name').focus();",
                 "$('#project_name').parent().addClass('shiny-input-container-inline');"),
    top_panel = div(
      radioButtons("is_project_new",
                   choices = list("New project" = "new", "Existing project" = "existing"),
                   selected = "new", label = NULL, inline = TRUE),

      textOutput("project_name_err", inline = TRUE),
      textInput("project_name", "Project Name:", placeholder = "Name of project to create")
    ),
    options_panel = fillRow(
      checkboxInput("run_verbose", label = "Verbose logging", value = TRUE),
      checkboxInput("skip_rc", label = "Skip adding to RC", value = FALSE),
      checkboxInput("open_prj", label = "Open started project", value = FALSE),
      height = "20px"
    ),
    start_btn_caption = "Start",

    prj_fld_label = "Folder:",
    prj_fld_placeholder = "Enter folder to start RSuite project in"
  )

  srv_config <- list(
    select_folder_caption = "Select folder to start RSuite project in",
    observe = function(input, output = NULL, session = NULL) {
      observe({
        shinyjs::toggleState("project_name", input$is_project_new == "new")
        if (input$is_project_new == "existing") {
          updateTextInput(session, "project_name", value = basename(input$project_folder))
          validate_input(TRUE, "project_name", output, "project_name_err", "")
        } else if (input$project_name == basename(input$project_folder)) {
          updateTextInput(session, "project_name", value = "")
        }
      })
    },
    validate = function(input, output, session) {
      success <- TRUE

      prj_path <- replace_env_markers(input$project_folder)

      if (!validate_input(dir.exists(prj_path), "project_folder",
                          output, "project_folder_err", "Folder does not exist")) {
        success <- FALSE
      }
      if (!validate_input(input$project_name != "", "project_name",
                          output, "project_name_err", "Provide project name")) {
        success <- FALSE
      }
      if (!success) {
        return(invisible())
      }

      if (input$is_project_new == "existing") {
        prj_path <- normalizePath(dirname(prj_path))
      }

      set_default_folder(prj_path)

      if (!success) {
        return()
      }
      return(list(prj_path = prj_path))
    },
    run = function(valid_result, input) {
      prj <- RSuite::prj_start(name = input$project_name, path = valid_result$prj_path, skip_rc = input$skip_rc)
      return(list(prj_path = prj$path,
                  open_prj = input$open_prj))
    }
  )

  return(create_shiny_app(ui_config, srv_config)) # from 90_gadget_utils
}
