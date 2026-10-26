##Kaplan Meier, Log rank test, and Cox modelling

variables <- c("Age", "Stadium", "Operation", "Histotype")

for (var in variables) {
  
  cat("\n")
  cat("Variable:", var, "\n")
  
  formula <- as.formula(paste("Surv(Time_Death, Event_Death) ~", var))
  
  km.model <- survfit(formula, data = dat)
  
  print(km.model)
  print(summary(km.model))
  
  # Plot
  plot(km.model,
       xlab = "Time (months)",
       ylab = "%Alive - S(t)",
       main = paste("KM Death by", var),
       las = 1,
       col = 1:5,            
       mark.time = TRUE)
  
  abline(h = 0.5, col = "purple")
  
  legend("bottomright",
         legend = levels(as.factor(dat[[var]])),
         lty = 1,
         lwd = 2,
         col = 1:5,
         bty = "n",
         cex = 0.7)
  
  # Log-rank test
  print(survdiff(formula, data = dat))
  
  # Cox regression
  cox.model <- coxph(formula, data = dat)
  cox.summary <- summary(cox.model)
  
  HR <- round(exp(cox.summary$coef[, "coef"]), 3)
  Lower95 <- round(exp(cox.summary$coef[, "coef"] - 1.96*cox.summary$coef[, "se(coef)"]), 3)
  Upper95 <- round(exp(cox.summary$coef[, "coef"] + 1.96*cox.summary$coef[, "se(coef)"]), 3)
  p_value <- round(cox.summary$coef[, "Pr(>|z|)"], 4)
  
  result <- data.frame(HR = HR, Lower95 = Lower95, Upper95 = Upper95, p_value = p_value)
  print(result)
}