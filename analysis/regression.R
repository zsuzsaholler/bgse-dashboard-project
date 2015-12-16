library("sandwich")
library("lmtest")
library("car")
######Variable transformation
RegressionVars$log_listen_count = log(RegressionVars$listen_count)
RegressionVars$log_positive_to_total_tags = log(1 + RegressionVars$positive_to_total_tags)
RegressionVars$log_mean_user_central = log(1 + RegressionVars$mean_user_central)
RegressionVars$sq_mean_user_central = RegressionVars$mean_user_central**2
RegressionVars$cub_mean_user_central = RegressionVars$mean_user_central**3
RegressionVars$log_avg_tag_count = log(RegressionVars$avUserTagCount)

#####Definition of input and output variables
output = "log_listen_count"
input = c("mean_user_central","log_avg_tag_count"
           ,"log_positive_to_total_tags")
input_transf= c("sq_mean_user_central","year_month")
expr = paste( output , "~", paste(input,collapse= " + " ), "+" ,  paste(input_transf,collapse= " + " ))

#####Some descriptives
png(file="/home/zsuzsa/Documents/project/bgse-dashboard-project/pairwise.png", width=800, height=800 )
pairs(RegressionVars[,c(output,input)])
dev.off()
cor = cor(RegressionVars[,c(output,input)])

######Define subset
subset = RegressionVars[RegressionVars$first_tag > "2010-01-01",]

#Fit regression on total sample
fit = lm(expr, data = RegressionVars)
###Heteroskedasticity robust (White) se estimator
fit$newse = vcovHC(fit,type="HC")
fit.results = coeftest(fit,fit$newse)
crPlots(fit)
png(file="/home/zsuzsa/Documents/project/bgse-dashboard-project/fitted.png", width=800, height=800 )
plot(RegressionVars$mean_user_central,fit$fitted.values)
dev.off()

#Fit regression on subsample
fit.subset = lm(expr, data = subset)
fit.subset$newse = vcovHC(fit.subset,type="HC")
fit.subset.results = coeftest(fit.subset,fit.subset$newse)
crPlots(fit.subset)
png(file="/home/zsuzsa/Documents/project/bgse-dashboard-project/fitted_subset.png", width=800, height=800 )
plot(subset$mean_user_central,fit.subset$fitted.values)
dev.off()
