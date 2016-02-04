poolEstimate <- function(indicator, attributes = NULL, locations, apiKey) {
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