#' Get AskCHIS NE Metadata
#' 
#' This function obtains all of the metadata available in AskCHIS NE. This includes
#' indicator labels, categories, variable years etc.
#' @import httr
#' @import stringi
#' @import plyr
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
  removeCols <- c("dataSetId", "geoVariableMetadataId", "sourceVariable", "topic", "pooling", "visibility")
  data <- data[, !(names(data) %in% removeCols)]
  
  temp <- as.data.frame(matrix(unlist(data), nrow=length(unlist(data[1]))))
  colnames(temp) <- colnames(data)
  
  for (i in 1:length(temp)) {
    temp[,i] <- as.character(temp[,i])
  }
  
  # Split data to get combined year column
  split <- temp[,c(1,4)]
  
  # Split data frames to get a combined year column
  temp2 <- ddply(split, .(name), paste, .drop = FALSE)
  temp2 <- temp2[,c(1,3)]
  temp2$V2 <- gsub("\"", "", temp2$V2)
  temp2$V2 <- gsub(")", "", temp2$V2)
  temp2$V2 <- gsub("c\\(", "", temp2$V2)
  
  finalData <- plyr::join(temp2, temp, by = "name", match = "first")
  finalData$year <- NULL
  finalData <- plyr::rename(finalData, replace = c("V2" = "year"))
  finalData <- finalData[,c(1,3,4,2,5:7)]
  
  return(finalData)
}