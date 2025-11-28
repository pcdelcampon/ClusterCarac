#' Telco Customer Churn (CSV)
#'
#' Raw Telco customer churn data (CSV) bundled in `inst/extdata`. Use
#' `system.file("extdata", "telco_churn.csv", package = "ClusterCarac")` to get
#' the path and read it with your preferred CSV reader.
#'
#' @format A CSV file with 7,043 rows and 21 columns:
#' \describe{
#'   \item{customerID}{Customer identifier.}
#'   \item{gender}{Customer gender (Female/Male).}
#'   \item{SeniorCitizen}{Logical indicator for senior citizen.}
#'   \item{Partner}{Logical indicator for having a partner.}
#'   \item{Dependents}{Logical indicator for dependents.}
#'   \item{tenure}{Months the customer has stayed with the company.}
#'   \item{PhoneService}{Logical indicator for phone service.}
#'   \item{MultipleLines}{Multiple lines (Yes/No/empty).}
#'   \item{InternetService}{Internet service type (DSL/Fiber optic/None).}
#'   \item{OnlineSecurity}{Logical indicator for online security.}
#'   \item{OnlineBackup}{Logical indicator for online backup.}
#'   \item{DeviceProtection}{Logical indicator for device protection.}
#'   \item{TechSupport}{Logical indicator for tech support.}
#'   \item{StreamingTV}{Logical indicator for streaming TV.}
#'   \item{StreamingMovies}{Logical indicator for streaming movies.}
#'   \item{Contract}{Contract type (Month-to-month/One year/Two year).}
#'   \item{PaperlessBilling}{Logical indicator for paperless billing.}
#'   \item{PaymentMethod}{Payment method.}
#'   \item{MonthlyCharges}{Monthly charges (numeric).}
#'   \item{TotalCharges}{Total charges (numeric).}
#'   \item{Churn}{Churn flag (True/False).}
#' }
#' @source Kimathi Newton, "Telco Customer Churn" dataset, mirrored from
#'   \url{https://raw.githubusercontent.com/KimathiNewton/Telco-Customer-Churn/refs/heads/master/Datasets/telco_churn.csv}
#' @examples
#' path <- system.file("extdata", "telco_churn.csv", package = "ClusterCarac")
#' if (file.exists(path)) {
#'   telco_churn <- read.csv(path)
#'   head(telco_churn)
#' }
#' @keywords datasets
#' @name telco_churn
#' @docType data
NULL
