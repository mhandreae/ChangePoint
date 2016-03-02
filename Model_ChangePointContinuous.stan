data {
real r_e;
real r_l;
int<lower=1> T;
real<lower=0> D[T];
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
lp[s] <- lp[s] + normal_log(D[t], if_else(t < s, e, l), sigma);
}

model {
e ~ normal(r_e, 10);
l ~ normal(r_l, 10);
sigma ~ normal(20, 5);
increment_log_prob(log_sum_exp(lp));
}

generated quantities {
int<lower=1,upper=T> s;
s <- categorical_rng(softmax(lp));
}