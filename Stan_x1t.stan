data {
real prior_a; # prior mean for random intercepts
real prior_e; # prior mean for early slope
real prior_l; # prior mean for late slope
int<lower=1> span; # span of time intervals
int t[span]; # list of possible change points
int<lower=1> nObs; # total number of observations 
int<lower=1> n; # number of unique patients
int<lower=1> id[nObs]; # patient id (identifiers) 
real observed[nObs]; # index of times at which data are observed: time to diagnosis is negative
real D[nObs]; # Data of y 
}

transformed data {
real log_unif;
log_unif <- -log(span);
}

parameters {
real a[n]; # random intercept for each patient
real e; # slope before change point
real l; # slope after change point
real<lower=0> sigma; # error (SD)
}

transformed parameters {
vector[span] lp;
real early_slope;
real late_slope;
real mu;

lp <- rep_vector(log_unif, span);

for (s in 1:span){

# for each of the nObs observation in the long data frame indexed by index
 for (index in 1:nObs){

# condition change point
  int x_point;
  x_point <- observed[index] < t[s];
 
# early slope if condition == TRUE
  early_slope <- a[id[index]] +observed[index]*e;
 
# late slope if condition == FALSE
  late_slope <- a[id[index]] +t[s]*e +(observed[index]-t[s])*l;
 
  mu <- if_else(x_point, early_slope, late_slope);
 
#marginalization of change point
  lp[s] <- lp[s] + normal_log(D[index], mu, sigma); 
  } # first for loop
 } # second for loop
}

model {

a ~ normal(prior_a, 100);
e ~ normal(prior_e, 10);
l ~ normal(prior_l, 10);
increment_log_prob(log_sum_exp(lp));
}

generated quantities {
int s;
s <- categorical_rng(softmax(lp));
}
