## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE, 
  warning = FALSE,
  fig.height = 7, 
  fig.width = 7,
  dpi = 75
)

## ----install_default, eval=FALSE----------------------------------------------
#  install.packages("helsinki")

## ----install_remotes, eval=FALSE----------------------------------------------
#  library(remotes)
#  remotes::install_github("ropengov/helsinki")

## ----load, message=FALSE, warning=FALSE, results='hide'-----------------------
library(helsinki)

## ----wfs1, eval = TRUE--------------------------------------------------------
url <- "https://kartta.hsy.fi/geoserver/wfs"

hsy_features <- get_feature_list(base.url = url)
# Select only features which are related to water utilities and services
hsy_vesihuolto <- hsy_features[which(hsy_features$Namespace == "vesihuolto"),]
hsy_vesihuolto
# We select our feature of interest from this list: Location of waterposts
feature_of_interest <- "vesihuolto:VH_Vesipostit_HSY"

## ----wfs2, eval = TRUE--------------------------------------------------------
# downloading a feature
waterposts <- get_feature(base.url = url, typename = feature_of_interest)
# Visualizing the location of waterposts
plot(waterposts$geom)

## ----wfs3, eval = FALSE-------------------------------------------------------
#  # Interactive example with select_feature
#  selected_feature <- select_feature(base.url = url)
#  feature <- get_feature(base.url = url, typename = selected_feature)
#  
#  # Skipping a redundant step with parameter get = TRUE
#  feature <- select_feature(base.url = url, get = TRUE)

## ----get_hsy_examples, eval = TRUE--------------------------------------------
pop_grid <- get_vaestotietoruudukko(year = 2018)
building_grid <- get_rakennustietoruudukko(year = 2020)

library(ggplot2)

# Logarithmic scales to make the visualizations more discernible
ggplot(pop_grid) + geom_sf(aes(colour=log(asukkaita), fill=log(asukkaita)))
ggplot(building_grid) + geom_sf(aes(colour=log(kerala_yht), fill=log(kerala_yht)))

## ----servicemap, message=FALSE, warning=FALSE---------------------------------
# Search for "puisto" (park) (specify q="query")
search_puisto <- get_servicemap(query="search", q="puisto")
# Study results: 47 variables in the data frame
str(search_puisto, max.level = 1)

## -----------------------------------------------------------------------------
# Get names for the first 20 results
search_puisto$results$name$fi

# See what kind of data is given for services
names(search_puisto$results)

## -----------------------------------------------------------------------------
search_puisto <- get_servicemap(query="search", q="puisto", page_size = 30, page = 2)
search_puisto$results$name$fi

## -----------------------------------------------------------------------------
# Search for padel-related services in Helsinki
search_padel <- get_servicemap(query="search", input="padel", only="unit.name, unit.location.coordinates, unit.street_address", municipality="helsinki")
search_padel$results

## ----linkedevents, message=FALSE, warning=FALSE-------------------------------
# Search for current events
events <- get_linkedevents(query="event")
# Get names for the first 20 results
events$data$name$fi
# See what kind of data is given for events
names(events$data)

## ----maps1, eval = TRUE-------------------------------------------------------
helsinki <- get_city_map(city = "helsinki", level = "suuralue")
espoo <- get_city_map(city = "espoo", level = "suuralue")
vantaa <- get_city_map(city = "vantaa", level = "suuralue")
kauniainen <- get_city_map(city = "kauniainen", level = "suuralue")

library(ggplot2)

ggplot() +
  geom_sf(data = helsinki) +
  geom_sf(data = espoo) +
  geom_sf(data = vantaa) +
  geom_sf(data = kauniainen) +
  geom_sf(data = waterposts)

## ----maps2, eval=FALSE--------------------------------------------------------
#  library(sf)
#  map <- get_city_map(city = "helsinki", level = "suuralue")
#  plot(sf::st_geometry(map))
#  
#  voting_district <- get_city_map(city = "helsinki", level = "aanestysalue")
#  plot(sf::st_geometry(voting_district))

## ----maps3, message=FALSE-----------------------------------------------------
# Load aluejakokartat and study contents
data(aluejakokartat)
str(aluejakokartat, m=2)

## ----hri_stats1, message=FALSE, warning=FALSE---------------------------------
# Retrieve list of available data
stats_list <- get_hri_stats(query="")
# Show first results
head(stats_list)

## ----hri_stats2, message=FALSE, warning=FALSE---------------------------------
# Retrieve a specific dataset
stats_res <- get_hri_stats(query=stats_list[1])
# Show the structure of the results
str(stats_res)

## ----citation, comment=NA-----------------------------------------------------
citation("helsinki")

## ----sessioninfo, message=FALSE, warning=FALSE--------------------------------
sessionInfo()

