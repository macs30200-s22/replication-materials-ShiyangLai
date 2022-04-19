# calculate the VAR-L model
# install_github("tomaskrehlik/frequencyConnectedness", tag = "dev")

returns <- read_csv("Exp Data/v2/returns.csv",
                    col_types = cols(...1 = col_date(format = "%Y-%m-%d")))
returns <- returns[, focals]

positive_returns <- read_csv("Exp Data/v2/preturns.csv",
                             col_types = cols(...1 = col_date(format = "%Y-%m-%d")))
positive_returns <- positive_returns[, focals]

negative_returns <- read_csv("Exp Data/v2/nreturns.csv",
                             col_types = cols(...1 = col_date(format = "%Y-%m-%d")))
negative_returns <- negative_returns[, focals]

volatility <- read_csv("Exp Data/v2/volatility.csv",
                       col_types = cols(...1 = col_date(format = "%Y-%m-%d")))
volatility <- volatility[, focals]

########################## returns ##############################

# transform to matrix
return.matrix <- data.matrix(returns[time_range, ])

VARselect(returns, lag.max=20, type='both')

# set lag order to 3 according to AIC and FPE
model.basic <- constructModel(return.matrix, p=4, struct = "Basic",
                              gran=c(10, 25), RVAR=FALSE, h=1,
                              cv="Rolling", MN=FALSE, verbose=FALSE,
                              IC=TRUE)
result <- cv.BigVAR(model.basic)
plot(result)
SparsityPlot.BigVAR.results(result)
result


########################## positive returns ############################

# transform to matrix
preturn.matrix <- data.matrix(positive_returns[time_range, ])
# train a VAR-LASSO model
model.basic <- constructModel(preturn.matrix, p=3, struct = "Basic",
                              gran=c(10, 25), RVAR=FALSE, h=1,
                              cv="Rolling", MN=FALSE, verbose=FALSE,
                              IC=TRUE)
result <- cv.BigVAR(model.basic)
SparsityPlot.BigVAR.results(result)
result


########################## negative returns ############################

# transform to matrix
nreturn.matrix <- data.matrix(negative_returns[time_range, ])
# train a VAR-LASSO model
model.basic <- constructModel(nreturn.matrix, p=3, struct = "Basic",
                              gran=c(10, 25), RVAR=FALSE, h=1,
                              cv="Rolling", MN=FALSE, verbose=FALSE,
                              IC=TRUE)
result <- cv.BigVAR(model.basic)
SparsityPlot.BigVAR.results(result)
result


########################## volatility ############################

# transform to matrix
volatility.matrix <- data.matrix(volatility[time_range, ])
# train a VAR-LASSO model
model.basic <- constructModel(volatility.matrix, p=3, struct = "Basic",
                              gran=c(10, 25), RVAR=FALSE, h=1,
                              cv="Rolling", MN=FALSE, verbose=FALSE,
                              IC=TRUE)
result <- cv.BigVAR(model.basic)
SparsityPlot.BigVAR.results(result)
result






