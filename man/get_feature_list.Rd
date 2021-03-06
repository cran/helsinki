% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_feature_list.R
\name{get_feature_list}
\alias{get_feature_list}
\title{Print all available Features}
\usage{
get_feature_list(base.url = NULL)
}
\arguments{
\item{base.url}{a WFS url, for example "https://kartta.hsy.fi/geoserver/wfs"}
}
\value{
data frame
}
\description{
Basically a neat wrapper for "request=GetCapabilities".
}
\details{
Lists all <FeatureType> nodes.
}
\examples{
\dontrun{
dat <- get_feature_list(base.url = "https://kartta.hsy.fi/geoserver/wfs")
}

}
\seealso{
Use \code{\link{get_feature}} to download feature, 
\code{\link{select_feature}} for menu-driven listing and downloading
}
\author{
Pyry Kantanen <pyry.kantanen@gmail.com>
}
