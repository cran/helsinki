#' @title Helsinki Region Infoshare statistics API
#'
#' @description Retrieves data from the Helsinki Region Infoshare (HRI) 
#' statistics API: <http://dev.hel.fi/stats/>.
#' Currently provides access to the *aluesarjat* data: 
#' <https://stat.hel.fi/pxweb/fi/Aluesarjat/>.
#' 
#' @details Current implementation is very simple.
#' You can either get the list of resources with query="",
#' or query for a specific resources and retrieve it in a
#' three-dimensional array form.
#'
#' @param query A string, specifying the dataset to query
#' @param verbose logical. Should R report extra information on progress? 
#' Default is TRUE
#' @return multi-dimensional array
#'
#' @references See citation("helsinki") 
#' @author Juuso Parkkinen \email{louhos@@googlegroups.com}
#' @examples 
#' \dontrun{
#' stats_array <- get_hri_stats("aluesarjat_a03s_hki_vakiluku_aidinkieli")
#' }
#' 
#' @seealso See \url{https://dev.hel.fi/apis/statistics/}{dev.hel.fi website} and 
#' \url{http://dev.hel.fi/stats/}{API documentation} (in Finnish)
#' 
#' @importFrom httr parse_url build_url
#' @importFrom jsonlite fromJSON
#' 
#' @export
get_hri_stats <- function (query="", verbose=TRUE) {

  ## TODO
  # implement grepping for resources? as in eurostat
  if (verbose) {
    message("Accessing Helsinki Region Infoshare statistics API...\n")
  }

  # Use the regional statistics API
  api_url <- "http://dev.hel.fi/stats/resources/"
  if (query=="") {
    # For resources list
    query_url <- paste0(api_url, query)
  } else {
    # For a specific resource, use jsonstat
    query_url <- paste0(api_url, query, "/jsonstat")
  }

  graceful_result <- gracefully_fail(query_url)
  
  if (is.null(graceful_result)) {
    message("Please check your settings or function parameters \n")
    invisible(return(NULL))
  }
  
  # Access data with httr
  url <- httr::parse_url(query_url)
  url <- httr::build_url(url)
  
  # Process json into a list
  res_list <- jsonlite::fromJSON(url)
  
  # Process and show list of resources
  if (query=="") {
    resources <- names(res_list[["_embedded"]])
    names(resources) <- sapply(res_list[["_embedded"]], function(x) x$metadata$label)
    if (verbose)
      message("Retrieved list of available resources \n")
    return(resources)
    
  } else {
    
    ## Process jsonstat results into an array
    # For info about jsonstat, see http://json-stat.org/format/
    # Possible R package of use: https://github.com/ajschumacher/rjstat
    
    # Process dimensions metadata
    dims <- res_list$dataset$dimension$size
    names(dims) <- res_list$dataset$dimension$id
    dimnames <- lapply(res_list$dataset$dimension[3:(length(dims)+2)], 
                       function(x) {res=unlist(x$category$label); names(res)=NULL; res})
    
    # Construct an array
    
    # For special characters:
    # Merkintojen selitykset:
    #   .. (kaksi pistetta), tietoa ei ole saatu, se on liian epavarma ilmoitettavaksi tai se on salattu;
    # . (piste), loogisesti mahdoton esitettavaksi;
    # 0 (nolla), suure pienempi kuin puolet kaytetysta yksikosta.
    # assign NA to ".", and ".."
    # => simple as.numeric() is fine, produces NA for "." and ".."
    
    # Have to reverse the dimensions, because in arrays
    # "The values in data are taken to be those in the array with the leftmost subscript moving fastest."
    res_list$dataset$value[res_list$dataset$value %in% c(".", "..")] <- NA
    res.array <- array(data=as.numeric(res_list$dataset$value), 
                       dim=rev(dims), 
                       dimnames=rev(dimnames))
    if (verbose){
      message("Retrieved resource '",query,"'")
    }
    return(res.array)
  }
  #   # Test that it works
  #   query <- "aluesarjat_a03s_hki_vakiluku_aidinkieli"
  #   hki.vakiluku <- get_hri_stats(query)
  #   library(reshape2)
  #   df <- reshape2::melt(hki.vakiluku)
  
}
