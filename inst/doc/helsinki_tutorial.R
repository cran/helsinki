## ----setup, include = FALSE---------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE, 
  warning = FALSE,
  fig.height = 7, 
  fig.width = 7,
  dpi = 75,
  purl = NOT_CRAN,
  eval = NOT_CRAN
)

## ----install_default, eval=FALSE----------------------------------------------
#  install.packages("helsinki")

## ----install_remotes, eval=FALSE----------------------------------------------
#  library(remotes)
#  remotes::install_github("ropengov/helsinki")

## ----load, message=FALSE, warning=FALSE, results='hide'-----------------------
library(helsinki)

## ----wfs1---------------------------------------------------------------------
input_url <- "https://kartta.hsy.fi/geoserver/wfs"

hsy_features <- get_feature_list(base.url = input_url)
# Select only features which are related to water utilities and services
hsy_vesihuolto <- hsy_features[which(hsy_features$Namespace == "vesihuolto"),]
hsy_vesihuolto
# We select our feature of interest from this list: Location of waterposts
feature_of_interest <- "vesihuolto:VH_Vesipostit_HSY"

## ----wfs2---------------------------------------------------------------------
input_url <- "https://kartta.hsy.fi/geoserver/wfs"
feature_of_interest <- "vesihuolto:VH_Vesipostit_HSY"

# downloading a feature
waterposts <- get_feature(base.url = input_url, typename = feature_of_interest)

# Visualizing the location of waterposts
if (exists("waterposts")) {
  if (!is.null(waterposts)) {
    plot(waterposts$geom)
  }
}

## ----wfs3, eval = FALSE-------------------------------------------------------
#  input_url <- "https://kartta.hsy.fi/geoserver/wfs"
#  
#  # Interactive example with select_feature
#  selected_feature <- select_feature(base.url = input_url)
#  feature <- get_feature(base.url = input_url, typename = selected_feature)
#  
#  # Skipping a redundant step with parameter get = TRUE
#  feature <- select_feature(base.url = input_url, get = TRUE)

## ----hsy_examples-------------------------------------------------------------
library(ggplot2)

pop_grid <- get_vaestotietoruudukko(year = 2018)
building_grid <- get_rakennustietoruudukko(year = 2020)

# Logarithmic scales to make the visualizations more discernible
if (!all(is.null(pop_grid), is.null(building_grid))) {
  ggplot(pop_grid) + geom_sf(aes(colour=log(asukkaita), fill=log(asukkaita)))
  ggplot(building_grid) + geom_sf(aes(colour=log(kerala_yht), fill=log(kerala_yht)))
}

## ----hsy_examples2------------------------------------------------------------
library(ggplot2)

pop_grid2 <- get_vaestotietoruudukko(year = 2011)
building_grid2 <- get_rakennustietoruudukko(year = 2011)

if (!all(is.null(pop_grid2), is.null(building_grid2))) {
  ggplot(pop_grid2) + geom_sf(aes(colour=log(ASUKKAITA), fill=log(ASUKKAITA)))
  ggplot(building_grid2) + geom_sf(aes(colour=log(ASVALJYYS), fill=log(ASVALJYYS)))
}

## ----servicemap, message=FALSE, warning=FALSE---------------------------------
# Search for "puisto" (park) (specify q="query")
search_puisto <- get_servicemap(query="search", q="puisto")
# Study results: 47 variables in the data frame
str(search_puisto, max.level = 1)

## ----search_example1----------------------------------------------------------
# Get names for the first 20 results
search_puisto$results$name.fi

# See what kind of data is given for services
names(search_puisto$results)

## ----search_example2----------------------------------------------------------
search_puisto <- get_servicemap(query="search", q="puisto", page_size = 30, page = 2)

str(search_puisto)
search_puisto$results$name.fi

## ----linkedevents, message=FALSE, warning=FALSE-------------------------------
# Search for current events
events <- get_linkedevents(query="event")
# Get names for the first 20 results
events$data$name$fi
# See what kind of data is given for events
names(events$data)

## ----mapping_example1, eval = FALSE-------------------------------------------
#  helsinki <- get_city_map(city = "helsinki", level = "suuralue")
#  espoo <- get_city_map(city = "espoo", level = "suuralue")
#  vantaa <- get_city_map(city = "vantaa", level = "suuralue")
#  kauniainen <- get_city_map(city = "kauniainen", level = "suuralue")
#  
#  library(ggplot2)
#  
#  if (!all(is.null(helsinki), is.null(espoo), is.null(vantaa), is.null(kauniainen), is.null(waterposts))) {
#    ggplot() +
#      geom_sf(data = helsinki) +
#      geom_sf(data = espoo) +
#      geom_sf(data = vantaa) +
#      geom_sf(data = kauniainen) +
#      geom_sf(data = waterposts)
#  }

## ----mapping_example2, eval=FALSE---------------------------------------------
#  map <- get_city_map(city = "helsinki", level = "suuralue")
#  voting_district <- get_city_map(city = "helsinki", level = "aanestysalue")

## ----mapping_example2_plot, eval=FALSE----------------------------------------
#  library(sf)
#  plot(sf::st_geometry(map))
#  plot(sf::st_geometry(voting_district))

## ----hri_stats1, message=FALSE, warning=FALSE---------------------------------
# Retrieve list of available data
stats_list <- get_hri_stats(query="")
# Show first results
head(stats_list)

if (!is.null(stats_list)) {
  # Retrieve a specific dataset
  stats_res <- get_hri_stats(query=stats_list[1])
  # Show the structure of the results
  str(stats_res)
}

## ----citation, comment=NA-----------------------------------------------------
citation("helsinki")

## ----sessioninfo, message=FALSE, warning=FALSE--------------------------------
sessionInfo()

