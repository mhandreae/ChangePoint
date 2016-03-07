data {
real r_a; # prior mean for random intercepts
real r_e; # prior mean for early slope
real r_l; # prior mean for late slope
int<lower=1> T; # time max 
int<lower=1> sumZ; # total number of observations 
int<lower=1> n; # number of unique patients
int<lower=1> id[sumZ]; # patient id (identifiers) 
int<lower=1> observed[sumZ]; # index of times at which data are observed
real D[sumZ]; # Data of y 
}

transformed data {
real log_unif;
log_unif <- -log(T);
}

parameters {
real a[n]; # random intercept for each patient
real e; # slope before change point
real l; # slope after change point
real<lower=0> sigma; # error (SD)
}

transformed parameters {
vector[T] lp;
lp <- rep_vector(log_unif, T);
for (index in 1:sumZ)
for (s in 1:T)
for (t in 1:T)
lp[s] <- lp[s] + normal_log(D[index], if_else(observed[index] < s, (a[id[index]] +observed[index]*e), (a[id[index]] +s*e +(observed[index]-s)*l) ), sigma);
}

model {
a ~ normal(r_a, 100);
e ~ normal(r_e, 10);
l ~ normal(r_l, 10);
sigma ~ normal(20, 10);
increment_log_prob(log_sum_exp(lp));
}

generated quantities {
int<lower=1,upper=T> s;
s <- categorical_rng(softmax(lp));
}