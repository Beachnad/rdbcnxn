library(testthat)
library(DBI)
library(dplyr)

# setwd('../../')
# source('./R/db_connections.R')

# HELPER ======================================================================
test_db_conn <- function(conn, sql){
  df <- DBI::dbGetQuery(conn, sql)
  
  expect_true(is.data.frame(df))
  expect_gt(nrow(df), 100)
}

# TESTS =======================================================================
test_that("MPC Connection Establishes", {
  get_mpc_conn() %>%
    test_db_conn('SELECT patientid FROM PatientProfile')
})

test_that("SMPC Connection Establishes", {
  get_smpc_conn() %>%
    test_db_conn('SELECT patientid FROM PatientProfile')
})

test_that("Lime Survey Connection Establishes", {
  get_lime_survey_conn() %>%
    test_db_conn('SELECT id FROM lime_survey_99946;')
})

test_that("Data Mart Connection Establishes", {
  get_data_mart_conn() %>%
    test_db_conn('SELECT * FROM visits')
})