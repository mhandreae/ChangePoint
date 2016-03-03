data {
real r_e;
real r_l;
int<lower=1> T;
real D[T,2];
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
lp <- rep_matrix(log_unif, T, 2);
for (s in 1:T)
for (t in 1:T)
lp[s,1] <- lp[s,1] + normal_log(D[t], if_else(t < s, t*e, (s*e + (t-s)*l)), sigma);
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