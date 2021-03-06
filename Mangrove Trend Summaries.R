## Mangrove Trend Summaries
##
## From a folder of model output shape files the function will create "pivot
## table"-like summaries of mangrove density class by monitoring site. Summaries
## are output by year and reporting region.
##
## By Bart Huntley 14/03/2017

# source functions and set environment
source("Z:/DOCUMENTATION/BART/R/R_DEV/MangroveSummaries/Mangrove Helper Functions.R")
Sys.setenv("R_ZIPCMD" = "C:/Rtools/bin/zip.exe")

# user inputs
dpath <- "path to\\extent shapefiles"#character string, double backslash
wpath <- "path to\\where output goes"#character string, double backslash
name <- "name of workbook"#character string prepended to "-extent-summaries-date"

# run function
trend_summary(dpath, wpath, name)