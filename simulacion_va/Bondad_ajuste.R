 # Bondad de ajuste para exponencial 
library(MASS)
library(stats)
Finv<-function(u,lambda){ return (-log(1-u)/lambda)}
set.seed(20160817)
nsim<-1000
lambda<-.9
z<-runif(1000)

x<-Finv(z,lambda)
ajuste <- fitdistr(x,"exponential")
#verificamos la lamda
ajuste
#Prueba Kolmogorov
Ks<- ks.test(x, "pexp", rate =ajuste$estimate[1])
Ks