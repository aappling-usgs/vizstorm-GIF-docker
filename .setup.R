# Here are the lines I ran to initialize the project for packrat and git LFS.
# The symlinks section will need to be run once for each new computer where
# we're developing docker images

# This file, and any others named beginning with '.', are ignored by packrat

# Decide which packages are already available on rocker/geospatial:3.5.1 and
# therefore don't need to be tracked by packrat (unless and until we need a
# different version). I got this list for copy-pasting by launching a container
# from rocker/geospatial and then running
# cat(paste0("'", rownames(installed.packages()), "'", collapse=', '))
ext_pkgs <- c('abind', 'assertive', 'assertive.base', 'assertive.code', 'assertive.data', 'assertive.data.uk', 'assertive.data.us', 'assertive.datetimes', 'assertive.files', 'assertive.matrices', 'assertive.models', 'assertive.numbers', 'assertive.properties', 'assertive.reflection', 'assertive.sets', 'assertive.strings', 'assertive.types', 'assertthat', 'backports', 'base64enc', 'BH', 'bindr', 'bindrcpp', 'BiocInstaller', 'bit', 'bit64', 'bitops', 'blob', 'bookdown', 'boot', 'brew', 'broom', 'callr', 'caTools', 'cellranger', 'class', 'classInt', 'cli', 'clipr', 'coda', 'codetools', 'colorspace', 'commonmark', 'concaveman', 'covr', 'crayon', 'crosstalk', 'curl', 'data.table', 'DBI', 'dbplyr', 'deldir', 'desc', 'devtools', 'dichromat', 'digest', 'docopt', 'dplyr', 'DT', 'dtplyr', 'e1071', 'evaluate', 'expm', 'fansi', 'feather', 'FNN', 'forcats', 'foreach', 'foreign', 'formatR', 'future', 'gdalUtils', 'gdata', 'gdtools', 'geometry', 'geoR', 'geosphere', 'ggplot2', 'git2r', 'globals', 'glue', 'gmailr', 'gmodels', 'goftest', 'gridExtra', 'gstat', 'gtable', 'gtools', 'haven', 'hdf5r', 'highr', 'hms', 'htmltools', 'htmlwidgets', 'httpuv', 'httr', 'hunspell', 'igraph', 'intervals', 'iterators', 'jsonlite', 'KernSmooth', 'knitr', 'labeling', 'Lahman', 'later', 'lattice', 'lazyeval', 'leaflet', 'leaflet.extras', 'LearnBayes', 'lidR', 'lintr', 'listenv', 'littler', 'lubridate', 'lwgeom', 'magic', 'magrittr', 'manipulateWidget', 'mapdata', 'mapedit', 'maps', 'maptools', 'mapview', 'markdown', 'MASS', 'Matrix', 'memoise', 'mgcv', 'microbenchmark', 'mime', 'miniUI', 'mockery', 'modelr', 'munsell', 'ncdf4', 'nlme', 'nycflights13', 'openssl', 'packrat', 'pillar', 'pingr', 'pkgbuild', 'pkgconfig', 'pkgload', 'PKI', 'plogr', 'plyr', 'png', 'polyclip', 'praise', 'prettyunits', 'processx', 'proj4', 'promises', 'purrr', 'R.methodsS3', 'R.oo', 'R.utils', 'R6', 'RandomFields', 'RandomFieldsUtils', 'RANN', 'raster', 'RColorBrewer', 'Rcpp', 'RCurl', 'readr', 'readxl', 'rematch', 'remotes', 'reprex', 'reshape2', 'rex', 'rgdal', 'rgeos', 'rgl', 'rhdf5', 'Rhdf5lib', 'RJSONIO', 'rlang', 'rlas', 'rmarkdown', 'rmdshower', 'RMySQL', 'RNetCDF', 'roxygen2', 'rpart', 'RPostgreSQL', 'rprojroot', 'rsconnect', 'RSQLite', 'rstudioapi', 'rticles', 'rversions', 'rvest', 'satellite', 'scales', 'selectr', 'servr', 'settings', 'sf', 'shiny', 'sourcetools', 'sp', 'spacetime', 'spatstat', 'spatstat.data', 'spatstat.utils', 'spData', 'spdep', 'splancs', 'stringdist', 'stringi', 'stringr', 'svglite', 'tensor', 'testit', 'testthat', 'tibble', 'tidyr', 'tidyselect', 'tidyverse', 'tinytex', 'tmap', 'tmaptools', 'tufte', 'units', 'utf8', 'uuid', 'V8', 'viridis', 'viridisLite', 'webshot', 'whisker', 'withr', 'xfun', 'XML', 'xml2', 'xtable', 'xts', 'yaml', 'zoo', 'base', 'compiler', 'datasets', 'graphics', 'grDevices', 'grid', 'methods', 'parallel', 'splines', 'stats', 'stats4', 'tcltk', 'tools', 'utils')
R_pkgs <- c('base', 'compiler', 'datasets', 'graphics', 'grDevices', 'grid', 'methods', 'parallel', 'splines', 'stats', 'stats4', 'tcltk', 'tools', 'utils') #rownames(utils::installed.packages(grep('lib-R', packrat:::getLibPaths(), value=TRUE)))
rocker_pkgs <- c(ext_pkgs, R_pkgs)

# Set up the packrat part of the repo
library(packrat)
packrat::init()
packrat::set_opts(
  external.packages=rocker_pkgs,
  ignored.packages=rocker_pkgs,
  load.external.packages.on.startup=FALSE
)

# set up Git LFS (run in terminal)
# git lfs track "packrat/src/*"
# git add .gitattributes
