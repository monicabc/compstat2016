require(MASS)


T1_server<- function(input, output, session) {
  
  set.seed(20160817)
  Finv1<-function(u,lambda){ return (-log(1-u)/lambda)}
  
  output$plot1 <- renderPlot({
    u<-runif(seq_len(input$slider))
    x<-Finv1(u,input$slider2)
    data <- x[seq_len(input$slider)]
    bins <- seq(min(data), max(data), length.out = input$bins + 1)
    hist(data,  breaks = bins, main="")
    s<-density(rexp(input$slider,rate=input$slider2))

  })
  
  output$wideTable <- DT::renderDataTable({
    u<-runif(seq_len(input$slider))
    x<-Finv1(u,input$slider2)
    data <- x[seq_len(input$slider)]
    table <- as.data.frame(data)
    colnames(table) <- c("Transformacion")
    
   # DT::datatable(table,extensions = 'Buttons', 
    #              options = list(dom = 'Bfrtip', 
    #                             buttons = c('copy', 'csv', 'excel')))
    DT:: datatable({table})
    
  })
  output$downloadData<-downloadHandler(
    filename = function(){ "datos.csv"},
      content=function(file) {
        write.csv(table,file)
      }
  )
  
    output$text <- renderText({
      u<-runif(seq_len(input$slider))
      x<-Finv1(u,input$slider2)
      data <- x[seq_len(input$slider)]
      ajuste <- fitdistr(data,"exponential")
      Ks<- ks.test(x, "pexp", rate =ajuste$estimate[1])
      paste("Hipótesis nula Ho: La muestra se distribuye exponencial","<br/>",
      "P- value = ", round(Ks$p.value,3), "Lamda=",round(ajuste$estimate[1],3),'<br/>',"Como p-value es mayor a 0.1, no se rechaza la hipótesis Nula, Por lo tanto la muestra se distribuye exponencial.","<br/>")
      
      
  })
  
    output$text0 <- renderText({
      paste("El objetivo es simular la distribución de una variable aleatoria X, a partir de la distribución uniforme
            utilizando el método de la función inversa.",'<br/>',
"Dado U∼Unif (0,1), encontrar una función h(U) tal que h(U)∼X",'<br/>','<br/>',"Se presenta el método de la Función Inversa para generar distribuciones Exponenciales.",'<br/>','<br/>','<br/>','<br/>','<br/>','<br/>','<br/>','<br/>','<br/>')
      
      
      
    })
    
    
    
    
  
}