#' Search locations by name
#' 
#' Use this function to search for locations within the AskCHIS NE database
#' by name and obtain geoId, and location type.
#' @param search Search term (required).
#' @param apiKey Your API key (required).
#' @keywords askchis chis
#' @export
#' @examples 
#' geoSearch(search = 'Los Angeles', apiKey = <YOUR API KEY>)
#' Returns a data frame with all locations that match 'Los Angeles.'
geoSearch <- function(search, apiKey) {
  require(httr)
  
  # Error definitions
  if (missing(apiKey)) {
    stop("NO API KEY: You did not specify an API key. If you don't already have one, please contact askchis@ucla.edu to obtain an API key.", call. = FALSE)
  }
  
  if (missing(search)) {
    stop("NO SEARCH TERM: No search terms specified. Please specify a value for the search parameter.", call. = FALSE)
  }
  
  if (search == "") {
    stop("EMPTY SEARCH TERM: Your search parameter was empty. Please specify a value for the search parameter.", call. = FALSE)
  }
  
  url <- "http://askchisne.azure-api.net/api/geosearch"
  data <- data.frame(t(sapply(content(GET(url, query = list(searchTerm = search, key = apiKey)), as = "parsed"), c)))
  removeCols <- c("year", "totalPopulation", "variables")
  data <- data[, !(names(data) %in% removeCols)]
  return(data)
}