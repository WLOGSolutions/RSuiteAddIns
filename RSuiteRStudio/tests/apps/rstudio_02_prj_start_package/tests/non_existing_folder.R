app <- ShinyDriver$new("../")
app$snapshotInit("non_existing_folder")

app$setInputs(package_name = "TestPackage")
app$setInputs(skip_rc = TRUE)
app$setInputs(project_folder = "$ghost_dir")
app$setInputs(start_btn = "click")
app$snapshot(list(output = "project_folder_err"))
