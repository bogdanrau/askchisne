#' Pool AskCHIS NE Estimates
#' 
#' This function combines estimates for multiple geographic locations and is especially
#' useful in combining multiple locations that might have suppressed estimates to get an overall estimate.
#' @param indicator The indicator id (can be obtained using getMetadata()) (required).
#' @param attributes The specific attributes requested. A comma separated list that can include: estimate, population, SE, CI_L95, CI_U95, CV, MSE. Will return all if not specified (optional).
#' @param locations The specific locations requested to be pooled. A comma separated list that must include geoIds (can be obtained from geoSearch()) (required).
#' @param apiKey Your API key (required).
#' @keywords askchis chis
#' @export
#' @examples 
#' poolEstimate(indicator = 'OBESEA', attributes = 'estimate,population', locations = '666000,644000', apiKey = '<YOUR API KEY>')
#' Returns a data frame with adult obesity estimates and populations for Los Angeles and San Diego cities COMBINED.
poolEstimate <- function(indicator, attributes = NULL, locations, apiKey) {
  require(httr)
  
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
  
  if (missing(locations)) {
    stop("NO LOCATIONS: No locations specified to pool. Please enter at least two location geoIds.", call. = FALSE)
  }
  
  url <- paste0("http://askchisne.azure-api.net/api/variablepool/", indicator)
  data <- data.frame(t(sapply(content(GET(url, 
                                          query = list(
                                            key = apiKey,
                                            attributes = attributes,
                                            geoIds = locations
                                          ))),c)))
  
  # Extract attribute types
  data.attributes <- data.frame(t(sapply(data$attributeTypes,c)))
  
  # Extract data from geographies
  data.geographies <- data.frame(t(sapply(data$geographies[[1]],c)))
  
  # Extract attribute values
  data.values <- data.frame(t(sapply(data.geographies$attributes, c)))
  
  # Set column names to attributes
  colnames(data.values) <- unlist(data.attributes)
  
  # Create final dataset
  finalData <- cbind(data.geographies, data.values)
  finalData$attributes <- NULL
  
  # Convert columns to appropriate types
  characters <- list("geoName", "suppressionReason")
  factors <- list("geoId", "geoTypeId")
  booleans <- list("isSuppressed")
  numerics <- list("population", "estimate", "SE", "CI_LB95", "CI_UB95", "CV", "MSE")
  
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
    for (l in numerics) {
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