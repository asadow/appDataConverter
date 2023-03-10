#' Dictionary: Building Identifiers
#'
#' Names, numbers, and addresses for buildings and sites.
#' @format
#' `sitenumber`: A data frame
#'  with `r nrow(sitenumber)` rows and `r ncol(sitenumber)` columns:
#' \describe{
#'   \item{site_number}{Site number.}
#'   \item{bldg_no}{Building number.}
#'   }
#' @examples
#' sitenumber
#' @source Raw data is the file named
#' "CSSL Site Listing with Site Numbers - as of October 5 2022.xls",
#' sent directly to Chris Payne from Sherry at ESA.
#' Chris did not have credentials to log into the ESA reporting site,
#' so he simply asked for the info.
"sitenumber"
