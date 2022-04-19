# return description
as.data.frame(describe(crypto_data[time_range, ]))
jarque.bera.test(returns[time_range, ]$USDETH)


# estimate test statistic and data-stamping sequence
obs <- length(time_range)
r0 <- 100
test <- rtadf(1/crypto_data[time_range, ]$USDBTC, r0, test='sadf')

# simulate critical values and data-stamping threshold
cvs <- rtadfSimPar(obs, nrep=1000, r0, test = 'sadf')

testDf <- list("test statistic" = test$testStat, "critical values" = cvs$testCVs)  # test results

print(testDf)  

StampDf.BTC <- data.frame('The backward SADF sequence (left axis)'= test$testSeq,
                      'The 95% critical value sequence (left axis)'= cvs$datestampCVs[,2],
                      'The price of Bitcoin (right axis)' = 1/crypto_data[time_range, ]$USDBTC,
                      'Time'= time_stamp)  # data for datestamping procedure

colors <- c("The backward SADF sequence (left axis)" = "#2323A6",
            "The 95% critical value sequence (left axis)" = "#A52422",
            "Price in USD (right axis)" = "#0D5A0D")

a1 <- ggplot(StampDf.BTC) +
  geom_line(aes(x=StampDf.BTC$Time, y=StampDf.BTC$The.backward.SADF.sequence..left.axis., color="The backward SADF sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.BTC$Time, y=StampDf.BTC$The.95..critical.value.sequence..left.axis., color="The 95% critical value sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.BTC$Time, y=StampDf.BTC$The.price.of.Bitcoin..right.axis./5000, color="Price in USD (right axis)"), size=1) +
  scale_y_continuous('Critical Values', sec.axis = sec_axis(~.*5000, name='Price')) +
  theme_cowplot() + scale_color_manual(values = colors) +
  labs(title="BTC", x="Time", color='') +
  theme(legend.position = 'none', plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
        text=element_text(family="Times New Roman"))


test <- rtadf(1/crypto_data[time_range, ]$USDLTC, r0, test='sadf')
# simulate critical values and data-stamping threshold
cvs <- rtadfSimPar(obs, nrep=1000, r0, test = 'sadf')
testDf <- list("test statistic" = test$testStat, "critical values" = cvs$testCVs)  # test results
print(testDf)

StampDf.LTC <- data.frame('The backward SADF sequence (left axis)'= test$testSeq,
                          'The 95% critical value sequence (left axis)'= cvs$datestampCVs[,2],
                          'The price of Bitcoin (right axis)' = 1/crypto_data[time_range, ]$USDLTC,
                          'Time'= time_stamp)  # data for datestamping procedure

a2 <- ggplot(StampDf.LTC) +
  geom_line(aes(x=StampDf.LTC$Time, y=StampDf.LTC$The.backward.SADF.sequence..left.axis., color="The backward SADF sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.LTC$Time, y=StampDf.LTC$The.95..critical.value.sequence..left.axis., color="The 95% critical value sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.LTC$Time, y=StampDf.LTC$The.price.of.Bitcoin..right.axis./35, color="Price in USD (right axis)"), size=1) +
  scale_y_continuous('Critical Values', sec.axis = sec_axis(~.*35, name='Price')) +
  theme_cowplot() + scale_color_manual(values = colors) +
  labs(title="LTC", x="Time", color='') +
  theme(legend.position = 'none', plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
        text=element_text(family="Times New Roman"))

test <- rtadf(1/crypto_data[time_range, ]$USDETH, r0, test='sadf')
# simulate critical values and data-stamping threshold
cvs <- rtadfSimPar(obs, nrep=1000, r0, test = 'sadf')
testDf <- list("test statistic" = test$testStat, "critical values" = cvs$testCVs)  # test results
print(testDf)

StampDf.ETH <- data.frame('The backward SADF sequence (left axis)'= test$testSeq,
                          'The 95% critical value sequence (left axis)'= cvs$datestampCVs[,2],
                          'The price of Bitcoin (right axis)' = 1/crypto_data[time_range, ]$USDETH,
                          'Time'= time_stamp)  # data for datestamping procedure

a3 <- ggplot(StampDf.ETH) +
  geom_line(aes(x=StampDf.ETH$Time, y=StampDf.ETH$The.backward.SADF.sequence..left.axis., color="The backward SADF sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.ETH$Time, y=StampDf.ETH$The.95..critical.value.sequence..left.axis., color="The 95% critical value sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.ETH$Time, y=StampDf.ETH$The.price.of.Bitcoin..right.axis./300, color="Price in USD (right axis)"), size=1) +
  scale_y_continuous('Critical Values', sec.axis = sec_axis(~.*300, name='Price')) +
  theme_cowplot() + scale_color_manual(values = colors) +
  labs(title="ETH", x="Time", color='') +
  theme(legend.position = 'none', plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
        text=element_text(family="Times New Roman"))

test <- rtadf(1/crypto_data[time_range, ]$USDXRP, r0, test='sadf')
# simulate critical values and data-stamping threshold
cvs <- rtadfSimPar(obs, nrep=1000, r0, test = 'sadf')
testDf <- list("test statistic" = test$testStat, "critical values" = cvs$testCVs)  # test results
print(testDf)

StampDf.XRP <- data.frame('The backward SADF sequence (left axis)'= test$testSeq,
                          'The 95% critical value sequence (left axis)'= cvs$datestampCVs[,2],
                          'The price of Bitcoin (right axis)' = 1/crypto_data[time_range, ]$USDXRP,
                          'Time'= time_stamp)  # data for datestamping procedure

a4 <- ggplot(StampDf.XRP) +
  geom_line(aes(x=StampDf.XRP$Time, y=StampDf.XRP$The.backward.SADF.sequence..left.axis., color="The backward SADF sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.XRP$Time, y=StampDf.XRP$The.95..critical.value.sequence..left.axis., color="The 95% critical value sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.XRP$Time, y=StampDf.XRP$The.price.of.Bitcoin..right.axis.*5, color="Price in USD (right axis)"), size=1) +
  scale_y_continuous('Critical Values', sec.axis = sec_axis(~./5, name='Price')) +
  theme_cowplot() + scale_color_manual(values = colors) +
  labs(title="XRP", x="Time", color='') +
  theme(legend.position = 'none', plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
        text=element_text(family="Times New Roman"))

test <- rtadf(1/crypto_data[time_range, ]$USDDOGE, r0, test='sadf')
# simulate critical values and data-stamping threshold
cvs <- rtadfSimPar(obs, nrep=1000, r0, test = 'sadf')
testDf <- list("test statistic" = test$testStat, "critical values" = cvs$testCVs)  # test results
print(testDf)

StampDf.DOGE <- data.frame('The backward SADF sequence (left axis)'= test$testSeq,
                          'The 95% critical value sequence (left axis)'= cvs$datestampCVs[,2],
                          'The price of Bitcoin (right axis)' = 1/crypto_data[time_range, ]$USDXRP,
                          'Time'= time_stamp)  # data for datestamping procedure

a5 <- ggplot(StampDf.DOGE) +
  geom_line(aes(x=StampDf.DOGE$Time, y=StampDf.DOGE$The.backward.SADF.sequence..left.axis., color="The backward SADF sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.DOGE$Time, y=StampDf.DOGE$The.95..critical.value.sequence..left.axis., color="The 95% critical value sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.DOGE$Time, y=StampDf.DOGE$The.price.of.Bitcoin..right.axis.*5, color="Price in USD (right axis)"), size=1) +
  scale_y_continuous('Critical Values', sec.axis = sec_axis(~./5, name='Price')) +
  theme_cowplot() + scale_color_manual(values = colors) +
  labs(title="DOGE", x="Time", color='') +
  theme(legend.position = 'none', plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
        text=element_text(family="Times New Roman"))

a1_ <- ggplot(StampDf.BTC) +
  geom_line(aes(x=StampDf.BTC$Time, y=StampDf.BTC$The.backward.SADF.sequence..left.axis., color="The backward SADF sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.BTC$Time, y=StampDf.BTC$The.95..critical.value.sequence..left.axis., color="The 95% critical value sequence (left axis)"), size=1) +
  geom_line(aes(x=StampDf.BTC$Time, y=StampDf.BTC$The.price.of.Bitcoin..right.axis./5000, color="Price in USD (right axis)"), size=1) +
  scale_y_continuous('Critical Values', sec.axis = sec_axis(~.*5000, name='Price')) +
  theme_cowplot() + scale_color_manual(values = colors) +
  labs(title="BTC", x="Time", color='') +
  theme(legend.position = c(0.05, 0.85), plot.margin = margin(0.5,0.5,0.5,0.5, "cm"), 
        text=element_text(family="Times New Roman"))

legend3 <- get_legend(a1_)

plot_grid(a1, a2, a3, a4, a5, NULL, ncol=3, nrow=2, align = 'hv') +
  draw_grob(legend3, 0.66, 0, 0.5, 0.4)


