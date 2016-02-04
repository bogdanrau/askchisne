geoSearch <- function(search, apiKey) {
  url <- "http://askchisne.azure-api.net/api/geosearch"
  data <- data.frame(t(sapply(content(GET(url, query = list(searchTerm = search, key = apiKey)), as = "parsed"), c)))
  removeCols <- c("year", "totalPopulation", "variables")
  data <- data[, !(names(data) %in% removeCols)]
  return(data)
}