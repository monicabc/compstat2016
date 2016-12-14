
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


library(shinydashboard)
library(DT)
library(markdown)
source("Tarea1/T1_server.R")
source("Tarea1/T1_ui.R")
source("Tarea2/T2_server.R")
source("Tarea2/T2_ui.R")
source("Tarea3/T3_server.R")
source("Tarea3/T3_ui.R")

ui <- dashboardPage(
  
  dashboardHeader(titleWidth = 250, title = "ITAM",
                  dropdownMenu(type="messages",
                               messageItem(
                                 from="ME",
                                 message = "Entrega Martes 13/12/16"),
                               messageItem(
                                 from="Question",
                                 message = "mkba85_@gmail.com",
                                 icon=icon("question"))
                               ),
                  dropdownMenu(type="task",badgeStatus = "success",
                               taskItem(value=100, color="green", "Tarea1"),
                               taskItem(value=100, color="green", "Tarea2"),
                               taskItem(value=100, color="green", "Tarea3")

                  )
                  ),
  
  dashboardSidebar(
    
    width = 250,
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Tareas", tabName = "dashboard", icon = icon("line-chart"),
               menuSubItem("Tarea 1 Función inversa",icon = icon("folder-open"), tabName = "subMenu1"),
               menuSubItem("Tarea 2 Integración Numérica",icon = icon("folder-open"), tabName = "subMenu2"),
               menuSubItem("Tarea 4,5 y 6 Regresión",icon = icon("folder-open"), tabName = "subMenu3")
      )
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = 'home',
              h2('Estadística Computacional'),
              h3("Otoño 2016"),
              h4("Maestría en Ciencias de Datos"),
              h4("Mónica Patricia Ballesteros Chávez | 124960"),
              h4("Profesor: Mauricio García Tec"),
              fluidRow(
                valueBox(paste(100, "%"), "Progress", icon=icon("list"))
              )
      ),
      tabItem(tabName = 'subMenu1',
              h2('Simulación de variables aleatorias - Método de la Función Inversa'),
              T1_ui("T1_server")
      ),
      tabItem(tabName = 'subMenu2',
              h2('Integración Numérica usando Montecarlo y Trapecio'),
              T2_ui("T2_server")
      ),
      tabItem(tabName = 'subMenu3',
              h2('Regresion Bayesiana'),
              h3('Ballesteros Mónica / Cerón Fabiola'),
              T3_ui("T3_server")
      )
    )
  )
)

      