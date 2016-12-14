library(shinydashboard)

server <- function(input, output,session) {
  callModule(T1_server, "T1_server")
  callModule(T2_server, "T2_server")
  callModule(T3_server, "T3_server")
  
  
}

