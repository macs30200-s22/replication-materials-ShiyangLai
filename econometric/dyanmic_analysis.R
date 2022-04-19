# next, rolling the time window
big_var_est <- function(data) {
  Model <- constructModel(data, p = 3, struct = "Basic", gran = c(10, 25), RVAR=FALSE,
                          h=1, cv="Rolling", MN=FALSE, verbose=FALSE, IC=TRUE)
  Model1Results <- cv.BigVAR(Model)
}

cl <- makeCluster(6)
clusterEvalQ(cl, library(BigVAR))
clusterEvalQ(cl, library(frequencyConnectedness))
clusterExport(cl, 'bounds')
sp <- spilloverRollingBK12(preturn.matrix, n.ahead = 100,
                           no.corr = F, func_est = "big_var_est",
                           params_est = list(), window = 100,
                           partition = bounds, cluster = cl)
stopCluster(cl)
plotOverall(sp)
# check time_length


plot_dynmaic_connectnedness <- function(data, label=FALSE) {
  cl <- makeCluster(6)
  clusterEvalQ(cl, library(BigVAR))
  clusterEvalQ(cl, library(frequencyConnectedness))
  clusterExport(cl, 'bounds')
  sp <- spilloverRollingBK12(data, n.ahead = 100,
                             no.corr = F, func_est = "big_var_est",
                             params_est = list(), window = 100,
                             partition = bounds, cluster = cl)
  stopCluster(cl)
  # plotOverall(sp)
  
  # calculate the spillover between cryptocurrency and traditional currency
  p_cry_trad_s <- vector(mode="numeric", length=0)
  p_trad_cry_s <- vector(mode="numeric", length=0)
  p_trad_trad_s <- vector(mode="numeric", length=0)
  p_cry_cry_s <- vector(mode="numeric", length=0)
  for (i in time_length) {
    # cross market
    cry_trad <- as.numeric(sp$list_of_tables[[i]][[1]][[1]][conven, crypto])
    trad_cry <- as.numeric(sp$list_of_tables[[i]][[1]][[1]][crypto, conven])
    p_cry_trad_s <- append(p_cry_trad_s, sum(cry_trad) / (length(conven) * length(crypto)))
    p_trad_cry_s <- append(p_trad_cry_s, sum(trad_cry) / (length(conven) * length(crypto)))
    # within market
    trad_trad <- as.numeric(sp$list_of_tables[[i]][[1]][[1]][conven,conven])
    cry_cry <- as.numeric(sp$list_of_tables[[i]][[1]][[1]][crypto,crypto])
    p_trad_trad_s <- append(p_trad_trad_s, sum(trad_trad) / (length(conven) * length(conven)))
    p_cry_cry_s <- append(p_cry_cry_s, sum(cry_cry) / (length(crypto) * length(crypto)))
  }
  
  p_cry_trad_m <- vector(mode="numeric", length=0)
  p_trad_cry_m <- vector(mode="numeric", length=0)
  p_trad_trad_m <- vector(mode="numeric", length=0)
  p_cry_cry_m <- vector(mode="numeric", length=0)
  for (i in time_length) {
    # cross market
    cry_trad <- as.numeric(sp$list_of_tables[[i]][[1]][[2]][conven, crypto])
    trad_cry <- as.numeric(sp$list_of_tables[[i]][[1]][[2]][crypto, conven])
    p_cry_trad_m <- append(p_cry_trad_m, sum(cry_trad) / (length(conven) * length(crypto)))
    p_trad_cry_m <- append(p_trad_cry_m, sum(trad_cry) / (length(conven) * length(crypto)))
    # within market
    trad_trad <- as.numeric(sp$list_of_tables[[i]][[1]][[2]][conven,conven])
    cry_cry <- as.numeric(sp$list_of_tables[[i]][[1]][[2]][crypto,crypto])
    p_trad_trad_m <- append(p_trad_trad_m, sum(trad_trad) / (length(conven) * length(conven)))
    p_cry_cry_m <- append(p_cry_cry_m, sum(cry_cry) / (length(crypto) * length(crypto)))
  }
  
  p_cry_trad_l <- vector(mode="numeric", length=0)
  p_trad_cry_l <- vector(mode="numeric", length=0)
  p_trad_trad_l <- vector(mode="numeric", length=0)
  p_cry_cry_l <- vector(mode="numeric", length=0)
  for (i in time_length) {
    # cross market
    cry_trad <- as.numeric(sp$list_of_tables[[i]][[1]][[3]][conven, crypto])
    trad_cry <- as.numeric(sp$list_of_tables[[i]][[1]][[3]][crypto, conven])
    p_cry_trad_l <- append(p_cry_trad_l, sum(cry_trad) / (length(conven) * length(crypto)))
    p_trad_cry_l <- append(p_trad_cry_l, sum(trad_cry) / (length(conven) * length(crypto)))
    # within market
    trad_trad <- as.numeric(sp$list_of_tables[[i]][[1]][[3]][conven,conven])
    cry_cry <- as.numeric(sp$list_of_tables[[i]][[1]][[3]][crypto,crypto])
    p_trad_trad_l <- append(p_trad_trad_l, sum(trad_trad) / (length(conven) * length(conven)))
    p_cry_cry_l <- append(p_cry_cry_l, sum(cry_cry) / (length(crypto) * length(crypto)))
  }
  
  dates <- seq(as.Date("2015-8-8"), as.Date("2022-1-1"), by = "days")
  colors <- c("Curren->Crypto" = "#002f56", "Crypto->Curren" = "#990000")
  
  if (label == TRUE) {
    legend_position = "top"
  } else {legend_position = "none"}
  
  a1 <- ggplot() +
    geom_line(aes(x=dates[time_length], y=p_cry_trad_s, color='Crypto->Curren'), size=1, alpha=0.5) +
    geom_line(aes(x=dates[time_length], y=p_trad_cry_s, color='Curren->Crypto'), size=1, alpha=0.5) +
    geom_smooth(aes(x=dates[time_length], y=p_cry_trad_s), method = 'loess', level=0.95,
                formula = y ~ x, color='#990000', size=1.5) +
    geom_smooth(aes(x=dates[time_length], y=p_trad_cry_s), method = 'loess', level=0.95,
                formula = y ~ x, color='#002f56', size=1.5) +
    labs(y="Connectedness", x="Time", color='') + ylim(c(0, 0.01)) +
    scale_color_manual(values = colors) + theme_cowplot() +
    theme(legend.position = legend_position, plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
          text=element_text(family="Times New Roman"))
  
  a2 <- ggplot() +
    geom_line(aes(x=dates[time_length], y=p_cry_trad_m, color='Crypto->Curren'), size=1, alpha=0.5) +
    geom_line(aes(x=dates[time_length], y=p_trad_cry_m, color='Curren->Crypto'), size=1, alpha=0.5) +
    geom_smooth(aes(x=dates[time_length], y=p_cry_trad_m), method = 'loess', level=0.95,
                formula = y ~ x, color='#990000', size=1.5) +
    geom_smooth(aes(x=dates[time_length], y=p_trad_cry_m), method = 'loess', level=0.95,
                formula = y ~ x, color='#002f56', size=1.5) +
    labs(y="Connectedness", x="Time", color='') + ylim(c(0, 0.01)) +
    scale_color_manual(values = colors) + theme_cowplot() +
    theme(legend.position = "none", plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
          text=element_text(family="Times New Roman"))
  
  a3 <- ggplot() +
    geom_line(aes(x=dates[time_length], y=p_cry_trad_l, color='Crypto->Curren'), size=1, alpha=0.5) +
    geom_line(aes(x=dates[time_length], y=p_trad_cry_l, color='Curren->Crypto'), size=1, alpha=0.5) +
    geom_smooth(aes(x=dates[time_length], y=p_cry_trad_l), method = 'loess', level=0.95,
                formula = y ~ x, color='#990000', size=1.5) +
    geom_smooth(aes(x=dates[time_length], y=p_trad_cry_l), method = 'loess', level=0.95,
                formula = y ~ x, color='#002f56', size=1.5) +
    labs(y="Connectedness", x="Time", color='') + ylim(c(0, 0.01)) +
    scale_color_manual(values = colors) + theme_cowplot() +
    theme(legend.position = "none", plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
          text=element_text(family="Times New Roman"))
  
  colors <- c("Curren->Curren" = "#002f56", "Crypto->Crypto" = "#990000")
  
  a4 <- ggplot() +
    geom_line(aes(x=dates[time_length], y=p_cry_cry_s, color='Crypto->Crypto'), size=1, alpha=0.5) +
    geom_line(aes(x=dates[time_length], y=p_trad_trad_s, color='Curren->Curren'), size=1, alpha=0.5) +
    geom_smooth(aes(x=dates[time_length], y=p_cry_cry_s), method = 'loess', level=0.95,
                formula = y ~ x, color='#990000', size=1.5) +
    geom_smooth(aes(x=dates[time_length], y=p_trad_trad_s), method = 'loess', level=0.95,
                formula = y ~ x, color='#002f56', size=1.5) +
    labs(y="Connectedness", x="Time", color='') + ylim(c(0, 0.15)) +
    scale_color_manual(values = colors) + theme_cowplot() +
    theme(legend.position = legend_position, plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
          text=element_text(family="Times New Roman"))
  
  a5 <- ggplot() +
    geom_line(aes(x=dates[time_length], y=p_cry_cry_m, color='Crypto->Crypto'), size=1, alpha=0.5) +
    geom_line(aes(x=dates[time_length], y=p_trad_trad_m, color='Curren->Curren'), size=1, alpha=0.5) +
    geom_smooth(aes(x=dates[time_length], y=p_cry_cry_m), method = 'loess', level=0.95,
                formula = y ~ x, color='#990000', size=1.5) +
    geom_smooth(aes(x=dates[time_length], y=p_trad_trad_m), method = 'loess', level=0.95,
                formula = y ~ x, color='#002f56', size=1.5) +
    labs(y="Connectedness", x="Time", color='') + ylim(c(0, 0.1)) +
    scale_color_manual(values = colors) + theme_cowplot() +
    theme(legend.position = 'none', plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
          text=element_text(family="Times New Roman"))
  
  a6 <- ggplot() +
    geom_line(aes(x=dates[time_length], y=p_cry_cry_l, color='Crypto->Crypto'), size=1, alpha=0.5) +
    geom_line(aes(x=dates[time_length], y=p_trad_trad_l, color='Curren->Curren'), size=1, alpha=0.5) +
    geom_smooth(aes(x=dates[time_length], y=p_cry_cry_l), method = 'loess', level=0.95,
                formula = y ~ x, color='#990000', size=1.5) +
    geom_smooth(aes(x=dates[time_length], y=p_trad_trad_l), method = 'loess', level=0.95,
                formula = y ~ x, color='#002f56', size=1.5) +
    labs(y="Connectedness", x="Time", color='') + ylim(c(0, 0.1)) +
    scale_color_manual(values = colors) + theme_cowplot() +
    theme(legend.position = 'none', plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
          text=element_text(family="Times New Roman"))
  
  return(list("crossshort"=a1, "crossmedium"=a2, "crosslong"=a3,
              "withinshort"=a4, "withinmedium"=a5, "withinlong"=a6))
}

return_connectedness <- plot_dynmaic_connectnedness(return.matrix)
preturn_connectedness <- plot_dynmaic_connectnedness(preturn.matrix)
nreturn_connectedness <- plot_dynmaic_connectnedness(nreturn.matrix)
volatility_connectedness <- plot_dynmaic_connectnedness(volatility.matrix)


plot_grid(return_connectedness$crossshort, preturn_connectedness$crossshort,
          nreturn_connectedness$crossshort, volatility_connectedness$crossshort,
          return_connectedness$crossmedium, preturn_connectedness$crossmedium,
          nreturn_connectedness$crossmedium, volatility_connectedness$crossmedium,
          return_connectedness$crosslong, preturn_connectedness$crosslong,
          nreturn_connectedness$crosslong, volatility_connectedness$crosslong,
          align = 'v', cols = 4)

plot_grid(return_connectedness$withinshort, preturn_connectedness$withinshort,
          nreturn_connectedness$withinshort, volatility_connectedness$withinshort,
          return_connectedness$withinmedium, preturn_connectedness$withinmedium,
          nreturn_connectedness$withinmedium, volatility_connectedness$withinmedium,
          return_connectedness$withinlong, preturn_connectedness$withinlong,
          nreturn_connectedness$withinlong, volatility_connectedness$withinlong,
          align = 'v', cols = 4)


plot_grid(a1, a2, a3,
          align = 'v', cols = 1)



