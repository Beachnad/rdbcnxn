# RDBCNXN

## Description

Just a simple R package for generating database connections in a secure way. Replaces hard-coded database connection strings with a series of environment variables.

## Installation

```
devtools::install_github(
  repo = 'DannyProCare/rdbcnxn'
)
```

## How to use

First, define environment variables ...

```
NAME_OF_DATABASE_USER=username
NAME_OF_DATABASE_PASS=password
NAME_OF_DATABASE_HOST=localhost
NAME_OF_DATABASE_PORT=1234
```

Then, call one of the database connector functions.

```
conn <- get_postgres_conn('name_of_database')
```

Be productive!