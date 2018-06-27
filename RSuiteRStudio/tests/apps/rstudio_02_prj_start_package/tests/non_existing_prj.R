#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#----------------------------------------------------------------------------

app <- ShinyDriver$new("../")
app$snapshotInit("non_existing_prj")

app$setInputs(package_name = "TestPackage")
app$setInputs(project_folder = "$TEMP")
app$setInputs(skip_rc = TRUE)
app$setInputs(start_btn = "click")
app$snapshot(list(output = "project_folder_err"))
