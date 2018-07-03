app <- ShinyDriver$new("../")
app$snapshotInit("existing_pkg")

app$setInputs(project_folder = file.path("$wspace_dir", "TestProject"))
app$setInputs(package_name = "TestPackage")
app$setInputs(start_btn = "click")
app$snapshot(list(output = "package_name_err"))
