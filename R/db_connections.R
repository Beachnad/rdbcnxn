get_var <- function(var){
  function(x){Sys.getenv(paste0(x, '_', toupper(var)))}
}

get_host <- get_var('HOST')
get_user <- get_var('USER')
get_pass <- get_var('PASS')
get_port <- get_var('PORT')

conn_function <- function(driver){
  function(database, ...){
    default_args = list(
      database = database,
      uid = get_user(database),
      pwd = get_pass(database),
      server = get_host(database),
      port = get_port(database)
    )
    
    given_args = list(...)
    
    args <- c(default_args[!(names(default_args) %in% names(given_args))],  given_args)
    args$driver = driver
    do.call(DBI::dbConnect, args)
  }
}

#' @export
get_sql_server_conn <- function(database, ...){
  default_args = list(
    driver = "ODBC Driver 17 for SQL Server",
    user = get_user(database),
    password = get_pass(database),
    host = get_host(database),
    port = get_port(database)
  )
  
  given_args = list(...)
  
  args <- c(default_args[!(names(default_args) %in% names(given_args))],  given_args)
  
  args$uid <- args$user
  args$pwd = args$password
  args$server <- args$host
  
  args$user <- NULL
  args$password <- NULL
  args$host <- NULL
  
  args$drv = odbc::odbc()
  
  do.call(DBI::dbConnect, args)
}

#' @export
get_mysql_conn <- function(database, ...){
  default_args = list(
    user = get_user(database),
    password = get_pass(database),
    host = get_host(database),
    port = get_port(database)
  )
  
  given_args = list(...)
  
  args <- c(default_args[!(names(default_args) %in% names(given_args))],  given_args)
  
  args$drv = RMySQL::MySQL()
  args$port <- as.integer(args$port)
  
  do.call(DBI::dbConnect, args)
}


#' @export
get_postgres_conn <- function(database, ...){
  default_args = list(
    user = get_user(database),
    password = get_pass(database),
    host = get_host(database),
    port = get_port(database)
  )
  
  given_args = list(...)
  
  args <- c(default_args[!(names(default_args) %in% names(given_args))],  given_args)
  
  args$drv = RPostgreSQL::PostgreSQL()
  do.call(DBI::dbConnect, args)
}
