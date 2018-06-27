app <- ShinyDriver$new("../")
app$snapshotInit("no_folder_and_prj_name")

app$setInputs(project_folder = "$ghost_dir")
app$setInputs(skip_rc = TRUE)
app$setInputs(start_btn = "click")
app$snapshot(list(output = "project_name_err"))
app$snapshot(list(output = "project_folder_err"))
