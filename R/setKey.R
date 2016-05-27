#' Set-up AskCHIS API Key
#'
#' All functions require an API key. This function allows the user to define their API key once per session
#' rather than explicitely passing the API key with each query.
#' @param apiKey Your API key (required).
#' @keywords askchis chis api key
#' @export
#' @examples
#' \dontrun{
#' setKey('<YOUR API KEY>')
#' }

setKey <- function(apiKey) {

  if (missing(apiKey)) {
    stop("NO API KEY: You did not specify an API key. If you don't already have one, please contact askchis@ucla.edu to obtain an API key.", call. = FALSE)
  }

  options(askchisne.apiKey = apiKey)
}