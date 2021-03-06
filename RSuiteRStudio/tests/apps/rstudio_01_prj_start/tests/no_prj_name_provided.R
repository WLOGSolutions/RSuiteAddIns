#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#----------------------------------------------------------------------------

app <- ShinyDriver$new("../")
app$snapshotInit("no_prj_name_provided")

app$setInputs(skip_rc = TRUE)
app$setInputs(start_btn = "click", values_ = FALSE, wait_ = FALSE)
app$snapshot(list(output = "project_name_err"), screenshot = FALSE)
