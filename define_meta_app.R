## define_meta_app.R ##

################################################
# Funções utilizadas para os effect-sizes
################################################
compute_meta = list(
  
  df_prop = metaprop,

  df_med1 = metacont
)

################################################
# Argumentos utilizados para as funções dos effect-sizes
################################################
arg_meta = reactiveValues(
  df_prop = list(event = dados$data$eventos, n = dados$data$n,
                  sm = "PLOGIT", method.ci = "CP", method.tau = "DL"),

  df_med1 = list(data = dados$data,
                  n.e = dados$data$n.e, mean.e = dados$data$mean.e, sd.e = dados$data$sd.e,
                  n.c = dados$data$n.c, mean.c = dados$data$mean.c, sd.c = dados$data$sd.c,
                  sm = "SM", method.tau = "DL")
  
)