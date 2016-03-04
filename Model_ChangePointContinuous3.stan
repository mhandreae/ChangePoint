data {
real r_e; # prior mean for early slope
real r_l; # prior mean for late slope
int<lower=1> T; # number of time points
int<lower=1> n; # number of unique patients
real D[T,2]; # Data of y 
}

transformed data {
real log_unif;
log_unif <- -log(T);
}

parameters {
real a; # intercept
real e; # slope before change point
real l; # slope after change point
real<lower=0> sigma; # error (SD)
}

transformed parameters {
vector[T] lp;
lp <- rep_vector(log_unif, T);
for (s in 1:T)
for (t in 1:T)
for (id in 1:n)
lp[s] <- lp[s] + normal_log(D[t, id], if_else(t < s, (a +t*e), (a +s*e +(t-s)*l) ), sigma);
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