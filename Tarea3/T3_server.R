require(MASS)
library(Rcpp)

T3_server<- function(input, output, session) {
  set.seed(20160817)
  salarios<-read.table("salarios.txt",header=TRUE)
  salariosesc<-scale(salarios)
  vec <- rep(1,24) #B0
  
  data <- matrix(cbind(vec,salariosesc[,2],salariosesc[,3],salariosesc[,4],salariosesc[,1]),ncol=5)
  #Priors
  prior.mean1 <- function(x) dnorm(x, 0, 0.1)
  prior.mean2 <- function(x) dnorm(x, 0, 0.1)
  prior.mean3 <- function(x) dnorm(x, 0, 0.1)
  prior.mean4 <- function(x) dnorm(x, 0, 0.1)
  prior.sd <- function(x) dgamma(x, 0.01, 0.01)
  
  cppFunction('
              double objdens(NumericMatrix data, NumericVector theta){
              double lkh, logprior, mu;
              int m=data.nrow();
              NumericVector Y(m);
              NumericMatrix X(m,theta.size());
              Y = data(_,4); // In this example is redundant but helps to generalise
              X = data;
              
              // Verosimilitud
              
              lkh=0.0;
              for (int i=0; i<24; i++){
              mu=0.0;
              for (int j=0; j<4; j++){
              mu += theta[j]*X(i,j);
              }
              lkh += -.5*pow((Y[i]-mu)/theta[4],2)-log(theta[4]);
              }
              
              // Log Prior
              logprior = R::dnorm(theta[0], 0.0,0.1, true) + R::dnorm(theta[1], 0.0,0.1, true) + R::dnorm(theta[2], 0.0,0.1, true) 
              + R::dnorm(theta[3], 0.0,0.1, true)+ R::dgamma(theta[4],0.01, 0.01, true);
              return lkh + logprior;
              }')

  objdens(data,c(2,2,2,2,3))
  
  
  # Caminata aleatoria
  cppFunction('
              NumericVector proposal(NumericVector theta){
              int nparam = theta.size();
              double jump = .15; 
              NumericVector newtheta(nparam);
              for (int i=0; i<nparam; i++){
              newtheta[i] = R::rnorm(theta[i], jump);
              }
              return newtheta;
              }')
proposal(c(2,2,2,2,3))


 #MH
Rcpp::sourceCpp("Regresion.cpp")

nsim <- 1000
init <- c(0,0,0,0,1)
mh.samp <- Regresion(nsim, init, objdens, proposal, data)
estims <- mh.samp$theta


# Calentamiento y Adelgazamiento
burnin <- 100
estim <- estims[-(1:burnin), ]
thinning <- .9

sub <- sample.int(nsim-burnin, size=round(thinning*nsim))
estims <- estims[sub, ]

  
  output$wideTable <- DT::renderDataTable({ DT:: datatable({salarios}, options = list(pageLength=5))
  })
  
  output$text <- renderText({
    paste("Se busca encontrar la relación entre el salario anual de investigadores de una universidad
      (Y, en miles de dólares) y el índice de calidad de trabajo (X1), número de 
      años de experiencia (X2) y el índice de éxito en publicaciones (X3). La muestra consiste de 24 investigadores.",'<br/>','<br/>',"

    
      En las gráficas de dispersión se observan que las variables explicativas presentan una relación lineal
      con la variable de respuesta.",'<br/>','<br/>',"

      Se define el siguiente modelo de regresión lineal normal, 
      para explicar la relación de las variables explicativas con el salario:",'<br/>','<br/>',"
      Y=B0+B1x1+B2x2+B3x3+ e",'<br/>','<br/>',"

      Distribuciones iniciales:",'<br/>',"
        B0 ∼ N(0, 0.1)",'<br/>',"
        B1 ∼ N(0, 0.1)",'<br/>',"
        B2 ∼ N(0, 0.1)",'<br/>',"
        B3 ∼ N(0, 0.1)",'<br/>',"
        Sigma ∼ Ga(0.01, 0.01)")

      
  
  })
  
  output$plot1 <- renderPlot(
    plot(salariosesc[,1],salariosesc[,2])
  
  )
  output$plot2 <- renderPlot(
   
    plot(salariosesc[,1],salariosesc[,3])
  )
  output$plot3 <- renderPlot(
    
    plot(salariosesc[,1],salariosesc[,4])
  )
  

   output$plotf1 <- renderPlot(
     hist(estims[ ,1], prob=TRUE, breaks=20,main = " ",xlab="B0",ylab="Densidad")
   )
   
  output$plotf2 <- renderPlot(
     hist(estims[ ,2], prob=TRUE, breaks=20, main = " ",xlab="B1",ylab="Densidad")
   )
   output$plotf3 <- renderPlot(
     hist(estims[ ,3], prob=TRUE, breaks=20,main = " ",xlab="B2",ylab="Densidad")
   )
   output$plotf4 <- renderPlot(
     hist(estims[ ,4], prob=TRUE, breaks=20,main = " ",xlab="B3",ylab="Densidad")
   )
   output$plotf5 <- renderPlot(
      hist(estims[ ,5], prob=TRUE, breaks=40,main = " ",xlab="Sigma",ylab="Densidad") 
   )
  
   output$ploti1 <- renderPlot(
     plot(prior.mean1, lwd="2", xlim=c(-50,50),xlab="B0",ylab="Densidad")
   )
   output$ploti2 <- renderPlot(
      plot(prior.mean2, lwd="2",xlim=c(-50,50),xlab="B1",ylab="Densidad")
   )
   output$ploti3 <- renderPlot(
      plot(prior.mean3, lwd="2",xlim=c(-50,50),xlab="B2",ylab="Densidad")
   )
   output$ploti4 <- renderPlot(
     plot(prior.mean4, lwd="2",xlim=c(-50,50),xlab="B3",ylab="Densidad")
   )
   output$ploti5 <- renderPlot(
      plot(prior.sd, lwd="2",xlim=c(0,50),xlab="Sigma",ylab="Densidad")
   )

   
}