#' Get AskCHIS NE Estimates
#' 
#' This function gets data from the AskCHIS NE API. If attributes = null, it will
#' return the population, estimate, as well as other statistical attributes.
#' @import httr
#' @import stringi
#' @import plyr
#' @param indicator The indicator id (can be obtained using getMetadata()) (required).
#' @param attributes The specific attributes requested. A comma separated list that can include: estimate, population, SE, CI_L95, CI_U95, CV, MSE. Will return all if not specified (optional).
#' @param geoLevel The specific level of geography requested. A list that can include: zcta, cities, counties, assembly, congress, senate, state (optional).
#' @param locations The specific locations requested. A comma separated list that must include geoIds (can be obtained from geoSearch()) (optional).
#' @param year The year of the data you request. Indicators and years available can be requested through the getMetadata() function. (optional).
#' @param apiKey Your API key (required).
#' @keywords askchis chis
#' @export
#' @examples 
#' \dontrun{
#' getEstimate(indicator = 'OBESEA', attributes = list("estimate", "population"), locations = list("666000", "644000"),
#'  year = 2014, apiKey = '<YOUR API KEY>')
#' # Returns a data frame with adult obesity estimates and populations for Los Angeles and
#' # San Diego cities.
#' }
getEstimate <- function(indicator, attributes = NULL, geoLevel = NULL, locations = NULL, year = NULL, apiKey) {
  
  # Error definitions
  if (missing(apiKey)) {
    stop("NO API KEY: You did not specify an API key. If you don't already have one, please contact askchis@ucla.edu to obtain an API key.", call. = FALSE)
  }
  
  if (missing(indicator)) {
    stop("NO INDICATOR: You did not specify an indicator. Please specify an indicator name. See the name column from a getMetadata() data frame.", call. = FALSE)
  }
  
  if (indicator == "") {
    stop("EMPTY INDICATOR TERM: Your indicator parameter was empty. Please specify a value for the indicator parameter.")
  }
  
  if (is.null(attributes)) {
    warning("No attributes specified. Returning all attributes.", call. = FALSE, immediate. = TRUE)
  }
  
  if (is.null(c(geoLevel, locations))) {
    warning("No geoLevel or location specified. Returning data for all possible locations. This might take a while...", call. = FALSE, immediate. = TRUE)
  }
  
  url <- paste0("http://askchisne.azure-api.net/api/variable/", indicator)
  
  # Collapse attribute list 
  if (is.null(attributes)) {
    attributeList <- NULL
  } else {
    attributeList <- paste0(attributes, collapse = ",")  
  }
  
  if (is.null(locations)) {
    locationsList <- NULL
  } else {
    locationsList <- paste0(locations, collapse = ",")
  }
  
  if (is.null(year)) {
    warning("No year specified. Returning the most recent data available.", call. = FALSE, immediate. = TRUE)
  } 
  
  data <- data.frame(t(sapply(content(httr::GET(url,
                                                query = list(
                                                  key = apiKey,
                                                  attributes = attributeList,
                                                  geoType = geoLevel,
                                                  geoIds = locationsList,
                                                  year = year
                                                  ))),c)))
  
  # Extract data from geographies
  data.geographies <- data.frame(t(sapply(data$geographies[[1]], c)))
  data.geographies$isSuppressed <- as.logical(data.geographies$isSuppressed)
  data.geographies$geoId <- as.factor(unlist(data.geographies$geoId))
  
  if (data$category != 'Health Topic') {
    suppressWarnings(
      data.values <- data.frame(cbind(
        unlist(data.geographies$geoId),
        as.data.frame(matrix(as.numeric(t(sapply(data.geographies$attributes, stringi::stri_list2matrix))), ncol = 2))
      ))
    )
  } else if (is.null(attributes)) {
    suppressWarnings(
      data.values <- data.frame(cbind(
        unlist(data.geographies$geoId),
        as.data.frame(matrix(as.numeric(t(sapply(data.geographies$attributes, stringi::stri_list2matrix))), ncol = 7))
      ))
    )
  } else {
    suppressWarnings(
      data.values <- data.frame(cbind(
        unlist(data.geographies$geoId),
        as.data.frame(matrix(as.numeric(t(sapply(data.geographies$attributes, stringi::stri_list2matrix))), ncol = length(attributes)))
      ))
    )
  }

  # Extract data from nested lists
  # For non-suppressed
  for (i in 1:length(data.values)) {
    data.values[[i]] <- unlist(data.values[[i]])
  }
  
  # Set column names to attributes
  characters <- list("geoName", "suppressionReason")
  factors <- list("geoId", "geoTypeId")
  booleans <- list("isSuppressed")
  numerics <- list("population", "estimate", "SE", "CI_LB95", "CI_UB95", "CV", "MSE")
  
  if (data$category != 'Health Topic') {
    colnames(data.values) <- c("geoId", "population", "estimate")
  } else if (!is.null(attributes)) {
  colnames(data.values) <- c("geoId", unlist(attributes))
  } else {
    colnames(data.values) <- c("geoId", unlist(numerics))
  }
  
  # Create final dataset
  finalData <- plyr::join(data.geographies, data.values, by = "geoId")
  
  # Join in datasetId, year, and unit
  finalData <- cbind(finalData, data$year, data$unit)
  
  # Strip HTML from units
  finalData$unit <- gsub("<sup>", "", finalData$unit)
  finalData$unit <- gsub("</sup>", "", finalData$unit)

  finalData$attributes <- NULL
  
  # Convert columns to appropriate types
  
  if (data$category != 'Health Topic') {
    numericsPresent <- list("population", "estimate")
  } else if (is.null(attributes)) {
    numericsPresent <- numerics
  } else {
    numericsPresent <- numerics[match(attributes, numerics)]
  }
  
  
  for (i in characters) {
    finalData[[i]] <- as.character(finalData[[i]])
  }
  
  for (j in factors) {
    finalData[[j]] <- as.factor(as.character(finalData[[j]]))
  }
  
  for (k in booleans) {
    finalData[[k]] <- as.logical(finalData[[k]])
  }
  
  suppressWarnings(
  for (l in numericsPresent) {
    finalData[[l]] <- as.numeric(as.character(finalData[[l]]))
  }
  )
  
  # Send warning messages if data frame contains suppressed cells
  if(any(is.na(finalData))) warning("Some estimates have been suppressed. Estimates are suppressed if the
population universe is less than 15,000, or if the coefficient of variation
is greater than 0.3.", call. = FALSE)
  
  # Reset row names and numbers
  rownames(finalData) <- seq(length = nrow(finalData))
  
  return(finalData)
}