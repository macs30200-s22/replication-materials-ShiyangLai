# read the original exchange rate data set
conven_data <- read_csv("Exp Data/v2/conv_exchange.csv", col_types = cols(Date = col_date(format = "%Y-%m-%d")))
crypto_data <- read_csv("Exp Data/v2/crypto_exchange.csv", col_types = cols(Date = col_date(format = "%Y-%m-%d")))

# visualize cryptocurrency
a1 <-  ggplot() + geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDBTC, color='BTC')) +
  geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDLTC, color='LTC')) +
  geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDETH, color='ETH')) +
  geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDXRP, color='XRP')) +
  geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDDOGE, color='DOGE')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=0,ymax=Inf,fill="COVID-19"), alpha=0.3) +
#  geom_rect(aes(xmin=as.Date('2016-06-15'),xmax=as.Date('2016-06-30'),ymin=0,ymax=Inf, fill='Brexit referendum'), alpha=0.3) +
#  geom_rect(aes(xmin=as.Date('2019-11-06'),xmax=as.Date('2019-11-20'),ymin=0,ymax=Inf, fill='US election'), alpha=0.3) +
#  geom_rect(aes(xmin=as.Date('2018-11-06'),xmax=as.Date('2018-11-20'),ymin=0,ymax=Inf, fill='US election'), alpha=0.3) +
#  geom_rect(aes(xmin=as.Date('2020-11-06'),xmax=as.Date('2020-11-20'),ymin=0,ymax=Inf, fill='US election'), alpha=0.3) +
#  geom_rect(aes(xmin=as.Date('2021-11-06'),xmax=as.Date('2021-11-20'),ymin=0,ymax=Inf, fill='US election'), alpha=0.3) +
#  geom_rect(aes(xmin=as.Date('2015-11-06'),xmax=as.Date('2015-11-20'),ymin=0,ymax=Inf, fill='US election'), alpha=0.3) +
#  geom_rect(aes(xmin=as.Date('2016-11-06'),xmax=as.Date('2016-11-20'),ymin=0,ymax=Inf, fill='US election'), alpha=0.3) +
#  geom_rect(aes(xmin=as.Date('2017-11-06'),xmax=as.Date('2017-11-20'),ymin=0,ymax=Inf, fill='US election'), alpha=0.3) +
  labs(y='US Dollar', x='Year', color="Name") + 
  scale_color_manual(values = c('BTC'="#c1272d",
                                'LTC'="#0000a7",
                                'ETH'="#eecc16",
                                'XRP'="#008176",
                                'DOGE'="#b3b3b3")) +
  scale_y_continuous(trans='log2', labels = scales::number_format(accuracy = 0.001)) +
#  scale_fill_manual('',
#                    values = c('blue', 'red', 'orange')) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"), plot.margin = margin(t=10, r=10, b=2, l = 10, "pt"), legend.position = 'right')

# visualize conventional currency
a2 <- ggplot() + geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDAUD, color='AUD')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDEUR, color='EUR')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDJPY, color='JPY')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDGBP, color='GBP')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDCAD, color='CAD')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDCHF, color='CHF')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDCNY, color='CNY')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDNZD, color='NZD')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDSEK, color='SEK')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=0,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='Year', color="Name") + 
  scale_color_manual(values = c('EUR'="#f37e1a",
                                'AUD'="#efc571",
                                'JPY'="#991e1c",
                                'GBP'="#5c8490",
                                'CAD'="#c9b1a4",
                                'CHF'='#8c546c',
                                'CNY'='#e96060',
                                'NZD'='#35b1c9',
                                'SEK'='#b06dad')) +
  scale_y_continuous(trans='log2', labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=10, r=10, b=2, l = 10, "pt"),
        axis.title.y = element_blank(), legend.position = 'right')

# visualize cryptocurrency
a3 <-  ggplot() + 
  geom_line(aes(x=crypto_returns[time_range,]$...1, y=crypto_returns[time_range,]$USDLTC, color='LTC')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(y='', x='', color="") + 
  scale_color_manual(values = c('LTC'="#0000a7")) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        legend.position = 'none')

a4 <-  ggplot() + 
  geom_line(aes(x=crypto_returns[time_range,]$...1, y=crypto_returns[time_range,]$USDETH, color='ETH')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(y='', x='', color="") + 
  scale_color_manual(values = c('ETH'="#eecc16")) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        legend.position = 'none')

a5 <-  ggplot() + 
  geom_line(aes(x=crypto_returns[time_range,]$...1, y=crypto_returns[time_range,]$USDXRP, color='XRP')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(y='', x='', color="") + 
  scale_color_manual(values = c('XRP'="#008176")) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        legend.position = 'none')

a6 <-  ggplot() + 
  geom_line(aes(x=crypto_returns[time_range,]$...1, y=crypto_returns[time_range,]$USDDOGE, color='DOGE')) +
  # geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(y='', x='', color="") + 
  scale_color_manual(values = c('DOGE'="#b3b3b3" )) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        legend.position = 'none')

a7 <-  ggplot() + 
  geom_line(aes(x=crypto_returns[time_range,]$...1, y=crypto_returns[time_range,]$USDBTC, color='BTC')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(y='', x='', color="") + 
  scale_color_manual(values = c('BTC'="#c1272d")) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        legend.position = 'none')

# visualize conventional currency
a8 <- ggplot() + geom_line(aes(x=conven_returns[time_range,]$...1, y=conven_returns[time_range,]$USDAUD, color='AUD')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='', color="") + 
  scale_color_manual(values = c('AUD'="#efc571")) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        axis.title.y = element_blank(),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        legend.position = 'none')

a9 <- ggplot() + 
  geom_line(aes(x=conven_returns[time_range,]$...1, y=conven_returns[time_range,]$USDCAD, color='CAD')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='', color="") + 
  scale_color_manual(values = c('CAD'="#c9b1a4")) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        axis.title.y = element_blank(), legend.position = 'none')

a10 <- ggplot() + 
  geom_line(aes(x=conven_returns[time_range,]$...1, y=conven_returns[time_range,]$USDNZD, color='NZD')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='', color="") + 
  scale_color_manual(values = c('NZD'='#35b1c9')) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        axis.title.y = element_blank(), legend.position = 'none')

a11 <- ggplot() + 
  geom_line(aes(x=conven_returns[time_range,]$...1, y=conven_returns[time_range,]$USDSEK, color='SEK')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='', color="") + 
  scale_color_manual(values = c('SEK'='#b06dad')) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        axis.title.y = element_blank(), legend.position = 'none')

a12 <- ggplot() + 
  geom_line(aes(x=conven_returns[time_range,]$...1, y=conven_returns[time_range,]$USDEUR, color='EUR')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='', color="") + 
  scale_color_manual(values = c('EUR'="#f37e1a")) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        axis.title.y = element_blank(), legend.position = 'none')

a13 <- ggplot() + 
  geom_line(aes(x=conven_returns[time_range,]$...1, y=conven_returns[time_range,]$USDCNY, color='CNY')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='', color="") + 
  scale_color_manual(values = c('CNY'='#e96060')) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        axis.title.y = element_blank(), legend.position = 'none')

a14 <- ggplot() + 
  geom_line(aes(x=conven_returns[time_range,]$...1, y=conven_returns[time_range,]$USDJPY, color='JPY')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='', color="") + 
  scale_color_manual(values = c('JPY'="#991e1c")) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        axis.title.y = element_blank(), legend.position = 'none')

a15 <- ggplot() + 
  geom_line(aes(x=conven_returns[time_range,]$...1, y=conven_returns[time_range,]$USDCHF, color='CHF')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='', color="") + 
  scale_color_manual(values = c('CHF'='#8c546c')) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        axis.title.y = element_blank(), legend.position = 'none')

a16 <- ggplot() + 
  geom_line(aes(x=conven_returns[time_range,]$...1, y=conven_returns[time_range,]$USDGBP, color='GBP')) +
#  geom_rect(aes(xmin=as.Date('2020-01-21'),xmax=as.Date('2022-02-01'),ymin=-Inf,ymax=Inf),fill="red", alpha=0.3) +
  labs(x='', color="") + 
  scale_color_manual(values = c('GBP'="#5c8490")) +
  scale_y_continuous(labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"),
        plot.margin = margin(t=2, r=10, b=2, l=10, "pt"),
        axis.title.y = element_blank(), legend.position = 'none')

a1_ <- ggplot() + 
  labs(y='US Dollar', x='Year', color="Crypto") + 
  geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDBTC, color='BTC')) +
  geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDLTC, color='LTC')) +
  geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDETH, color='ETH')) +
  geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDXRP, color='XRP')) +
  geom_line(aes(x=crypto_data[time_range,]$Date, y=1/crypto_data[time_range,]$USDDOGE, color='DOGE')) +
  scale_color_manual(values = c('BTC'="#c1272d",
                                'LTC'="#0000a7",
                                'ETH'="#eecc16",
                                'XRP'="#008176",
                                'DOGE'="#b3b3b3")) +
  scale_y_continuous(trans='log2', labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"), plot.margin = margin(t=40, r=10, b=2, l = 10, "pt"), legend.position = 'right')
  
a2_ <- ggplot() + 
  labs(y='US Dollar', x='Year', color="Conven") + geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDAUD, color='AUD')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDEUR, color='EUR')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDJPY, color='JPY')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDGBP, color='GBP')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDCAD, color='CAD')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDCHF, color='CHF')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDCNY, color='CNY')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDNZD, color='NZD')) +
  geom_line(aes(x=conven_data[time_range,]$Date, y=1/conven_data[time_range,]$USDSEK, color='SEK')) +
  scale_color_manual(values = c('EUR'="#f37e1a",
                                'AUD'="#efc571",
                                'JPY'="#991e1c",
                                'GBP'="#5c8490",
                                'CAD'="#c9b1a4",
                                'CHF'='#8c546c',
                                'CNY'='#e96060',
                                'NZD'='#35b1c9',
                                'SEK'='#b06dad')) +
  scale_y_continuous(trans='log2', labels = scales::number_format(accuracy = 0.001)) +
  theme_cowplot() +
  theme(text=element_text(family="Times New Roman"), plot.margin = margin(t=40, r=10, b=2, l = 10, "pt"), legend.position = 'right')

legend1 <- get_legend(a1_)
legend2 <- get_legend(a2_)

plot_grid(a1, a2,
          a3, a8,
          a4, a9,
          a5, a10,
          a6, a11,
          a7, a12,
          NULL, a13,
          NULL, a14,
          NULL, a15,
          NULL, a16,
          ncol = 2, align = 'v',
          rel_heights = c(2, 1, 1, 1, 1, 1, 1, 1, 1, 1)) +
          draw_grob(legend1, 0.15, 0, 0.5, 0.47) +
          draw_grob(legend2, 0.30, 0, 0.5, 0.4)

plot_grid(a1, a2, ncol=2, align = 'hv')

all_returns <- merge(conven_returns[time_range,], crypto_returns[time_range,])[,focals]
correlation <- rcorr(as.matrix(all_returns))
print(correlation$r, digits=3)

as.matrix(psych::describe(volatility[time_range, ]))
jarque.bera.test(volatility[time_range, ]$USDEUR)

correlation <- rcorr(as.matrix(volatility[time_range,]))
print(correlation$r, digits=3)
