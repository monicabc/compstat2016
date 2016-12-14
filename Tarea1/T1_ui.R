# TAREA 1:ui

T1_ui <- function(id) {
  ns <- NS(id)
  tagList(
    
    box(title="Objetivo",status = "primary",
        htmlOutput(ns("text0"))
        ),
    box(title="Selección de Parámetros", status = "warning", 
    sliderInput(ns("slider"), "Numero de simulaciones:", 100, 1000, 300),
    sliderInput(ns("slider2"), "Lambda:", 0, 1, 0.5),
    sliderInput(ns("bins"), "Bins:", 0, 50, 10)
    ),
    box(title="Datos", DT::dataTableOutput(ns("wideTable")), downloadButton(ns("downloadData"))),
    box(title="Histograma", background = "blue", solidHeader = TRUE,collapsible = TRUE,
        plotOutput(ns("plot1"), height = 250)),
    box(title="Bondad de ajuste", h2("Prueba Kolmogorov Smirnov"), background = "blue", solidHeader = TRUE,collapsible = TRUE,
        htmlOutput(ns("text")))
    
   
  )
}
