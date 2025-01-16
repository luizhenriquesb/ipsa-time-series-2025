* Here is an example of a basic regression model using data from Ray Fair's US political economy data set.
* We start by setting our directory and loading in the data:

cd "C:\Class Folders\TSPTSM1\Lab"
use "fair.dta", clear

* In this program we will make a call to an ado file.  If you are working on your own computer,
* you will have your own ado structure set using the default settings in Stata and wouldn't need
* to worry about the next two lines.  However, if you are working on a computer for which you do
* not have administrative authority, you will often need to place your ado files in a directory 
* that is different from the Stata defaults and then redirect Stata to those directories:
sysdir set PLUS "C:\Class Folders\TSPTSM1\Lab\ado\plus"
sysdir set PERSONAL "C:\Class Folders\TSPTSM1\Lab\ado\personal"



* Here are the variable explanations:
    * VOTE = Incumbent share of the two-party presidential vote.
    * PARTY = 1 if there is a Democratic incumbent at the time of the election and -1 if 
	* there is a Republican incumbent.
    * PERSON = 1 if the incumbent is running for election and 0 otherwise.
    * DURATION = 0 if the incumbent party has been in power for one term, 1 if the incumbent 
	* party has been in power for two consecutive terms, 1.25 if the incumbent party has 
	* been in power for three consecutive terms, 1.50 for four consecutive terms, and so on.
    * WAR = 1 for the elections of 1920, 1944, and 1948 and 0 otherwise.
    * GROWTH = growth rate of real per capita GDP in the first three quarters of the election 
	* year (annual rate).
    * INFLATION = absolute value of the growth rate of the GDP deflator in the first 15 quarters 
	* of the administration (annual rate) except for 1920, 1944, and 1948, where the values are zero.
    * GOODNEWS = number of quarters in the first 15 quarters of the administration in which the 
	* growth rate of real per capita GDP is greater than 3.2 percent at an annual rate except for 1920, 1944, and 1948, where the values are zero. 



* Let's take a look at STATA's default regression output:
reg VOTE GROWTH

* Let's make sure that we understand what each element in these results tells us


* Now let's add another variable to our study.  The GOODNEWS variable is one that Fair added
* after his model's very public failure in 1998.  It measures the number of quarters of consecutive
* economic good news.
reg VOTE GOODNEWS
reg VOTE GROWTH GOODNEWS

* Now let's put these three models together in a table and discuss what we see across them:
reg VOTE GROWTH
estimates store m1, title(Model 1)
reg VOTE GOODNEWS
estimates store m2, title(Model 2)
reg VOTE GROWTH GOODNEWS
estimates store m3, title(Model 3)

estout  m*, style(smcl)  /*
*/ cells(b(star fmt(2)) se(par fmt(2))) /*
*/ varlabels(_cons Intercept)  stats(r2 N)

* What do we see?
