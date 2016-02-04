getMetadata <- function(key) {
  url <- "http://askchisne.azure-api.net/api/metadata"
  data <- data.frame(t(sapply(content(GET(url, query = list(key = key)), as = "parsed"), c)))
  removeCols <- c("dataSetId", "geoVariableMetadataId", "sourceVariable", "topic")
  data <- data[, !(names(data) %in% removeCols)]
  return(data)
}