# TAREA 1:ui

T3_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(title="Especificación del Modelo", 
        tabsetPanel(
          tabPanel("Modelo",htmlOutput(ns("text"))), 
          tabPanel("Datos",DT::dataTableOutput(ns("wideTable")))
        )),
    
    box(title="Gráficas de Dispersión",
    tabsetPanel(
      tabPanel('x1', plotOutput(ns('plot1'))),
      tabPanel('x2', plotOutput(ns('plot2'))),
      tabPanel('x3', plotOutput(ns('plot3')))
      
    )),
    box(title="Gráficas de Distribución Inicial",
        tabsetPanel(
          tabPanel('B0', plotOutput(ns('ploti1'))),
          tabPanel('B1', plotOutput(ns('ploti2'))),
          tabPanel('B2', plotOutput(ns('ploti3'))),
          tabPanel('B3', plotOutput(ns('ploti4'))),
          tabPanel('Sigma', plotOutput(ns('ploti5')))
          
        )),
    box(title="Gráficas de Distribución Final",
        tabsetPanel(
          tabPanel('B0', plotOutput(ns('plotf1'))),
          tabPanel('B1', plotOutput(ns('plotf2'))),
          tabPanel('B2', plotOutput(ns('plotf3'))),
          tabPanel('B3', plotOutput(ns('plotf4'))),
          tabPanel('Sigma', plotOutput(ns('plotf5')))
          
        ))
   
  )
}
