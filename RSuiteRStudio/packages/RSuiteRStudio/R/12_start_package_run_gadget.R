#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Package creation wizard.
#----------------------------------------------------------------------------

#'
#' Creates a shiny app object which provides a GUI for starting packages.
#'
#' @keywords internal
#' @noRd
#'
create_start_package_app <- function() {
  ui_config <- list(
    extra_js = c("$('#package_name').focus();",
                 paste0("$('#package_name')",
                        ".parent()",
                        ".addClass('shiny-input-container-inline');")),
    top_panel = div(
      shiny::textOutput("package_name_err", inline = TRUE),
      shiny::textInput("package_name", "Package Name:",
                       placeholder = "Name of package to create"),
      selectInput("template_name", "Template Name", choices = NULL, width = "100%")
    ),
    options_panel = shiny::fillRow(
      shiny::checkboxInput("run_verbose",
                           label = "Verbose logging",
                           value = TRUE),
      shiny::checkboxInput("skip_rc",
                           label = "Skip adding to RC",
                           value = FALSE),
      height = "20px"
    ),
    start_btn_caption = "Start",

    prj_fld_label = "Project folder:",
    prj_fld_placeholder = "Enter project folder path"
  )

  srv_config <- list(
    select_folder_caption = "Select RSuite project folder",

    observe = function(input, output = NULL, session = NULL) {
      registered_templates <- RSuite::tmpl_list_registered()
      registered_templates <- registered_templates[registered_templates[, "HasPackageTemplate"],
                                                   "Name"]
      updateSelectInput(session,
                        "template_name", choices = registered_templates,
                        selected = "builtin")
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
        success <- validate_input(!is.null(prj),
                                  "project_folder", output,
                                  "project_folder_err",
                                  "Failed to detect project at the folder")
      }

      if (success) {
        set_default_folder(prj$path)
      }

      if (!validate_input(input$package_name != "",
                          "package_name", output,
                          "package_name_err", "Provide package name")) {
        success <- FALSE
      } else if (!validate_input(grepl("^[a-zA-Z0-9]+$", input$package_name),
                                 "package_name", output, "package_name_err",
                                 paste0("Invalid package name.",
                                        " It must consist of characters",
                                        " and/or digits only."))) {
        success <- FALSE
      } else if (success) {
        pkg_path <- file.path(prj$load_params()$pkgs_path, input$package_name)
        if (!validate_input(!dir.exists(pkg_path),
                            "package_name", output,
                            "package_name_err", "Package exists already.")) {
          success <- FALSE
        }
      }

      if (!success) {
        return()
      }
      return(list(prj = prj))
    },
    run = function(valid_result, input) {
      RSuite::prj_start_package(name = input$package_name,
                                prj = valid_result$prj,
                                skip_rc = input$skip_rc,
                                tmpl = input$template_name)
      invisible()
    }
  )

  return(create_shiny_app(ui_config, srv_config)) # from 90_gadget_utils.R
}
