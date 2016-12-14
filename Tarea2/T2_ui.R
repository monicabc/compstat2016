# Tarea2 UI function
T2_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(title="Objetivo", status = "primary",
        htmlOutput(ns("texta"))
    ),
    box(title="Selección de Parámetros", status = "warning",
    textInput(
      inputId=ns("expresion"), 
      label="Funcion f",
      value="function(x) x^2"
    ),
    numericInput(
      inputId = ns("superior"),
      label = "Limite superior",
      value = "2"
    ),
    numericInput(
      inputId = ns("inferior"),
      label = "Limite inferior",
      value = "0"
    ),
    numericInput(
      inputId = ns("alpha"),
      label = "Nivel de Confianza (Intervalos)",
      value = "0.05"
    )
    ), 
    box( title="Resultados", tableOutput(ns("table"))),
    
    box(title="Gráfica", background = "blue", solidHeader = TRUE,collapsible = TRUE,
    plotOutput(ns("grafica")),
    p(textOutput(ns("space"))),
    p("Azul: Integral MonteCarlo"),
    p("Verde: Integral Trapecio"))
    
    
  )
  
  
}
