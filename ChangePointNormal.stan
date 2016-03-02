data { 
  int<lower=0> N;      // data count 
  vector[N] x;         // predictor (covariate) 
  vector[N] y;         // outcome (variate) 
  vector[N] t;         // time 
} 

parameters { 
  real b;                                // slope 
  real db;                               // slope change 
  real<lower=0> sigma;                   // noise 
  real<lower=1,upper=N> Tcp;             // change point time 
} 

model { 
  vector[N] mu_y;                   // modeled y 
  real H;                                 
  
      // smooth logistic approximation to Heaviside function 
  for (n in 1:N){ 
    H <- 1/(1+exp(-(t[n]-Tcp)*10));     
      // sampling sensitive to exponent coefficient 
    mu_y[n] <- (b + db*H)*x[n];         // modeled y 
  } 
  
  y ~ normal(mu_y,sigma);              // observed y with noise 
} 