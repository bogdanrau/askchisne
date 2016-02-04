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
  url <- "http://askchisne.azure-api.net/api/geosearch"
  data <- data.frame(t(sapply(content(GET(url, query = list(searchTerm = search, key = apiKey)), as = "parsed"), c)))
  removeCols <- c("year", "totalPopulation", "variables")
  data <- data[, !(names(data) %in% removeCols)]
  return(data)
}