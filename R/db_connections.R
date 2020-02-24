get_var <- function(var){
  function(x){Sys.getenv(paste0(x, '_', toupper(var)))}
}

get_host <- get_var('HOST')
get_user <- get_var('USER')
get_pass <- get_var('PASS')
get_port <- get_var('PORT')

#' Returns a connection object for lime survey
#' @export
get_lime_survey_conn <- function(...){
  db <- "LIME_SURVEY"
  DBI::dbConnect(
    RMySQL::MySQL(),
    user = get_user(db),
    password = get_pass(db),
    dbname = 'limesurvey_reporting',
    host= get_host(db),
    ...
  )
}

get_sql_server_conn <- function(database){
  function(driver = "ODBC Driver 17 for SQL Server"){
    conn <- DBI::dbConnect(odbc::odbc(),
                           driver = "ODBC Driver 17 for SQL Server",
                           database = database,
                           uid = get_user(database),
                           pwd = get_pass(database),
                           server = get_host(database),
                           port = get_port(database))
    return(conn)
  }
}

#' Returns a connection object for mpc centricity
#' @export
get_mpc_conn <- get_sql_server_conn('MPC')

#' Returns a connection object for smpc centricity
#' @export
get_smpc_conn <- get_sql_server_conn('SMPC')

#' Returns a connection object for the data mart on the shiny server
#' @export
get_data_mart_conn <- function(){
  conn <- RPostgreSQL::dbConnect(DBI::dbDriver("PostgreSQL"),
                                 dbname =   'data_mart',
                                 user =     get_user('DATA_MART'),
                                 password = get_pass('DATA_MART'),
                                 host =     get_host('DATA_MART'),
                                 port =     get_port('DATA_MART'))
  return(conn)
}
