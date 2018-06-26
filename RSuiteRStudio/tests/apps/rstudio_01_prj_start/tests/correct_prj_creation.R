app <- ShinyDriver$new("../")
app$snapshotInit("correct_prj_creation")

app$setInputs(project_name = "TestProject")
app$setInputs(project_folder = "$wspace_dir")
app$snapshot()
app$setInputs(start_btn = "click", wait_ = FALSE, values_ = FALSE)
