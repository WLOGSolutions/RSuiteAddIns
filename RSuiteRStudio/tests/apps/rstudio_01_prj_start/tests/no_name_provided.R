app <- ShinyDriver$new("../")
app$snapshotInit("no_name_provided")

app$setInputs(start_btn = "click")
app$snapshot(list(output = "project_name_err"))
