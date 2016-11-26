## data_examples_app.R ##

################################################
# Modelo de proporção
################################################
df_prop = data.frame(Estudos = c("Porcu et al. 2002",
                               "Ferrari & Dalacorte 2007",
                               "Maues et al. 2007",
                               "Mendes-Chiloff et al. 2008"),
                     eventos = c(17, 23, 6, 106),
                     n = c(30, 50, 30, 189))

################################################
# Modelo de médias 1
################################################
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
