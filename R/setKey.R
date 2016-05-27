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
  options(askchisne.apiKey = apiKey)
}