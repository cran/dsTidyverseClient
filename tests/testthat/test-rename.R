require(DSLite)
require(DSI)
require(dplyr)
require(dsTidyverse)
require(dsBaseClient)

data("mtcars")
login_data <- .prepare_dslite(assign_method = "bindRowsDS", tables = list(mtcars = mtcars))
conns <- datashield.login(logins = login_data)
datashield.assign.table(conns, "mtcars", "mtcars")

test_that("ds.rename fails with correct error message if data not present ", {
  skip_if_not_installed("dsBaseClient")
  expect_error(
    ds.rename(
      df.name = "datanotthere",
      tidy_expr = list(test_1 = mpg, test_2 = drat),
      newobj = "nodata",
      datasources = conns
    )
  )
})

test_that("ds.rename correctly passes =", {
  skip_if_not_installed("dsBaseClient")
  ds.rename(
    df.name = "mtcars",
    tidy_expr = list(test_1 = mpg, test_2 = drat),
    newobj = "mpg_drat",
    datasources = conns
  )

  expect_equal(
    ds.colnames("mpg_drat", datasources = conns)[[1]],
    c("test_1", "cyl", "disp", "hp", "test_2", "wt", "qsec", "vs", "am", "gear", "carb")
  )
})

test_that("ds.rename throws an error if column name doesn't exist", {
  skip_if_not_installed("dsBaseClient")
  expect_error(
    ds.rename(
      df.name = "mtcars",
      tidy_expr = list(test_1 = doesntexist, test_2 = drat),
      newobj = "mpg_drat",
      datasources = conns
    )
  )
})
