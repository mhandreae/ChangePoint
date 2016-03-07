## Sampling model 6, irregular times with random intercept

require(rstan)
require(rstanarm)
load(file="Fit/MarginalChangePoint7.Rdata")
load(file = "Data/continuous_data7.Rdata")

# with the updated stan file
fit7 <- stan(fit=MarginalChangePoint7, iter= 10, chains = 4, 
             data= continuous_data7, cores = 4)
save(fit7, file="Fit/fit7.Rdata")
