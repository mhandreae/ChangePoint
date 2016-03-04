data {
real r_e; # prior mean for early slope
real r_l; # prior mean for late slope
int<lower=1> T; # number of observed time points
int<lower=1> observed[T]; # index of time at which observations are made 
real D[T]; # Data of y 
}

transformed data {
real log_unif;
log_unif <- -log(T);
}

parameters {
real e;
real l;
real<lower=0> sigma;
}

transformed parameters {
vector[T] lp;
lp <- rep_vector(log_unif, T);
for (s in 1:T)
for (t in 1:T)
lp[s] <- lp[s] + normal_log(D, if_else(observed[t] < s, observed[t]*e, (s*e + (observed[t]-s)*l)), sigma);
}

model {
e ~ normal(r_e, 10);
l ~ normal(r_l, 10);
sigma ~ normal(20, 10);
increment_log_prob(log_sum_exp(lp));
}

generated quantities {
int<lower=1,upper=T> s;
s <- categorical_rng(softmax(lp));
}