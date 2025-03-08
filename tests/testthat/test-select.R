require(DSLite)
require(DSI)
require(dplyr)
require(dsTidyverse)
require(dsBaseClient)

data("mtcars")
login_data <- .prepare_dslite(assign_method = "selectDS", tables = list(mtcars = mtcars))
conns <- datashield.login(logins = login_data)
datashield.assign.table(conns, "mtcars", "mtcars")

test_that("ds.select fails with correct error message if data not present ", {
  skip_if_not_installed("dsBaseClient")
  expect_error(
    ds.select(
      df.name = "datanotthere",
      tidy_expr = list(mpg:drat),
      newobj = "nodata",
      datasources = conns
    )
  )
})

test_that("ds.select correctly passes : ", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(mpg:drat),
    newobj = "mpg_drat",
    datasources = conns
  )

  expect_equal(
    ds.colnames("mpg_drat", datasources = conns)[[1]],
    c("mpg", "cyl", "disp", "hp", "drat")
  )
})

test_that("ds.select correctly passes `starts_with`", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(starts_with("m")),
    newobj = "starts",
    datasources = conns
  )

  expect_equal(
    ds.colnames("starts", datasources = conns)[[1]],
    "mpg"
  )
})

test_that("ds.select correctly passes `ends_with`", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(ends_with("m")),
    newobj = "ends",
    datasources = conns
  )

  expect_equal(
    ds.colnames("ends", datasources = conns)[[1]],
    "am"
  )
})

test_that("ds.select correctly passes `matches`", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(matches("a")),
    newobj = "matches",
    datasources = conns
  )

  expect_equal(
    ds.colnames("matches", datasources = conns)[[1]],
    c("drat", "am", "gear", "carb")
  )
})

test_that("ds.select correctly passes `everything`", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(everything()),
    newobj = "everything",
    datasources = conns
  )

  expect_equal(
    ds.colnames("everything", datasources = conns)[[1]],
    colnames(mtcars)
  )
})

test_that("ds.select correctly passes `last_col`", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(last_col()),
    newobj = "last",
    datasources = conns
  )

  expect_equal(
    ds.colnames("last", datasources = conns)[[1]],
    "carb"
  )
})

test_that("ds.select correctly passes `group_cols`", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(group_cols()),
    newobj = "group",
    datasources = conns
  )

  expect_equal(
    ds.colnames("group", datasources = conns)[[1]],
    character(0)
  )
})

test_that("ds.select correctly passes strings with '&'", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(starts_with("c") & ends_with("b")),
    newobj = "and",
    datasources = conns
  )

  expect_equal(
    ds.colnames("and", datasources = conns)[[1]],
    "carb"
  )
})

test_that("ds.select correctly passes strings with '!'", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(!mpg),
    newobj = "not",
    datasources = conns
  )

  expect_equal(
    ds.colnames("not", datasources = conns)[[1]],
    c("cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb")
  )
})

test_that("ds.select correctly passes strings with '|'", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(starts_with("c") | ends_with("b")),
    newobj = "or",
    datasources = conns
  )

  expect_equal(
    ds.colnames("or", datasources = conns)[[1]],
    c("cyl", "carb")
  )
})

test_that("ds.select correctly passes `strings with `all_of`", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(all_of(c("mpg", "cyl"))),
    newobj = "all_of",
    datasources = conns
  )

  expect_equal(
    ds.colnames("all_of", datasources = conns)[[1]],
    c("mpg", "cyl")
  )
})

test_that("ds.select correctly passes strings with `any_of`", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(any_of(c("mpg", "cyl"))),
    newobj = "any_of",
    datasources = conns
  )

  expect_equal(
    ds.colnames("any_of", datasources = conns)[[1]],
    c("mpg", "cyl")
  )
})

test_that("ds.select correctly passes complex strings", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list((starts_with("c") & ends_with("b")) | contains("ra") | gear:carb),
    newobj = "complex",
    datasources = conns
  )

  expect_equal(
    ds.colnames("complex", datasources = conns)[[1]],
    c("carb", "drat", "gear")
  )
})

test_that("ds.select correctly passes strings with `where`", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(where(is.numeric)),
    newobj = "where",
    datasources = conns
  )

  expect_equal(
    ds.colnames("where", datasources = conns)[[1]],
    colnames(mtcars)
  )
})

test_that("ds.select correctly passes strings with '='", {
  skip_if_not_installed("dsBaseClient")
  ds.select(
    df.name = "mtcars",
    tidy_expr = list(test = mpg, cyl, gear),
    newobj = "equals",
    datasources = conns
  )

  expect_equal(
    ds.colnames("equals", datasources = conns)[[1]],
    c("test", "cyl", "gear")
  )
})
