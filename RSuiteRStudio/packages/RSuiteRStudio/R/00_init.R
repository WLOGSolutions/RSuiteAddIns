#----------------------------------------------------------------------------
# RSuiteRStudio
# Copyright (c) 2017, WLOG Solutions
#
# Package initialization.
#----------------------------------------------------------------------------


.onLoad <- function(...) {
  addResourcePath("www", system.file("www", package = "RSuiteRStudio"))
}
