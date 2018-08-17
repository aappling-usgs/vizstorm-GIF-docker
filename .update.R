# Here are the lines you'll need to run each time you add R packages.

## edit the gran_pkgs <- line below!

# This file, and any others named beginning with '.', are ignored by packrat

# Before you get started, especially if you've pulled any updates from GitHub:
packrat::restore(overwrite.dirty=TRUE, prompt=FALSE)

# Decide which packages are already available on rocker/geospatial:3.5.1 and
# therefore don't need to be tracked by packrat (unless and until we need a
# different version). I got this list for copy-pasting by launching a container
# from rocker/geospatial and then running
# cat(paste0("'", rownames(installed.packages()), "'", collapse=', '))
ext_pkgs <- c('abind', 'assertive', 'assertive.base', 'assertive.code', 'assertive.data', 'assertive.data.uk', 'assertive.data.us', 'assertive.datetimes', 'assertive.files', 'assertive.matrices', 'assertive.models', 'assertive.numbers', 'assertive.properties', 'assertive.reflection', 'assertive.sets', 'assertive.strings', 'assertive.types', 'assertthat', 'backports', 'base64enc', 'BH', 'bindr', 'bindrcpp', 'BiocInstaller', 'bit', 'bit64', 'bitops', 'blob', 'bookdown', 'boot', 'brew', 'broom', 'callr', 'caTools', 'cellranger', 'class', 'classInt', 'cli', 'clipr', 'coda', 'codetools', 'colorspace', 'commonmark', 'concaveman', 'covr', 'crayon', 'crosstalk', 'curl', 'data.table', 'DBI', 'dbplyr', 'deldir', 'desc', 'devtools', 'dichromat', 'digest', 'docopt', 'dplyr', 'DT', 'dtplyr', 'e1071', 'evaluate', 'expm', 'fansi', 'feather', 'FNN', 'forcats', 'foreach', 'foreign', 'formatR', 'future', 'gdalUtils', 'gdata', 'gdtools', 'geometry', 'geoR', 'geosphere', 'ggplot2', 'git2r', 'globals', 'glue', 'gmailr', 'gmodels', 'goftest', 'gridExtra', 'gstat', 'gtable', 'gtools', 'haven', 'hdf5r', 'highr', 'hms', 'htmltools', 'htmlwidgets', 'httpuv', 'httr', 'hunspell', 'igraph', 'intervals', 'iterators', 'jsonlite', 'KernSmooth', 'knitr', 'labeling', 'Lahman', 'later', 'lattice', 'lazyeval', 'leaflet', 'leaflet.extras', 'LearnBayes', 'lidR', 'lintr', 'listenv', 'littler', 'lubridate', 'lwgeom', 'magic', 'magrittr', 'manipulateWidget', 'mapdata', 'mapedit', 'maps', 'maptools', 'mapview', 'markdown', 'MASS', 'Matrix', 'memoise', 'mgcv', 'microbenchmark', 'mime', 'miniUI', 'mockery', 'modelr', 'munsell', 'ncdf4', 'nlme', 'nycflights13', 'openssl', 'packrat', 'pillar', 'pingr', 'pkgbuild', 'pkgconfig', 'pkgload', 'PKI', 'plogr', 'plyr', 'png', 'polyclip', 'praise', 'prettyunits', 'processx', 'proj4', 'promises', 'purrr', 'R.methodsS3', 'R.oo', 'R.utils', 'R6', 'RandomFields', 'RandomFieldsUtils', 'RANN', 'raster', 'RColorBrewer', 'Rcpp', 'RCurl', 'readr', 'readxl', 'rematch', 'remotes', 'reprex', 'reshape2', 'rex', 'rgdal', 'rgeos', 'rgl', 'rhdf5', 'Rhdf5lib', 'RJSONIO', 'rlang', 'rlas', 'rmarkdown', 'rmdshower', 'RMySQL', 'RNetCDF', 'roxygen2', 'rpart', 'RPostgreSQL', 'rprojroot', 'rsconnect', 'RSQLite', 'rstudioapi', 'rticles', 'rversions', 'rvest', 'satellite', 'scales', 'selectr', 'servr', 'settings', 'sf', 'shiny', 'sourcetools', 'sp', 'spacetime', 'spatstat', 'spatstat.data', 'spatstat.utils', 'spData', 'spdep', 'splancs', 'stringdist', 'stringi', 'stringr', 'svglite', 'tensor', 'testit', 'testthat', 'tibble', 'tidyr', 'tidyselect', 'tidyverse', 'tinytex', 'tmap', 'tmaptools', 'tufte', 'units', 'utf8', 'uuid', 'V8', 'viridis', 'viridisLite', 'webshot', 'whisker', 'withr', 'xfun', 'XML', 'xml2', 'xtable', 'xts', 'yaml', 'zoo', 'base', 'compiler', 'datasets', 'graphics', 'grDevices', 'grid', 'methods', 'parallel', 'splines', 'stats', 'stats4', 'tcltk', 'tools', 'utils')
R_pkgs <- c('base', 'compiler', 'datasets', 'graphics', 'grDevices', 'grid', 'methods', 'parallel', 'splines', 'stats', 'stats4', 'tcltk', 'tools', 'utils') #rownames(utils::installed.packages(grep('lib-R', packrat:::getLibPaths(), value=TRUE)))
rocker_pkgs <- c(ext_pkgs, R_pkgs)

# Create additional symlinks from the system libraries to the packrat/lib
# directory for those packages that are dependencies of GRAN or GitHub packages.
# This helps with packrat::snapshot(), which throws errors if there are packages
# in packrat/lib that depend on packages only available in packrat/lib-ext or
# packrat/lib-R (the system libs). So that we don't have to re-run this every
# time we add a package, just copy all rocker_packages
ext_details <- utils::installed.packages(packrat:::getDefaultLibPaths())
pack_lib <- grep('/lib/', packrat:::getLibPaths(), value=TRUE)
success <- sapply(rocker_pkgs, function(pkg) {
  source <- file.path(ext_details[pkg,'LibPath'], pkg)
  target <- file.path(pack_lib, pkg)
  if(!file.exists(target)) {
    message('symlinking ', pkg)
    succeeded <- packrat:::ensurePackageSymlink(source, target) # produces T/F about success
    if(!succeeded) {
      stop('failed to symlink ', pkg)
    }
  } else {
    return(NA)
  }
})

# Run this after you've installed+libraried any new packages
packrat::snapshot()

# Amend the DESCRIPTION files of GRAN packages to include a Repository line.
# This is needed to avoid "Error: Unable to retrieve package records" during
# packrat::restore()
library(dplyr)
gran_pkgs <- c('dataRetrieval')
for(pkg in gran_pkgs) {
  desc_file <- file.path(find.package(pkg), 'DESCRIPTION')
  desc_lines <- readr::read_lines(desc_file)
  repo_line <- grep('Repository: ', desc_lines)
  if(length(repo_line) > 0) desc_lines <- desc_lines[-repo_line]
  desc_lines <- c(desc_lines, 'Repository: USGS')
  readr::write_lines(desc_lines, desc_file)
}

# Once you're done adding packages and snapshotting, remove those symlinks
success <- sapply(rocker_pkgs, function(pkg) {
  symlink <- file.path(pack_lib, pkg)
  is.symlink <- !is.na(Sys.readlink(symlink)) && (Sys.readlink(symlink) != "")
  if(is.symlink) {
    message('removing symlink for ', pkg)
    unlink(symlink)
  }
})

# After you've done all that, it's time to make sure your local (non-container)
# packrat/lib is completely up to date. This will allow us to copy files from
# that directory when we rebuild the image.
packrat::restore(overwrite.dirty=TRUE, prompt=FALSE)
