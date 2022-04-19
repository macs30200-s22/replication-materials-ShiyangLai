# calculate connectedness with frequency
bounds <- c(pi+0.00001, pi/2, pi/7, 0)
dy12 <- spilloverBK12(result, n.ahead=100, no.corr=F, partition=bounds)
dy12
net(dy12)

# test the random effect
cryptoTotrad_rs <- vector(mode="numeric", length=0)
tradTocrypto_rs <- vector(mode="numeric", length=0)
cryptoTotrad_rm <- vector(mode="numeric", length=0)
tradTocrypto_rm <- vector(mode="numeric", length=0)
cryptoTotrad_rl <- vector(mode="numeric", length=0)
tradTocrypto_rl <- vector(mode="numeric", length=0)

# assign the mission to cores
r <- mclapply(1:5, function(i) {
  for (i in c(1:6)) {
    white_noise <- matrix(rnorm(4748*37, 0, 10e-9), 4748, 37)
    result<- VAR(white_noise, p=3)
    dy12 <- spilloverBK12(result, n.ahead = 100, no.corr = F, partition = bounds)
    s <- dy12$tables[[1]]
    cryptoTotrad_rs <- append(cryptoTotrad_rs, as.numeric(s[c(12:37), c(1:11)]))
    tradTocrypto_rs <- append(tradTocrypto_rs, as.numeric(s[c(1:11), c(12:37)]))
    m <- dy12$tables[[2]]
    cryptoTotrad_rm <- append(cryptoTotrad_rm, as.numeric(m[c(12:37), c(1:11)]))
    tradTocrypto_rm <- append(tradTocrypto_rm, as.numeric(m[c(1:11), c(12:37)]))
    l <- dy12$tables[[3]]
    cryptoTotrad_rl <- append(cryptoTotrad_rl, as.numeric(l[c(12:37), c(1:11)]))
    tradTocrypto_rl <- append(tradTocrypto_rl, as.numeric(l[c(1:11), c(12:37)]))
  }
  cbind(cryptoTotrad_rs, tradTocrypto_rs, cryptoTotrad_rm, tradTocrypto_rm,
        cryptoTotrad_rl, tradTocrypto_rl)
}, mc.cores = 5)

# unpack results from t
for (i in c(1: 5)) {
  cryptoTotrad_rs <- append(cryptoTotrad_rs, r[[i]][, 1])
  tradTocrypto_rs <- append(tradTocrypto_rs, r[[i]][, 2])
  cryptoTotrad_rm <- append(cryptoTotrad_rm, r[[i]][, 3])
  tradTocrypto_rm <- append(tradTocrypto_rm, r[[i]][, 4])
  cryptoTotrad_rl <- append(cryptoTotrad_rl, r[[i]][, 5])
  tradTocrypto_rl <- append(tradTocrypto_rl, r[[i]][, 6])
}

plot_distribution <- function(dataset) {
  
  model.basic <- constructModel(dataset, p=4, struct = "Basic",
                                gran=c(10, 25), RVAR=FALSE, h=1,
                                cv="Rolling", MN=FALSE, verbose=FALSE,
                                IC=TRUE)
  result <- cv.BigVAR(model.basic)
  
  cryptoTotrad_s <- vector(mode="numeric", length=0)
  tradTocrypto_s <- vector(mode="numeric", length=0)
  cryptoTotrad_m <- vector(mode="numeric", length=0)
  tradTocrypto_m <- vector(mode="numeric", length=0)
  cryptoTotrad_l <- vector(mode="numeric", length=0)
  tradTocrypto_l <- vector(mode="numeric", length=0)
  
  dy12 <- spilloverBK12(result, n.ahead = 100, no.corr = F, partition = bounds)
  s <- dy12$tables[[1]]
  cryptoTotrad_s <- append(cryptoTotrad_s, as.numeric(s[conven, crypto]))
  tradTocrypto_s <- append(tradTocrypto_s, as.numeric(s[crypto, conven]))
  m <- dy12$tables[[2]]
  cryptoTotrad_m <- append(cryptoTotrad_m, as.numeric(m[conven, crypto]))
  tradTocrypto_m <- append(tradTocrypto_m, as.numeric(m[crypto, conven]))
  l <- dy12$tables[[3]]
  cryptoTotrad_l <- append(cryptoTotrad_l, as.numeric(l[conven, crypto]))
  tradTocrypto_l <- append(tradTocrypto_l, as.numeric(l[crypto, conven]))
  
  colors <- c("Crypto->Curren" = "red", "Curren->Crypto" = "blue")
  a <- ggplot() + 
    geom_density(data = as.data.frame(tradTocrypto_s), alpha=0.9,
                 aes(x=tradTocrypto_s, ..scaled.., fill="Curren->Crypto")) +
    geom_density(data = as.data.frame(cryptoTotrad_s), alpha=0.9,
                 aes(x=cryptoTotrad_s, ..scaled.., fill="Crypto->Curren")) +
    labs(x="Connectedness", y="Probability", fill='') +
    xlim(c(0, 0.002)) + 
    scale_color_manual(values = colors) + theme_cowplot() +
    theme(legend.position = c(0.7, 0.8),
          plot.margin = margin(0.5,0.8,0.5,0.8, "cm"),
          text=element_text(family="Times New Roman"))
  return(a)
}

b1 <- plot_distribution(return.matrix)
b2 <- plot_distribution(preturn.matrix)
b3 <- plot_distribution(nreturn.matrix)
b4 <- plot_distribution(volatility.matrix)

plot_grid(b1, b2, b3, b4, align = 'v', cols = 2)






