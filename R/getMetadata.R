#' Get AskCHIS NE Metadata
#' 
#' This function obtains all of the metadata available in AskCHIS NE. This includes
#' indicator labels, categories, variable years etc.
#' @param apiKey Your API key (required).
#' @keywords askchis chis
#' @import httr
#' @export
#' @examples
#' \dontrun{
#' getMetadata(apiKey = '<YOUR API KEY>')
#' # Returns a data frame with all of the metadata in AskCHIS NE.
#' }
getMetadata <- function(apiKey) {
  
  # Error definitions
  if (missing(apiKey)) {
    stop("NO API KEY: You did not specify an API key. If you don't already have one, please contact askchis@ucla.edu to obtain an API key.", call. = FALSE)
  }
  
  url <- "http://askchisne.azure-api.net/api/metadata"
  data <- data.frame(t(sapply(content(httr::GET(url, query = list(key = apiKey)), as = "parsed"), c)))
  removeCols <- c("dataSetId", "geoVariableMetadataId", "sourceVariable", "topic")
  data <- data[, !(names(data) %in% removeCols)]
  return(data)
}