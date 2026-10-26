
## Multiple Imputation

imp_data <- mice(data = dat, m = 50, maxit = 10, seed = 12345, print = FALSE)

# extract imp dataset
imp.datasets <-  complete(imp_data, "long")
# saving the imputed data into a file
write.csv(imp.datasets, file = "Completed Imputed Data.csv", row.names = FALSE)


# statistical analysis can be done with the function with() and pool()
# below is an example for pooled cox regression test 

#Pooled Cox regression test
fit_ECOG_cox <- with(imp_data, coxph(Surv(Time_Death, Event_Death) ~ ECOG))

pooled_ECOG <- pool(fit_ECOG_cox)

summary_ECOG_cox <- summary(pooled_ECOG)

summary_ECOG_cox <- data.frame(
  Variable = rownames(summary_ECOG_cox),
  Estimate = round(summary_ECOG_cox$estimate, 3),
  SE       = round(summary_ECOG_cox$std.error, 3),
  HR       = round(exp(summary_ECOG_cox$estimate), 3),
  Lower95  = round(exp(summary_ECOG_cox$estimate - 1.96*summary_ECOG_cox$std.error), 3),
  Upper95  = round(exp(summary_ECOG_cox$estimate + 1.96*summary_ECOG_cox$std.error), 3),
  p_value  = round(summary_ECOG_cox$p.value, 4)
)

summary_ECOG_cox