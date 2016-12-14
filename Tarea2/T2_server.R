require(plyr)
library(dplyr)
require(ggplot2)

T2_server <- function(input, output, session) {
  
  fun1 <- reactive({
    texto <- paste("aux <- ", input$expresion)
    eval(parse(text = texto))
    aux
  })
  
  
  mc.intervals <- function(Phi, N, X.dens = runif, alpha) {
    # FUN, funcion a partir de la cual se obtendra E(phi(X))
    # X.dens funcion de la cual se obtendra X. Debera ser una funcion del tamaño deseado de la muestra
    # N es un vector con muestras de distinto tamaño para realizar el calculo estimado de la integral
    # alpha, valor que determina los intervalos de confianza de nivel 1-alpha
    
    results.list <- lapply(N, function(nsim) {
      # MonteCarlo
      # N muestras con la densidad de X
      X <- sapply(FUN = X.dens, nsim)
      K <- input$superior - input$inferior
      # Evaluacion de phi en X_i
      PhiX <- sapply(X, Phi)
      # Estimacion de int_a^b \phi(x)f(x)df = E[phi(X_i)]
      estim <- mean(PhiX)
      estim2<-(K)/2*mean(PhiX[-N]+PhiX[-1])
      # Calculo de la varianza para phi(X_i)
      S2 <- var(PhiX)
      # Cuantil derecho para alpha/2
      quant <- qnorm(alpha / 2, lower.tail = FALSE)
      # Intervalo de confianza superior
      int.upper <- estim + sqrt(S2 / nsim) * quant
      # Intervalo de confianza inferior
      int.lower <- estim - sqrt(S2 / nsim) * quant
      return(data.frame(Simulacion = nsim, Est_MonteCarlo = K * estim, LI = K * int.lower, UI = K * int.upper,Est_Trapecio= estim2))
    })
    results.table <- ldply(results.list)
    #Se muestra la tabla anterior en la UI respectiva
    output$table <- renderTable({
      results.table
    })
    return(results.table)
  }
  
  
  #Grafico con la aproximaciones de la integral
  output$grafica <- renderPlot({
    X.dens <- function(nsim) runif(nsim, input$inferior,input$superior)
    N <- c(10,100,1000,10000,100000)
    
    datos <- mc.intervals(Phi=fun1(), N=N, X.dens=X.dens, alpha=input$alpha)
    #Valor aproximado de la integral
    aprox <- integrate(fun1(), lower = input$inferior, upper = input$superior)
    
    ggplot(datos, aes(x=log(Simulacion,10))) + geom_ribbon(aes(ymin=LI, ymax=UI), 
    fill="grey", alpha=0.4) + geom_line(aes(y=Est_MonteCarlo), colour="blue") + geom_hline(aes(yintercept=aprox$value),colour="red", linetype="dotted", size=1) + geom_line(aes(y=Est_Trapecio), colour="green") #+ stat_function(fun = fun1())
    
  })
  
  output$texta <- renderText({
    paste("El objetivo es Utilizar MonteCarlo como técnica de Integración y compararlo con el método del trapecio",
          '<br/>', "El método de Montecarlo se utiliza para calcular numéricamente expresiones matemáticas
complejas y difíciles de evaluar con exactitud,  bien que no se pueden resolver analíticamente",'<br/>',"Se define la función a integrar, los límites y el intervalo de confianza.",'<br/>','<br/>','<br/>','<br/>','<br/>','<br/>','<br/>','<br/>','<br/>')
    
    
    
  })
  
}