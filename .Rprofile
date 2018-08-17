# we should only launch packrat if we're opening the project from the rocker
# image. not sure how reliable the grepl below is across systems
is_rocker_image <- grepl('docker', Sys.info()[['release']])
if(is_rocker_image) {
  #### -- Packrat Autoloader (version 0.4.9-3) -- ####
  source("packrat/init.R")
  #### -- End Packrat Autoloader -- ####
}

# connect to GRAN
options(repos=c(USGS='https://owi.usgs.gov/R', CRAN=options()$repos[['CRAN']]))
