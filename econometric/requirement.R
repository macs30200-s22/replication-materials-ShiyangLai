library(readr)
library(ggplot2)
library(ggthemes)
library(cowplot)
library(dplyr)
library(parallel)
library(devtools)
unloadNamespace('rmarkdown')
library(vars)
library(frequencyConnectedness)
library(BigVAR)
library(lubridate)
library(psych)
library(tseries)
library(rtadfr)
library(Hmisc)
library(igraph)
library(influenceR)

focals <- c("USDBTC", "USDDOGE", "USDLTC", "USDXRP", "USDETH",  
            "USDEUR", "USDJPY", "USDGBP", "USDAUD", "USDCAD",
            "USDCHF", "USDCNY", "USDSEK", "USDNZD")   # nine conventional currency

conven <- c(6: 14)

crypto <- c(1: 5)

time_stamp <- seq(as.Date("2015-08-08"), as.Date("2022-01-01"), by="day")

time_range <- c(2410:4748)

time_length <- c(1: (length(time_stamp)-99))
