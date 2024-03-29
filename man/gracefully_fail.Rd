% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wfs_api.R
\name{gracefully_fail}
\alias{gracefully_fail}
\title{Gracefully fail internet resources}
\source{
Gracefully failing HTTP request code (slightly adapted by Pyry
Kantanen) from RStudio community member kvasilopoulos. Many thanks!

Source of the original RStudio community discussion:
\url{https://community.rstudio.com/t/internet-resources-should-fail-gracefully/49199}
}
\usage{
gracefully_fail(remote.file, timeout.s = NULL)
}
\description{
Function for gracefully failing internet resources
}
\author{
Kostas Vasilopoulos
}
\keyword{internal}
