roxygen2::roxygenize()
devtools::install_deps(dep = TRUE, repos='http://cran.us.r-project.org', upgrade='never')
devtools::build()
devtools::check()