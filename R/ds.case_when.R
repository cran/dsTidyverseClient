#' @title A general vectorised if-else
#' @description DataSHIELD implementation of \code{dplyr::case_when}.
#' @param tidy_expr A list containing a sequence of two-sided formulas:
#' \itemize{
#'   \item The left hand side (LHS) determines which values match this case.
#'   \item The right hand side (RHS) provides the replacement value.
#'   \item The LHS inputs must evaluate to logical vectors.
#'   \item The RHS inputs will be coerced to their common type.
#'   }
#'   All inputs will be recycled to their common size. We encourage all LHS inputs to be the same size.
#'   Recycling is mainly useful for RHS inputs, where you might supply a size 1 input that will be
#'   recycled to the size of the LHS inputs. NULL inputs are ignored.
#' @param .default The value used when all of the LHS inputs return either FALSE or NA.
#' @param .ptype An optional prototype declaring the desired output type. If supplied, this overrides the common type of true, false, and missing.
#' @param .size An optional size declaring the desired output size. If supplied, this overrides the size of condition.
#' @param newobj Character specifying name for new server-side data frame.
#' @param datasources datashield connections object.
#' @return No return value, called for its side effects. A vector with the same size as the common
#' size computed from the inputs in \code{tidy_expr} and the same type as the common type of the
#' RHS inputs in \code{tidy_expr} is created on the server.
#' @importFrom DSI datashield.assign
#' @importFrom rlang enquo
#' @examples
#' \dontrun{
#' ## First log in to a DataSHIELD session with mtcars dataset loaded.
#'
#' ds.case_when(
#'   tidy_expr = list(
#'     mtcars$mpg < 10 ~ "low",
#'     mtcars$mpg >= 10 & mtcars$mpg < 20 ~ "medium",
#'     mtcars$mpg >= 20 ~ "high"
#'   ),
#'   newobj = "test",
#'   datasources = conns
#' )
#'
#' ## Refer to the package vignette for more examples.
#' }
#' @export
ds.case_when <- function(tidy_expr = NULL, .default = NULL, .ptype = NULL, .size = NULL,
                         newobj = NULL, datasources = NULL) {
  tidy_expr <- .format_args_as_string(enquo(tidy_expr))
  datasources <- .set_datasources(datasources)
  .check_tidy_args(NULL, newobj, check_df = FALSE)
  cally <- .make_serverside_call("caseWhenDS", tidy_expr, list(.default, .ptype, .size))
  datashield.assign(datasources, newobj, cally)
}
