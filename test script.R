source("Z:/DOCUMENTATION/BART/R/R_DEV/MangroveSummaries/Mangrove Helper Functions.R")

## for extent
dpath <- paste0("Z:\\DEC\\MangroveMonitoring\\Working\\Shark_Bay\\Condition\\",
                "Data\\timeseries\\EXTENT")
wpath <- "Z:\\DOCUMENTATION\\Software\\R\\R_Scripts\\mangove_summaries"
name <- "TEST"

extent_summary(dpath, wpath, name)


## for change
dpath <- paste0("Z:\\DEC\\MangroveMonitoring\\Working\\Shark_Bay\\Condition\\",
                "Data\\timeseries\\CHANGE")
wpath <- "Z:\\DOCUMENTATION\\Software\\R\\R_Scripts\\mangove_summaries"
name <- "TEST"

change_summary(dpath, wpath, name)


## for trends
dpath <- paste0("Z:\\DEC\\MangroveMonitoring\\Working\\Shark_Bay\\Condition\\",
                "Data\\timeseries\\TRENDS\\2007-2015LTD")
wpath <- "Z:\\DOCUMENTATION\\Software\\R\\R_Scripts\\mangove_summaries"
name <- "TEST"

trend_summary(dpath, wpath, name)
