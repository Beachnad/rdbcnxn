#' Installs the Latest Version of this Package
#' 
#' @export
install_latest <- function(){
  require(devtools)
  
  auth_user = readline(prompt="Username: ")
  password = readline(prompt ="Password: ")
  tryCatch(devtools::install_bitbucket(repo='DannyProCare/rprocare',
                                       auth_user = auth_user,
                                       password = password),
  error=warning(paste("Failed to establish a secure connection to Bitbucket",
                "servers. Please check username, password, and network",
                "connections and try again.", sep='\n  ')))
  
}
