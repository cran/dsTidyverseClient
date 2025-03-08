% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ds.mutate.R
\name{ds.mutate}
\alias{ds.mutate}
\title{Create, modify, and delete columns}
\usage{
ds.mutate(
  df.name = NULL,
  tidy_expr = NULL,
  newobj = NULL,
  .keep = "all",
  .before = NULL,
  .after = NULL,
  datasources = NULL
)
}
\arguments{
\item{df.name}{Character specifying a serverside data frame or tibble.}

\item{tidy_expr}{List of tidyselect syntax to be passed to dplyr::mutate.}

\item{newobj}{Character specifying name for new server-side data frame.}

\item{.keep}{Control which columns from \code{df.name} are retained in the output. Options include:
\itemize{
  \item \code{"all"}: Retains all columns from \code{df.name}. This is the default.
  \item \code{"used"}: Retains only the columns used in \code{tidy_expr} to create new columns.
  \item \code{"unused"}: Retains only the columns not used in \code{tidy_expr} to create new columns. This is useful if you generate new columns but no longer need the columns used to generate them.
  \item \code{"none"}: Doesn't retain any extra columns from \code{df.name}. Only the grouping variables and columns created by \code{tidy_expr} are kept.
}
Grouping columns and columns created by \code{tidy_expr} are always kept.}

\item{.before}{<tidy-select> Optionally, control where new columns should appear (the default is
to add to the right hand side). See \code{tidy_expr} for more details.}

\item{.after}{<tidy-select> Optionally, control where new columns should appear (the default is
to add to the right hand side). See \code{tidy_expr} for more details.}

\item{datasources}{datashield connections object.}
}
\value{
No return value, called for its side effects. An object (typically a data frame or tibble)
with the name specified by \code{newobj} is created on the server.
}
\description{
DataSHIELD implementation of \code{dplyr::mutate}.
}
\examples{
\dontrun{
## First log in to a DataSHIELD session with mtcars dataset loaded.

ds.mutate(
  df.name = "mtcars",
  tidy_select = list(mpg_trans = cyl * 1000, new_var = (hp - drat) / qsec),
  newobj = "df_with_new_cols"
)

## Refer to the package vignette for more examples.
}
}
