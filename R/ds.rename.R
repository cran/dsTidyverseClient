#' @title Rename columns
#' @description DataSHIELD implentation of \code{dplyr::rename}.
#' @param df.name Character specifying a serverside data frame or tibble.
#' @param tidy_expr List with format new_name = old_name to rename selected variables.
#' @param newobj Character specifying name for new server-side data frame.
#' @param datasources DataSHIELD connections object.
#' @return No return value, called for its side effects. An object (typically a data frame or tibble)
#' with the name specified by \code{newobj} is created on the server.
#' @importFrom DSI datashield.assign
#' @importFrom rlang enquo
#' @examples
#' \dontrun{
#' ## First log in to a DataSHIELD session with mtcars dataset loaded.
#'
#' ds.rename(
#'   df.name = "mtcars",
#'   tidy_select = list(new_var_1 = mpg, new_var_2 = cyl),
#'   newobj = "df_renamed",
#'   dataources = conns
#' )
#'
#' ## Refer to the package vignette for more examples.
#' }
#' @export
ds.rename <- function(df.name = NULL, tidy_expr = NULL, newobj = NULL, datasources = NULL) {
  tidy_expr <- .format_args_as_string(enquo(tidy_expr))
  datasources <- .set_datasources(datasources)
  .check_tidy_args(df.name, newobj)
  cally <- .make_serverside_call("renameDS", tidy_expr, list(df.name))
  datashield.assign(datasources, newobj, cally)
}
