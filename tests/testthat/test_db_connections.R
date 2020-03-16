library(testthat)
library(DBI)
library(dplyr)

testthat::setup({
  PG_TEST_PASS <<- 'postgres'
  PG_TEST_HOST <<- 'localhost'
  PG_TEST_USER <<- 'postgres'
  PG_TEST_PORT <<- '5432'
  
  MSSQL_TEST_PASS <<- 'sql_server2018'
  MSSQL_TEST_HOST <<- 'localhost'
  MSSQL_TEST_USER <<- 'sa'
  MSSQL_TEST_PORT <<- '1433'
  
  MYSQL_TEST_PASS <<- 'mysql_2018'
  MYSQL_TEST_HOST <<- 'localhost'
  MYSQL_TEST_USER <<- 'root'
  MYSQL_TEST_PORT <<- '3306'
  
  Sys.setenv(
    PG_TEST_PASS=PG_TEST_PASS,
    PG_TEST_HOST=PG_TEST_HOST,
    PG_TEST_USER=PG_TEST_USER,
    PG_TEST_PORT=PG_TEST_PORT,
    
    MSSQL_TEST_PASS=MSSQL_TEST_PASS,
    MSSQL_TEST_HOST=MSSQL_TEST_HOST,
    MSSQL_TEST_USER=MSSQL_TEST_USER,
    MSSQL_TEST_PORT=MSSQL_TEST_PORT,
    
    MYSQL_TEST_PASS=MYSQL_TEST_PASS,
    MYSQL_TEST_HOST=MYSQL_TEST_HOST,
    MYSQL_TEST_USER=MYSQL_TEST_USER,
    MYSQL_TEST_PORT=MYSQL_TEST_PORT
  )
  
  c(RMySQL::MySQL(), RPostgreSQL::PostgreSQL()) %>%
    sapply(function(x)dbListConnections(x) %>%
             sapply(function(con)dbDisconnect(con)))
    
  system(paste0("docker run --name db1 --rm -e ACCEPT_EULA=Y -e SA_PASSWORD=", MSSQL_TEST_PASS," -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-CU8-ubuntu"))
  system(paste0("docker run --name db2 --rm -e POSTGRES_PASSWORD=", PG_TEST_PASS ," -p 5432:5432 -d postgres:12"))
  system(paste0("docker run --name db3 --rm -e MYSQL_ROOT_PASSWORD=", MYSQL_TEST_PASS, " -e MYSQL_DATABASE=test -p 3306:3306 -d mysql:5.7"))
  
  print(system("docker ps"))

  # Sleep to give time for containers to starts accepting connections
  Sys.sleep(20)
})

teardown({
  system("docker kill db1 db2 db3")
})

testthat::test_that("Connection to Postgres is possible", {
  conn <- rdbcnxn::get_postgres_conn("pg_test")
  testthat::expect_equal(DBI::dbGetQuery(conn, "SELECT 1")[1, 1], 1)
  
  conn <- rdbcnxn::get_postgres_conn("wrong_key", password = PG_TEST_PASS, host = PG_TEST_HOST, user = PG_TEST_USER, port = PG_TEST_PORT)
  testthat::expect_equal(DBI::dbGetQuery(conn, "SELECT 1")[1, 1], 1)
})

testthat::test_that("Connection to SQL Server is possible", {
  conn <- rdbcnxn::get_sql_server_conn("mssql_test")
  testthat::expect_equal(DBI::dbGetQuery(conn, "SELECT 1")[1, 1], 1)
  
  conn <- rdbcnxn::get_sql_server_conn("wrong_key", password = MSSQL_TEST_PASS, host = MSSQL_TEST_HOST, user = MSSQL_TEST_USER, port = MSSQL_TEST_PORT)
  testthat::expect_equal(DBI::dbGetQuery(conn, "SELECT 1")[1, 1], 1)
})

testthat::test_that("Connection to MySQL Server is possible", {
  conn <- rdbcnxn::get_mysql_conn("mysql_test")
  testthat::expect_equal(DBI::dbGetQuery(conn, "SELECT 1")[1, 1], 1)
  
  conn <- rdbcnxn::get_mysql_conn("wrong_key", password = MYSQL_TEST_PASS, host = MYSQL_TEST_HOST, user = MYSQL_TEST_USER, port = MYSQL_TEST_PORT)
  testthat::expect_equal(DBI::dbGetQuery(conn, "SELECT 1")[1, 1], 1)
})