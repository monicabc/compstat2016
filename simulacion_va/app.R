## app.R ##
library(shiny)
library(shinydashboard)
library(stats)
ui <- dashboardPage(
  dashboardHeader(title = "Simulación"),skin = "purple",
  
  dashboardSidebar(sidebarMenu(
    menuItem("Simulación Función Inversa", tabName = "dashboard", icon = icon("dashboard"))
  )),
  
  dashboardBody(
    fluidRow(
      box(background = "light-blue", "Generación de v.a con distribución Exponencial con función inversa")
    ),
    fluidRow(  
      box(
        title = "Selección de Parámetros:", status = "warning", solidHeader = TRUE,collapsible = TRUE,
        sliderInput("slider", "Número de simulaciones:", 100, 1000, 500),
        sliderInput("slider2", "Lambda:", 0, 1, 0.5)),
      box(title="Histograma", background = "maroon", solidHeader = TRUE,collapsible = TRUE,
          plotOutput("plot1", height = 250))
      ),
    
    
    fluidRow(
      box(background = "light-blue", "Generación de v.a con distribucion Weibull con función inversa")
    ),
      fluidRow(  
        box(
          title = "Selección de Parámetros:", status = "warning", solidHeader = TRUE,collapsible = TRUE,
          sliderInput("slider3", "Número de simulaciones:", 100, 1000, 500),
          sliderInput("slider4", "Alpha (escala):", 0, 1, 0.5),
          sliderInput("slider5", "Beta (forma):", 0, 5, 1)),
        box(title="Histograma", background = "maroon", solidHeader = TRUE,collapsible = TRUE,
            plotOutput("plot2", height = 250))
      )
    )
  )


server <- function(input, output) {
  'Funci?n inversa'
  Finv<-function(u,lambda){ return (-log(1-u)/lambda)}
  Finv2<-function(uu,alpha,beta){ return (beta *(-log(1-uu))^(1/alpha))}
  
  output$plot1 <- renderPlot({
    set.seed(20160817)
    u<-runif(seq_len(input$slider))
    x<-Finv(u,input$slider2)
    data <- x[seq_len(input$slider)]
    hist(data)
  })
  output$plot2 <- renderPlot({
    uu<-runif(seq_len(input$slider3))
    t<-Finv2(u,input$slider4,input$slider5)
    data2 <- t[seq_len(input$slider3)]
    hist(data2)
    #curve(dexp(u,input$slider3),add=TRUE)
  })
}

shinyApp(ui, server)
