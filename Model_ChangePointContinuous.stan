data {
real<lower=0> r_e;
real<lower=0> r_l;
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
}

transformed parameters {
vector[T] lp;
lp <- rep_vector(log_unif, T);
for (s in 1:T)
for (t in 1:T)
lp[s] <- lp[s] + normal_log(D[t], if_else(t < s, e, l));
}

model {
e ~ normal(r_e, 10);
l ~ normal(r_l, 10);
increment_log_prob(log_sum_exp(lp));
}

generated quantities {
int<lower=1,upper=T> s;
s <- categorical_rng(softmax(lp));
}