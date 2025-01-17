
library(urca)

df <- haven::read_dta("02_outputs/data.dta")

df <- df |> 
  filter(year >= 1889)

df <- df |> 
  filter(country_name == "Brazil")

df <- df |> 
  select(year, v2xel_frefair) |> 
  arrange(year)

ts_clean_elections <- ts(df$v2xel_frefair)

# Teste sem constante (equivalente a `dfuller v2xel_frefair`)
test_without_const <- ur.df(ts_clean_elections, type = "none", lags = 0)

# Teste com drift (equivalente a `dfuller v2xel_frefair, drift`)
test_with_drift <- ur.df(ts_clean_elections, type = "drift", lags = 0)

# Teste com tendência (equivalente a `dfuller v2xel_frefair, trend`)
test_with_trend <- ur.df(ts_clean_elections, type = "trend", lags = 0)

# Visualizar resultados
summary(test_without_const)
summary(test_with_drift)
summary(test_with_trend)

### First Difference

# Teste sem constante (equivalente a `dfuller v2xel_frefair`)
test_without_const <- ur.df(ts_clean_elections, type = "none", lags = 0)

# Teste com drift (equivalente a `dfuller v2xel_frefair, drift`)
test_with_drift <- ur.df(ts_clean_elections, type = "drift", lags = 0)

# Teste com tendência (equivalente a `dfuller v2xel_frefair, trend`)
test_with_trend <- ur.df(ts_clean_elections, type = "trend", lags = 0)

# Visualizar resultados
summary(test_without_const)
summary(test_with_drift)
summary(test_with_trend)


### Second difference

d_v2xel_frefair <- diff(df$v2xel_frefair)

# Teste ADF sem drift
test_without_drift <- ur.df(d_v2xel_frefair, type = "none", lags = 0)

# Teste ADF com drift
test_with_drift <- ur.df(d_v2xel_frefair, type = "drift", lags = 0)

# Teste ADF com tendência
test_with_trend <- ur.df(d_v2xel_frefair, type = "trend", lags = 0)

# Visualizar os resultados
summary(test_without_drift)
summary(test_with_drift)
summary(test_with_trend)





library(tseries)

ts_clean_elections <- ts(df$v2xel_frefair)
adf.test(ts_clean_elections)

test_without_drift <- ur.df(ts_clean_elections, type = "none", lags = 0)
test_with_drift <- ur.df(ts_clean_elections, type = "drift", lags = 0)
test_with_trend <- ur.df(ts_clean_elections, type = "trend", lags = 0)

summary(test_without_drift)
summary(test_with_drift)


# First diff
first_diff_ts_clean_elections <- diff(ts_clean_elections)

test_without_drift <- ur.df(first_diff_ts_clean_elections, type = "none", lags = 0)
test_with_drift <- ur.df(first_diff_ts_clean_elections, type = "drift", lags = 0)
test_with_trend <- ur.df(first_diff_ts_clean_elections, type = "trend", lags = 0)

summary(test_without_drift)
summary(test_with_drift)




install.packages("corrgram")
library(corrgram)

acf(first_diff_ts_clean_elections, main="Correlograma de d.v2xel_frefair")

plot(first_diff_ts_clean_elections, ci = 0.95, type = "h", xlab = "Lag", ylab = NULL,
     ylim = c(-1, 1), main = NULL,
     ci.col = "blue", ci.type = c("white", "ma"),
     max.mfrow = 6)

pacf(first_diff_ts_clean_elections, main="Correlograma Parcial de first_diff_ts_clean_elections")


n <- length(first_diff_ts_clean_elections)  # Tamanho da série
lag_max <- min(floor(n / 2) - 2, 40)  # Calcula o número de lags

# Calcular autocorrelação
acf(first_diff_ts_clean_elections, lag.max = lag_max, main = "Autocorrelação")
acf(first_diff_ts_clean_elections, lag.max = lag_max, type = "covariance", plot = TRUE)


# Calcular autocorrelação parcial
pacf(first_diff_ts_clean_elections, lag.max = lag_max, main = "Autocorrelação Parcial")

ts_clean_elections

# Stationary test
adf.test(ts_clean_elections)

