#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#----------------------------------------------------------------------------

app <- ShinyDriver$new("../")
app$snapshotInit("non_existing_folder")

app$setInputs(project_folder = "$ghost_dir")
app$setInputs(start_btn = "click")
app$snapshot(list(output = "project_folder_err"))
