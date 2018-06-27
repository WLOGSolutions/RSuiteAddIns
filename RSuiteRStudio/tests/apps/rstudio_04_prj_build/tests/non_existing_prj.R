app <- ShinyDriver$new("../")
app$snapshotInit("non_existing_prj")

app$setInputs(project_folder = "$TEMP")
app$setInputs(start_btn = "click")
app$snapshot(list(output = "project_folder_err"))
