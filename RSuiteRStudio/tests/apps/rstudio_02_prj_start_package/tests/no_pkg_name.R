app <- ShinyDriver$new("../")
app$snapshotInit("no_pkg_name")

app$setInputs(skip_rc = TRUE)
app$setInputs(project_folder = "$wspace_dir")
app$setInputs(start_btn = "click")
app$snapshot(list(output = "package_name_err"))
