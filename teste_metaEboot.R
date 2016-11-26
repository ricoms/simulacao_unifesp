library(meta)
library(boot)

df_prop = data.frame(Estudos = c("Porcu et al. 2002",
                                 "Ferrari & Dalacorte 2007",
                                 "Maues et al. 2007",
                                 "Mendes-Chiloff et al. 2008"),
                     eventos = c(17, 23, 6, 106),
                     n = c(30, 50, 30, 189))

df_med1 = data.frame(Estudos = c("Porcu et al. 2002",
                                 "Ferrari & Dalacorte 2007",
                                 "Maues et al. 2007",
                                 "Mendes-Chiloff et al. 2008"),
                     n.e = c(30, 23, 83, 21),
                     mean.e = c(51.57, 75.09, 30.08, 2.95),
                     sd.e = c(16.5, 23.01, 14.29, 1.28),
                     n.c = c(30, 24, 81, 21),
                     mean.c = c(72.97, 81.63, 35.38, 3.48),
                     sd.c = c(13.23, 14.42, 16.13, 0.68))


meta1 = metaprop(event = df_prop$eventos, n = df_prop$n,
                 sm = "PLOGIT", method.ci = "CP", method.tau = "DL")

meta2 = metacont(data = df_med1,
                 n.e = df_med1$n.e, mean.e = df_med1$mean.e, sd.e = df_med1$sd.e,
                 n.c = df_med1$n.c, mean.c = df_med1$mean.c, sd.c = df_med1$sd.c,
                 sm = "SM", method.tau = "DL")

media = function(data, i) {
  mean(data[i])
}
but1 = boot(meta1$TE, statistic = media, R = 1000)
plot(but1)
but2 = boot(meta2$TE, statistic = media, R = 1000)
plot(but2)

mediana = function(data, i) {
  median(data[i])
}
but3 = boot(meta1$TE, statistic = mediana, R = 1000)
plot(but1)
but4 = boot(meta2$TE, statistic = mediana, R = 1000)
plot(but2)

meta1$Q

par(mfrow=c(1,2),oma=c(0,0,2,0))
plot(density(but1$t))
plot(density(but3$t))