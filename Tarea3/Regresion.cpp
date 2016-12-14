#include <Rcpp.h>

using namespace Rcpp;


// [[Rcpp::export]]
List Regresion(int nsim, NumericVector theta0, Function objdens, Function proposal, NumericMatrix data){
  int nparam=theta0.size();
  NumericMatrix theta(nsim, nparam);  
  theta(0,_) = theta0;
  
  // Tasas de aceptación
  NumericVector X(nparam);
  NumericVector rejections(nsim);
  double logU;
  // Indicador de aceptación
  bool accept=false;
  int trials;
  int maxtrials=100000;
  
  for (int i=1; i<nsim; i++){
    // ciclo
    trials = 0;
    accept = false;
    while (!accept && trials<maxtrials){
      X = as<NumericVector>(proposal(theta(i-1,_)));
      logU = log(R::runif(0,1));

      if(logU <= as<double>(objdens(data, X))-as<double>(objdens(data, theta(i-1,_)))) { 
        accept = true;
        theta(i,_) = X;
      } 
      trials++;
    }  
    rejections[i] = trials;
  }
  return List::create(Named("theta")  = theta, Named("rejections")  = rejections);
}

