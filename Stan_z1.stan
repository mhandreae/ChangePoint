data {
int<lower=1> nObs; # total number of observations 
vector[nObs] t; # times at which data are observed: time to diagnosis is negative
vector[nObs] y; # Data of y 
}



parameters {
real c; # change point
}


model {
real mu;
c ~ normal(-5, 2);

for (index in 1:nObs){
 mu <- (1/(1+ exp(t[nObs]-c)));
 # mu <- c*t[nObs];
 # mu <- exp(t[nObs]-c);
   }
y ~ normal(mu, 0.1);

}

