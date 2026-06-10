
library(DHARMa)
library(glmmTMB)
set.seed(100)

testData = createData(sampleSize = 1000, overdispersion = 5, family = poisson(), randomEffectVariance = 20)
fittedModel <- glmmTMB(observedResponse ~ Environment1 + (1|group), 
                       family = "poisson", data = testData)

# check default for simulating data:
for (i in seq_along(fittedModel$obj$env$data$terms)) print(fittedModel$obj$env$data$terms[[i]]$simCode)
# dharma simulation
simulationOutput0 <- simulateResiduals(fittedModel = fittedModel, plot = F)
# glmmTMB simulation
sim0 <- simulate(fittedModel, seed = 101, nsim = 2)

# set glmmTMB sim codes
set_simcodes(fittedModel$obj, val = "random", terms = "ALL")
# check simulation conditions changed
for (i in seq_along(fittedModel$obj$env$data$terms)) print(fittedModel$obj$env$data$terms[[i]]$simCode)
simulationOutput_ran <- simulateResiduals(fittedModel = fittedModel, plot = F)
sim_ran <- simulate(fittedModel, seed = 101, nsim = 2) 


set_simcodes(fittedModel$obj, val = "zero", terms = "ALL")
# check simulation conditions changed
for (i in seq_along(fittedModel$obj$env$data$terms)) print(fittedModel$obj$env$data$terms[[i]]$simCode)
simulationOutput_zero <- simulateResiduals(fittedModel = fittedModel, plot = F)
sim_zero <- simulate(fittedModel, seed = 101, nsim = 2)

set_simcodes(fittedModel$obj, val = "fix", terms = "ALL")
# check simulation conditions changed
for (i in seq_along(fittedModel$obj$env$data$terms)) print(fittedModel$obj$env$data$terms[[i]]$simCode)
simulationOutput_fix <- simulateResiduals(fittedModel = fittedModel, plot = F)
sim_fix <- simulate(fittedModel, seed = 101, nsim = 2)

# check DHARMa resids (these are the same) 
res0 <- residuals(simulationOutput0)
res_ran <- residuals(simulationOutput_ran)
res_zero <- residuals(simulationOutput_zero)
res_fix <- residuals(simulationOutput_fix)

identical(res0, res_ran); identical(res0, res_zero); identical(res0, res_fix)

# check glmmTMB simulations

identical(sim0$sim_1, sim_ran$sim_1) # these are expected to be identical (expectation met)
identical(sim0$sim_1, sim_zero$sim_1) # I thought these might be different? (they are not)
identical(sim0$sim_1, sim_fix$sim_1) # I thought these might be different? (they are not)


