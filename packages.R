# Below are the packages we need for the vizzy, organized by source location,
# and with comments with the code we used to install them. (The comments are useful to us humans, not required)

# from CRAN
# install.packages(c('arrayhelpers', 'fasterize', 'googledrive', 'snow'))
library(arrayhelpers)
library(fasterize)
library(googledrive)
library(snow)

# from GRAN - need to add a Repository: USGS line to each GRAN lib once installed
# add to .Rprofile: options(repos=c(USGS='https://owi.usgs.gov/R', CRAN=options()$repos[['CRAN']]))
library(dataRetrieval) # install.packages('dataRetrieval')

# from github
library(scipiper) # devtools::install_github('richfitz/remake'); devtools::install_github('USGS-R/scipiper@e5e90b11200aaf4448683889c7bd0ea487b6e9dd')

# from rocker/geospatial (shouldn't need to install)
library(dplyr)
library(googledrive)
library(httr)
library(jsonlite)
library(mapdata)
library(maps)
library(ncdf4)
library(sf)
library(tidyr)
library(xml2)
library(yaml)
