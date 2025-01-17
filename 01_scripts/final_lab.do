clear
cd "C:\Users\fcslab18\Documents\TS2025 - Luiz H"
use "datav2.dta"

tsset year

label variable v2xel_frefair "Clean elections index (0-1)"

*** Important: filter year >= 1889
drop if year < 1889

* Time series graph
tsline v2xel_frefair, yline(0) title("To what extent are elections free and fair?")

* Tests
dfuller v2xel_frefair
dfuller v2xel_frefair, drift
dfuller v2xel_frefair, trend

* Is it stationary? No, the model is random walk with trend.

*** -----

* First diff

twoway scatter d.v2xel_frefair year, yline(0)
tsline d.v2xel_frefair, yline(0)

dfuller d.v2xel_frefair
dfuller d.v2xel_frefair, drift
dfuller d.v2xel_frefair, trend

* Is it stationary? Yes, now it is stationary.

*** -----

* Second diff

twoway scatter d2.v2xel_frefair year, yline(0)
tsline d2.v2xel_frefair, yline(0)

dfuller d2.v2xel_frefair
dfuller d2.v2xel_frefair, drift
dfuller d2.v2xel_frefair, trend

* Is it stationary? Yes, now it is stationary.

*** -----
* Rival models

* Let's consider the first difference
ac d.v2xel_frefair
pac d.v2xel_frefair
corrgram d.v2xel_frefair
* p = 0
* d = 1
* q = 0
* White noise

* Let's consider the second difference
ac d2.v2xel_frefair
pac d2.v2xel_frefair
corrgram d2.v2xel_frefair
* p = 0
* d = 2
* q = 0
* Errors were introduced, so let's to use first difference

*** -----
* Model 1

arima v2xel_frefair, arima(0,1,0)
* Just sigma is significant

* Predicts
predict v2xel_frefair010_res, res
corrgram v2xel_frefair010_res

* Forecasting
predict v2xel_frefair010_oneahead, y
label var v2xel_frefair010_oneahead "One-step prediction using (0,1,0) model"

predict v2xel_frefair010_dy1988, dynamic(1988) y
label var v2xel_frefair010_dy1988 "Dynamic Forecast from 1988 using (0,1,0) model"

twoway line v2xel_frefair year || line v2xel_frefair010_oneahead year || line v2xel_frefair010_dy1988 year, legend(col(1))

*** -----
* Model 2
arima v2xel_frefair, arima(0,2,0) 
* Just sigma is significant

* Predicts
predict v2xel_frefair020_res, res
corrgram v2xel_frefair020_res

* Forecasting
predict v2xel_frefair020_oneahead, y
label var v2xel_frefair020_oneahead "One-step prediction using (0,2,0) model"

predict v2xel_frefair020_dy1988, dynamic(1988) y
label var v2xel_frefair020_dy1988 "Dynamic Forecast from 1988 using (0,2,0) model"

twoway line v2xel_frefair year || line v2xel_frefair020_oneahead year || line v2xel_frefair020_dy1988 year, legend(col(1))

*** -----
* Now comparing the two one-step forecasts:
twoway line v2xel_frefair year || line v2xel_frefair010_oneahead year || line v2xel_frefair020_oneahead year, legend(col(1))

* And the two dynamic forecasts:
twoway line v2xel_frefair year || line v2xel_frefair010_dy1988 year || line v2xel_frefair020_dy1988 year, legend(col(1))





