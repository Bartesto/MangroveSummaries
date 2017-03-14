## Mangrove extent summary source script #######################################
##
## Various functions to aid with extent summaries for mangrove monitoring
## 
## Bart Huntley 13/03/2017


# puts correct shape file names in a list
shp_to_list <- function(dir = ".", search){
  shpList <- list.files(pattern = ".shp")
  shpList <- shpList[!grepl(".xml", shpList) & grepl(search, shpList)]
  shpnames <- tools::file_path_sans_ext(shpList)
  shpnames <- as.list(shpnames[!grepl(".KENS", shpnames)])
  return(shpnames)
}

# vectorised function to run over shape file list to access dbf's within shape
# files.
shplist_to_datalist <- function(x){
  d <- rgdal::readOGR(dsn = ".", layer = x)
  return(d@data)
}

# summarises as per old pivot tables per data frames. Groups by report region,
# density class, year and site name -- FOR EXTENT --
data_to_summarylist_E <- function(dfs){
  library(tidyverse)
  library(stringr)
  
  sumlist <- vector("list", 50)
  
  for(i in 1:length(dfs)){
    df.i <- dfs[[i]]
    reports <- as.character(unique(df.i$M_Regions))#number of report regions
    reports <- reports[!is.na(reports)]
    minlist <- vector("list", 5)
    for(j in 1:length(reports)){
      dc <- names(df.i)[grepl("DENS_CLA", names(df.i))]
      yr <- names(df.i)[grepl("Yr", names(df.i))]
      dots <- lapply(c(dc, "Alt_name", yr), as.symbol)
      report <- reports[j]
      df1 <- df.i%>%
        filter(M_Regions == report)%>%
        group_by_(.dots = dots)%>%
        summarise(Area = sum(HA_Area))%>%
        spread(Alt_name, Area)%>%
        ungroup()
      names(df1)[1:2] <- c("Density Class", "Year")
      df1$Year <- as.character(df1$Year)
      
      minlist[[j]] <- as.data.frame(df1)
      names(minlist)[j] <- paste0(report, "_", as.data.frame(df1[1,"Year"]))
    }
    minlist <- minlist[!sapply(minlist, is.null)]
    sumlist[[i]] <- minlist
  }
  sumlist <- sumlist[!sapply(sumlist, is.null)]
  return(sumlist)
}


# summarises as per old pivot tables per data frames. Groups by report region,
# density class, year and site name -- FOR CHANGE --
data_to_summarylist_C <- function(dfs, shplist){
  library(tidyverse)
  library(stringr)
  
  sumlist <- vector("list", 50)
  
  for(i in 1:length(dfs)){
    df.i <- dfs[[i]]
    reports <- as.character(unique(df.i$M_Regions))#number of report regions
    reports <- reports[!is.na(reports)]
    minlist <- vector("list", 5)
    lname <- substr(shplist[[i]], 16, 24)
    for(j in 1:length(reports)){
      dottrend <- lapply(c("Status", "Alt_name"), as.symbol)
      report <- reports[j]
      df1 <- df.i%>%
        filter(M_Regions == report)%>%
        group_by_(.dots = dottrend)%>%
        summarise(Area = sum(HA_Area))%>%
        spread(Alt_name, Area)%>%
        ungroup()
      
      minlist[[j]] <- as.data.frame(df1)
      names(minlist)[j] <- paste0(report, "_", lname)
    }
    minlist <- minlist[!sapply(minlist, is.null)]
    sumlist[[i]] <- minlist
  }
  sumlist <- sumlist[!sapply(sumlist, is.null)]
  return(sumlist)
}

# summarises as per old pivot tables per data frames. Groups by report region,
# density class, year and site name -- FOR TREND --
data_to_summarylist_T <- function(dfs){
  library(tidyverse)
  library(stringr)
  
  sumlist <- vector("list", 10)
  
  for(i in 1:length(dfs)){
    df.i <- dfs[[i]]
    reports <- as.character(unique(df.i$M_Regions))#number of report regions
    reports <- reports[!is.na(reports)]
    minlist <- vector("list", 5)
    lname <- as.character(levels(df.i[1, "TREND_YRS"]))
    for(j in 1:length(reports)){
      dottrend <- lapply(c("TrendClass", "Alt_name"), as.symbol)
      report <- reports[j]
      df1 <- df.i%>%
        filter(M_Regions == report & GRIDCODE != 0)%>% #removes meaningless NA's
        group_by_(.dots = dottrend)%>%
        summarise(Area = sum(HA_Area))%>%
        spread(Alt_name, Area)%>%
        ungroup()
      
      minlist[[j]] <- as.data.frame(df1)
      names(minlist)[j] <- paste0(report, "-", lname)
    }
    minlist <- minlist[!sapply(minlist, is.null)]
    sumlist[[i]] <- minlist
  }
  sumlist <- sumlist[!sapply(sumlist, is.null)]
  return(sumlist)
}


# Wrapper. Uses above functions to create summaries and output each to a sheet
# in an excel workbook -- FOR EXTENT --
extent_summary <- function(dpath, wpath, name){
  Sys.setenv("R_ZIPCMD" = "C:/Rtools/bin/zip.exe")
  library(openxlsx)
  setwd(dpath)
  shplist <- shp_to_list(search = "dis_sites")#beware search term
  dfs <- lapply(shplist, shplist_to_datalist)
  sumlist <- data_to_summarylist_E(dfs)#calling E version
  outlist <- unlist(sumlist, recursive = FALSE)
  xlname <- paste0(name, "-extent-summaries-", Sys.Date(), ".xlsx")
  setwd(wpath)
  write.xlsx(outlist, file = xlname)
}


# Wrapper. Uses above functions to create summaries and output each to a sheet
# in an excel workbook -- FOR CHANGE --
change_summary <- function(dpath, wpath, name){
  Sys.setenv("R_ZIPCMD" = "C:/Rtools/bin/zip.exe")
  library(openxlsx)
  setwd(dpath)
  shplist <- shp_to_list(search = "sites")#beware search term
  dfs <- lapply(shplist, shplist_to_datalist)
  sumlist <- data_to_summarylist_C(dfs, shplist)#calling C version
  outlist <- unlist(sumlist, recursive = FALSE)
  xlname <- paste0(name, "-change-summaries-", Sys.Date(), ".xlsx")
  setwd(wpath)
  write.xlsx(outlist, file = xlname)
}

# Wrapper. Uses above functions to create summaries and output each to a sheet
# in an excel workbook -- FOR TREND --
trend_summary <- function(dpath, wpath, name){
  Sys.setenv("R_ZIPCMD" = "C:/Rtools/bin/zip.exe")
  library(openxlsx)
  setwd(dpath)
  shplist <- shp_to_list(search = "dis_sites")#beware search term
  dfs <- lapply(shplist, shplist_to_datalist)
  sumlist <- data_to_summarylist_T(dfs)
  outlist <- unlist(sumlist, recursive = FALSE)
  xlname <- paste0(name, "-trend-summaries-", Sys.Date(), ".xlsx")
  setwd(wpath)
  write.xlsx(outlist, file = xlname)
}