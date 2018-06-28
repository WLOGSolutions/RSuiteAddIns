#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Diffrent utils used by gadget.
#----------------------------------------------------------------------------

#'
#' Internal package environment.
#'
#' @keywords internal
#' @noRd
#'
int_env <- new.env(parent = emptyenv())

#'
#' Gets default folder for gadgets.
#'
#' If not default folder set working directory is returned.
#'
#' If saved default folder does not exist any more working directory is assumed
#' to be default.
#'
#' Folder returned has normalized path.
#'
#' @param default_fld folder path to use if no default folder previously set.
#'   The folder must exist. (type: character)
#' @return existing folder path. (type: character)
#'
#' @keywords internal
#' @noRd
#'
get_default_folder <- function(default_fld = getwd()) {
  stopifnot(dir.exists(default_fld))
  if (!exists("def_fld", int_env)) {
    return(normalizePath(default_fld))
  }
  def_fld <- get("def_fld", int_env)
  if (!dir.exists(def_fld)) {
    return(normalizePath(default_fld))
  }
  return(def_fld)
}

#'
#' Sets default folder.
#'
#' @param fld path to folder to set as default. Directory must exist. (type: character)
#'
#' @keywords internal
#' @noRd
#'
set_default_folder <- function(fld) {
  stopifnot(dir.exists(fld))
  assign("def_fld", fld, int_env)
}

#'
#' Inquires user for existing folder.
#'
#' If user selects folder it becames new default folder.
#'
#' @param curr_fld folder to start at. (type: character(1))
#' @param caption caption to use for folder selection dialog. (type: character(1))
#'
#' @return existing folder path or NA
#'
#' @importFrom utils choose.dir
#'
#' @keywords internal
#' @noRd
#'
inquire_existing_folder <- function(curr_fld, caption) {
  if (.Platform$OS.type == "windows") {
    folder_path <- choose.dir(default = curr_fld, caption = caption)
  } else {
    folder_path <- rstudioapi::selectDirectory(caption = caption,
                                               path = curr_fld)
  }
  if (!is.na(folder_path)) {
    set_default_folder(folder_path)
  }
  return(folder_path)
}

#'
#' Handles input field validation related changes based on provided condition.
#'
#' Input field has class .-invalid invalid toggled based on condition. Error message is presented.
#'
#' @param condition is input valid (type: logical)
#' @param input_field_id id of validated field (type: character)
#' @param output shiny output
#' @param error_field_id id of field presenting error (type: character)
#' @param error_message text to put into error field (type: character)
#'
#' @return TRUE if condition is TRUE.
#'
#' @keywords internal
#' @noRd
#'
validate_input <- function(condition, input_field_id,
                           output, error_field_id, error_message) {
  shinyjs::toggleCssClass(input_field_id, "-invalid", !condition)

  output[[error_field_id]] <-
  if (!condition) {
    shiny::renderText(error_message)
  } else {
    shiny::renderText("")
  }

  return(condition)
}


#'
#' Replaces environment markers in given input.
#'
#'
#' @param input input string (type: character(1)
#'
#' @return string with replaced input (type: character(1))
#'
#' @keywords internal
#' @noRd
#'
replace_env_markers <- function(input) {
  # find markers
  regxp <- "\\$[a-zA-W0-9_]+"
  markers <- unlist(regmatches(input, gregexpr(regxp, input)))

  if (length(markers) == 0) {
    # no markers to replace
    return(input)
  }

  # remove '$' sign
  var_names <- gsub("\\$", "", markers)
  values <- Sys.getenv(var_names)
  values <- normalizePath(values, "/")


  markers <- sprintf("\\%s", markers)
  output <- input
  for (i in seq_len(length(markers))) {
    output <- gsub(markers[i], values[i], output)
  }

  return(output)
}

#'
#' Creates gadget according to configuration provided and runs it.
#'
#' @param caption dialog caption.
#' @param ui_config configuration of gadget ui. Named list with following parameters:
#' \describe{
#'   \item{extra_js}{Lines to be inserted in initialization JS script tag (type: character)}
#'   \item{top_panel}{html block to put before folder inquery. (optional) }
#'   \item{prj_fld_label}{Label of folder inquery field. (optional; type: character)}
#'   \item{prj_fld_placeholder}{Placeholder of folder inquery field. (optional; type: character)}
#'   \item{options_panel}{html block with options.}
#'   \item{start_btn_caption}{Start button caption. (type: character)}
#' }
#' @param srv_config configuration for server function of gadget. Named list with following
#'   parameters:
#' \describe{
#'   \item{observe}{Function building observe section. (optional; function(input, output, server))}
#'   \item{select_folder_caption}{Caption of select folder dialog. (type: character)}
#'   \item{validate}{Function to validate input on submit. (function(input, output, server))}
#'   \item{run}{Function to run if validation on submit succeded. (function(val_result, input))}
#' }
#'
#' @keywords internal
#' @noRd
#'
run_gadget <- function(caption, app) {
  suppressMessages({
    shiny::runGadget(app,
                     viewer = shiny::dialogViewer(caption, height = 200))
  })
}


#'
#' Creates shiny app according to configuration provided and runs it.
#'
#' @param ui_config configuration of gadget ui. Named list with following parameters:
#' \describe{
#'   \item{extra_js}{Lines to be inserted in initialization JS script tag (type: character)}
#'   \item{top_panel}{html block to put before folder inquery. (optional) }
#'   \item{prj_fld_label}{Label of folder inquery field. (optional; type: character)}
#'   \item{prj_fld_placeholder}{Placeholder of folder inquery field. (optional; type: character)}
#'   \item{options_panel}{html block with options.}
#'   \item{start_btn_caption}{Start button caption. (type: character)}
#' }
#' @param srv_config configuration for server function of gadget. Named list with following
#'   parameters:
#' \describe{
#'   \item{observe}{Function building observe section. (optional; function(input, output, server))}
#'   \item{select_folder_caption}{Caption of select folder dialog. (type: character)}
#'   \item{validate}{Function to validate input on submit. (function(input, output, server))}
#'   \item{run}{Function to run if validation on submit succeded. (function(val_result, input))}
#' }
#'
#' @keywords internal
#' @noRd
#'
create_shiny_app <- function(ui_config, srv_config) {
  # preprocess ui_config
  ui_config$prj_fld_label <- ifelse(is.null(ui_config$prj_fld_label),
                                    "Folder:",
                                    ui_config$prj_fld_label)

  # preprocess srv_config
  ui_config$prj_fld_placeholder <- ifelse(is.null(ui_config$prj_fld_placeholder),
                                          "Specify path to create project at",
                                          ui_config$prj_fld_placeholder)

  ui <- miniUI::miniPage(
    shinyjs::useShinyjs(),
    tags$script(HTML(
      paste(c("$(function() {",
              "   $('#project_folder').parent().addClass('shiny-input-container-inline');",
              "   $('span[id$=\"_err\"]').addClass('-error-info');",
              "   $(document)",
              "      .on('keypress', function (e) {",
              "        if (e.which == 13 && $('#running_pane_holder.-running').length == 0) {",
              "          Shiny.onInputChange('start_btn', Date());",
              "        }",
              "      })",
              "      .on('keyup', function(e) {",
              "        if (e.which == 27) {",
              "             Shiny.onInputChange('escape_btn', Date()); }",
              "      });",
              "    $('#select_folder_btn').focusin(function() {",
              "       setTimeout(function() { $('#project_folder').focus(); }, 100);",
              "    });",
              ui_config$extra_js,
              "});"),
            collapse = "\n"))
    ),
    shinyjs::inlineCSS(list(
      "#project_folder" = "width: calc(100% - 40px);",
      ".form-control.-invalid" = "border-color: red !important",
      ".-error-info" = c("color: red;",
                         "position: absolute;",
                         "right: 0"),
      "#running_pane_holder *" = "z-index: 50",
      "#running_pane_holder" = "display: none",
      "#running_pane_holder.-running" = "display: initial",
      "#running_pane" = c("position: absolute;",
                          "left: -15px;",
                          "right: -15px;",
                          "top: -15px;",
                          "bottom: -15px;",
                          "background: lightgray;",
                          "opacity: 0.95"),
      "#running_pane_spinner" = c("position: absolute;",
                                  "left: calc(50% - 70px)",
                                  "top: 100px"),
      "#running_pane_spinner img" = c("width: 30px",
                                      "height: 30px"),
      "#running_pane_spinner span" = c("font-size: 18px",
                                       "margin-left: 25px",
                                       "vertival-align: middle"),
      "#select_folder_holder" = c("float: right"),
      "#start_btn" = c("width: 100px",
                       "float: right")
    )),
    miniUI::miniContentPanel(
      div(id = "running_pane_holder",
          div(id = "running_pane"),
          div(id = "running_pane_spinner",
              img(src = "www/spinner.gif"),
              span("Working ...")
              )
          ),

      if (is.null(ui_config$top_panel)) div() else ui_config$top_panel,

      div(id = "select_folder_holder",
          tags$label(HTML("&nbsp;"),
                     style = "display: block"),
          shiny::actionButton("select_folder_btn",
                              label = NULL,
                              icon = icon("angle-double-right"))),

      shiny::textOutput("project_folder_err", inline = TRUE),
      shiny::textInput("project_folder",
                label = ui_config$prj_fld_label,
                value = get_default_folder(),
                placeholder = ui_config$prj_fld_placeholder),

      ui_config$options_panel,

      hr(),

      shiny::actionButton("start_btn",
                          label = ui_config$start_btn_caption,
                          class = "btn-primary")

    )
  )

  server <- function(input, output, session) {
    if (!is.null(srv_config$observe)) {
      srv_config$observe(input, output, session)
    }

    shiny::observeEvent(input$select_folder_btn, {
      folder_path <- inquire_existing_folder(input$project_folder,
                                             srv_config$select_folder_caption)
      if (!is.na(folder_path)) {
        shiny::updateTextInput(session, "project_folder", value = folder_path)
        validate_input(TRUE, "project_folder", output, "project_folder_err", "")
      }
    })

    shiny::observeEvent(input$start_btn, {
      valid_result <- srv_config$validate(input, output, server)
      if (is.null(valid_result)) {
        return(invisible())
      }

      shinyjs::addCssClass("running_pane_holder", "-running")

      if (!is.null(input$run_verbose) && input$run_verbose) {
        old_level <- logging::getLogger()$getLevel()
        on.exit({
          logging::setLevel(old_level)
        },
        add = TRUE)

        logging::setLevel("DEBUG")
      }

      ret_val <- srv_config$run(valid_result, input)
      shiny::stopApp(returnValue = ret_val)
    })

    shiny::observeEvent(input$escape_btn, {
      shiny::stopApp()
    })
  }

  return(shiny::shinyApp(ui, server))
}
