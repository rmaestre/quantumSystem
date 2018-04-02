#include <RcppArmadillo.h>
#include <RcppArmadilloExtensions/sample.h>

using namespace Rcpp;

//[[Rcpp::export]]
S4 init_system(int nQubits) {
  // Creating an object of QuantumSystem class
  S4 x("QuantumSystem");
  // Set amplitude
  float amplitude = 1.0 / std::pow(std::pow(2,nQubits), 0.5);
  // Setting values to the slots
  // Configure and set amplitudes
  arma::vec qbitVector = arma::ones(std::pow(2, nQubits)) * amplitude;
  x.slot("qbitVector") = qbitVector;
  // Configure and set Hadamard gate
  arma::mat H = arma::ones(2, 2);
  H.submat(1,1,1,1) = -1;
  H = H * (1 / std::sqrt(2));
  arma::mat Htimes = arma::ones(2, 2);
  Htimes.submat(1,1,1,1) = -1;
  Htimes = Htimes * (1 / std::sqrt(2));
  //Kronecker tensor product
  for(int i=0; i<nQubits-1; i++) {
    Htimes = arma::kron(Htimes, H);
  }
  x.slot("hadamardGate") = Htimes;
  return(x);
}

//[[Rcpp::export]]
NumericVector seq_int(int first, int last){
  NumericVector y(abs(last - first) + 1);
  std::iota(y.begin(), y.end(), first);
  return y;
}

//[[Rcpp::export]]
int meassurement(S4 quantumSystem) {
  NumericVector x = quantumSystem.slot("qbitVector");
  NumericVector xPow(x.length());
  // Define iterators
  NumericVector::iterator it, out_it;
  for(it = x.begin(), out_it=xPow.begin();it<x.end();++it,++out_it) {
    *out_it = *it * *it;
  }
  // Select state based on probabilities
  int index = *RcppArmadillo::sample(seq_int(0, x.length()-1), 1, false, xPow).begin();
  // Collapse state
  int count = 0;
  for(it = x.begin();it<x.end();++it,++count) {
    if (count != index){
      *it = 0;
    } else {
      *it = 1;
    }
  }
  quantumSystem.attr("qbitVector") = x;
  return index;
}

//[[Rcpp::export]]
float getStateProbability(S4 quantumSystem, int index) {
  NumericVector x = quantumSystem.slot("qbitVector");
  return std::pow(x[index], 2);
}

//[[Rcpp::export]]
void applyHadamard(S4 quantumSystem) {
  arma::vec x = quantumSystem.slot("qbitVector");
  arma::mat H = quantumSystem.slot("hadamardGate");
  quantumSystem.slot("qbitVector") = H * x;
}

//[[Rcpp::export]]
void applyOracleFunction(S4 quantumSystem, int target) {
  arma::vec x = quantumSystem.slot("qbitVector");
  x = arma::abs(x);
  x[target] = -x[target];
  quantumSystem.slot("qbitVector") = x;
}

//[[Rcpp::export]]
void applyDifussion(S4 quantumSystem) {
  arma::vec x = quantumSystem.slot("qbitVector");
  NumericVector::iterator it;
  bool first = true;
  for(it = x.begin();it<x.end();++it) {
    if (not first){
      *it = *it * -1;
    }
    first = false;
  }
  quantumSystem.slot("qbitVector") = x;
}
