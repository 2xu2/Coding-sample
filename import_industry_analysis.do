clear all
*--------------------------------------------------
* Stata file for import analysis
* Author: Xing Xu
* Create time: Nov, 2021
* Project: US-China trade war on US  
* Data industry import data from the python notebook [Import analysis]
* 12th difference and generalized DiD (tariffs are considered to be continuous) are mainly in use to estimate the effect of 
* I also adopt an event study framework (in this case consider tariffs to be discrete and a positive tariff change as treatment)

cd "C:\Coding sample" // Change the path to reproduce my results
import delimited "output_data\NAICS4_industry_import.csv"
gen time = date(date, "YMD")
gen ym = mofd(time)
format ym %tm

* We need the following variables:
gen logemplvl = log(emplvl*1000)
gen logCNimport = log(china_import)
gen importROW = total_import - china_import
gen logimportROW = log(importROW)
gen logtotalimport = log(total_import)
gen logtariff = log(1 + weighted_tariff/100)
gen naics4ym = naics4 *100000 + ym

xtset naics4 ym

* Regression part, we use xtreg for the 12th difference panel regression and reghdfe for the generalized Staggered DiD
* employment
xtreg D12.logemplvl D12.logtariff i.ym, cluster(naics4)
outreg2 using "regression_results/industry_import_analysis.tex", ctitle(D.12) keep(D12.logtariff) addtext(Subsample, ALL) label tex(frag) replace /// 
title("Twelfth Difference and DiD panel regression of Log employment")

xtreg D12.logemplvl D12.logtariff i.ym if naics2 == 11, cluster(naics4)
outreg2 using "regression_results/industry_import_analysis.tex", ctitle(D.12) keep(D12.logtariff) addtext(Subsample, Agriculture) label tex(frag) append

xtreg D12.logemplvl D12.logtariff i.ym if naics2 == 31|naics2 == 32|naics2 == 33, cluster(naics4)
outreg2 using "regression_results/industry_import_analysis.tex", ctitle(D.12) keep(D12.logtariff) addtext(Subsample, Manufacture) label tex(frag) append 


reghdfe logemplvl logtariff, absorb(ym naics4) cluster(naics4)
outreg2 using "regression_results/industry_import_analysis.tex", ctitle(DiD) keep(logtariff) addtext(Subsample, All) label tex(frag) append 

reghdfe logemplvl logtariff if naics2 == 11,absorb(ym naics4) cluster(naics4)
outreg2 using "regression_results/industry_import_analysis.tex", ctitle(DiD) keep(logtariff) addtext(Subsample, Agriculture) label tex(frag) append 

reghdfe logemplvl logtariff if naics2 == 31|naics2 == 32|naics2 == 33,absorb(ym naics4)  cluster(naics4)
outreg2 using "regression_results/industry_import_analysis.tex", ctitle(DiD) keep(logtariff) addtext(Subsample, Manufacture) label tex(frag) append 


* CN imports
xtreg D12.logCNimport D12.logtariff i.ym, cluster(naics4)
outreg2 using "regression_results/importCN_analysis.tex", ctitle(D.12) keep(D12.logtariff) addtext(Subsample, ALL) label tex(frag) replace /// 
title("Twelfth Difference and DiD panel regression of Log import to China")

xtreg D12.logCNimport D12.logtariff i.ym if naics2 == 11, cluster(naics4)
outreg2 using "regression_results/importCN_analysis.tex", ctitle(D.12) keep(D12.logtariff) addtext(Subsample, Agriculture) label tex(frag) append

xtreg D12.logimport D12.logtariff i.ym if naics2 == 31|naics2 == 32|naics2 == 33, cluster(naics4)
outreg2 using "regression_results/importCN_analysis.tex", ctitle(D.12) keep(D12.logtariff) addtext(Subsample, Manufacture) label tex(frag) append 

reghdfe logCNimport logtariff, absorb(ym naics4) cluster(naics4)
outreg2 using "regression_results/importCN_analysis.tex", ctitle(DiD) keep(logtariff) addtext(Subsample, All) label tex(frag) append 

reghdfe logCNimport logtariff if naics2 == 11, absorb(ym naics4) cluster(naics4)
outreg2 using "regression_results/importCN_analysis.tex", ctitle(DiD) keep(logtariff) addtext(Subsample, Agriculture) label tex(frag) append 

reghdfe logCNimport logtariff if naics2 == 31|naics2 == 32|naics2 == 33, absorb(ym naics4) cluster(naics4)
outreg2 using "regression_results/importCN_analysis.tex", ctitle(DiD) keep(logtariff) addtext(Subsample, Manufacture) label tex(frag) append 

* Imports from the rest of the world
xtreg D12.logimportROW D12.logtariff i.ym, cluster(naics4)
outreg2 using "regression_results/importROW_analysis.tex", ctitle(D.12) keep(D12.logtariff) addtext(Subsample, ALL) label tex(frag) replace /// 
title("Twelfth Difference and DiD panel regression of log import to the rest of the world")

xtreg D12.logimportROW D12.logtariff i.ym if naics2 == 11, cluster(naics4)
outreg2 using "regression_results/importROW_analysis.tex", ctitle(D.12) keep(D12.logtariff) addtext(Subsample, Agriculture) label tex(frag) append

xtreg D12.logimportROW D12.logtariff i.ym if naics2 == 31|naics2 == 32|naics2 == 33, cluster(naics4)
outreg2 using "regression_results/importROW_analysis.tex", ctitle(D.12) keep(D12.logtariff) addtext(Subsample, Manufacture) label tex(frag) append 

reghdfe logimportROW logtariff, absorb(ym naics4) cluster(naics4)
outreg2 using "regression_results/importROW_analysis.tex", ctitle(DiD) keep(logtariff) addtext(Subsample, All) label tex(frag) append 

reghdfe logimportROW logtariff if naics2 == 11, absorb(ym naics4) cluster(naics4)
outreg2 using "regression_results/importROW_analysis.tex", ctitle(DiD) keep(logtariff) addtext(Subsample, Agriculture) label tex(frag) append 

reghdfe logimportROW logtariff if naics2 == 31|naics2 == 32|naics2 == 33, absorb(ym naics4) cluster(naics4)
outreg2 using "regression_results/importROW_analysis.tex", ctitle(DiD) keep(logtariff) addtext(Subsample, Manufacture) label tex(frag) append

///////////////////////////////////////////////////////////////////////////////////

* Event study on whole labor market
local n = 6
bysort naics4: egen iftreat = max(treatment) //if ever treated

	* double-check: naics4 = 1111
	sort naics4 ym
	browse naics4 ym weighted_tariff iftreat if naics4 == 1111  // 1111

	* Determine the starting years for each treated naics4
bysort naics4: egen startyr = min(ym)   if treatment == 1
bysort naics4: replace startyr = startyr[_N] if startyr == . 
format startyr %tm

* Create startyear, lags and leads on T*I{t=k}
bys naics4: gen treat_startyr = iftreat*(ym == startyr)                // k = 0
forvalues i = 6(-1)1 {
	bysort naics4: gen treat_lagyr`i'  = iftreat*(ym == startyr - `i') // k = -i 
}             
forvalues i = 1/6 {
	bysort naics4: gen treat_leadyr`i' = iftreat*(ym == startyr + `i') // k = i
}
bysort naics4: replace treat_lagyr6  = iftreat*(ym <= startyr - 6) // grouping if over 6 yrs
bysort naics4: replace treat_leadyr6 = iftreat*(ym >= startyr + 6) 

reg logemplvl treat_lagyr6-treat_lagyr2 treat_startyr treat_leadyr1-treat_leadyr6 i.ym i.naics4
			  
// outreg2 using "regression_results/import_eventstudy.tex", ctitle(OLS) label keep(treat_*) tex(frag) replace /// 
// 	title("Event Study Estimates for Import Tariff on US Employment")

* Save the coefficients and s.e. into a matrix of 17x2
matrix res = J(21,3,.)
matrix rownames res = lagyr6 lagyr5 lagyr4 lagyr3 lagyr2 lagyr1 ///
	                  startyear ///
					  leadyr1 leadyr2 leadyr3 leadyr4 leadyr5 leadyr6
matrix colnames res = coef se k 

forvalues i = 1/5 {
	local j = 7-`i'
	matrix res[`i',1] = _b[treat_lagyr`j']      // save coefficients 
	matrix res[`i',2] = _se[treat_lagyr`j']     // save s.e.
	matrix res[`i',3] = -`j'
}
matrix res[6,1] = 0  // normalized lag1, coefficient = 0
matrix res[6,2] = 0  // normalized lag1, s.e. = 0
matrix res[6,3] = -1 // normalized lag1
matrix res[7,1] = _b[treat_startyr]   
matrix res[7,2] = _se[treat_startyr]
matrix res[7,3] = 0
forval i = 1/6 {
	matrix res[`i'+7,1] = _b[treat_leadyr`i']
	matrix res[`i'+7,2] = _se[treat_leadyr`i']
	matrix res[`i'+7,3] = `i'
}
matlist res

* Graph using the saved matrix
clear
svmat res, names(col)

* calculate confidence intervals
gen ci_upper = coef+1.96*se
gen ci_lower = coef-1.96*se

* Graph
twoway (connected coef k)                      ///  
	   (rcap ci_upper ci_lower k, lc(black))   ///  
	, xlabel(-6(1)6) xtitle("Time to import tariff increase (months)") xline(-0.5, lp(dash))  ///
	  ytit("Coefficients of event study on US log employment") yline(0)  ///	  
	  legend(off) ///
	  graphregion(color(white)) 

* Save graph	
graph export "output_graph/import_eventstudy.svg", replace

///////////////////////////////////////////////////////////////////////////////////
* Event study on employment in manufacture industry
* I have to write everything again because of the nature of Stata (not a Stata fan btw)
clear all

cd "C:\Coding sample" // Change the path to reproduce my results
import delimited "output_data\NAICS4_industry_import.csv"
gen time = date(date, "YMD")
gen ym = mofd(time)
format ym %tm

* We need the following variables:
gen logemplvl = log(emplvl*1000)
gen logCNimport = log(china_import)
gen importROW = total_import - china_import
gen logimportROW = log(importROW)
gen logtotalimport = log(total_import)
gen logtariff = log(1 + weighted_tariff/100)
gen naics4ym = naics4 *100000 + ym

local n = 6
bysort naics4: egen iftreat = max(treatment) //if ever treated

	* double-check: naics4 = 1111
	sort naics4 ym
	browse naics4 ym weighted_tariff iftreat if naics4 == 1111  // 1111

	* Determine the starting years for each treated naics4
bysort naics4: egen startyr = min(ym)   if treatment == 1
bysort naics4: replace startyr = startyr[_N] if startyr == . 
format startyr %tm

* Create startyear, lags and leads on T*I{t=k}
bys naics4: gen treat_startyr = iftreat*(ym == startyr)                // k = 0
forvalues i = 6(-1)1 {
	bysort naics4: gen treat_lagyr`i'  = iftreat*(ym == startyr - `i') // k = -i 
}             
forvalues i = 1/6 {
	bysort naics4: gen treat_leadyr`i' = iftreat*(ym == startyr + `i') // k = i
}
bysort naics4: replace treat_lagyr6  = iftreat*(ym <= startyr - 6) // grouping if over 6 yrs
bysort naics4: replace treat_leadyr6 = iftreat*(ym >= startyr + 6) 

reg logemplvl treat_lagyr6-treat_lagyr2 treat_startyr treat_leadyr1-treat_leadyr6 i.ym i.naics4 if naics2 == 11
			  
// outreg2 using "regression_results/import_eventstudy.tex", ctitle(OLS) label keep(treat_*) tex(frag) replace /// 
// 	title("Event Study Estimates for Import Tariff on US Employment")

* Save the coefficients and s.e. into a matrix of 17x2
matrix res = J(21,3,.)
matrix rownames res = lagyr6 lagyr5 lagyr4 lagyr3 lagyr2 lagyr1 ///
	                  startyear ///
					  leadyr1 leadyr2 leadyr3 leadyr4 leadyr5 leadyr6
matrix colnames res = coef se k 

forvalues i = 1/5 {
	local j = 7-`i'
	matrix res[`i',1] = _b[treat_lagyr`j']      // save coefficients 
	matrix res[`i',2] = _se[treat_lagyr`j']     // save s.e.
	matrix res[`i',3] = -`j'
}
matrix res[6,1] = 0  // normalized lag1, coefficient = 0
matrix res[6,2] = 0  // normalized lag1, s.e. = 0
matrix res[6,3] = -1 // normalized lag1
matrix res[7,1] = _b[treat_startyr]   
matrix res[7,2] = _se[treat_startyr]
matrix res[7,3] = 0
forval i = 1/6 {
	matrix res[`i'+7,1] = _b[treat_leadyr`i']
	matrix res[`i'+7,2] = _se[treat_leadyr`i']
	matrix res[`i'+7,3] = `i'
}
matlist res

* Graph using the saved matrix
clear
svmat res, names(col)

* calculate confidence intervals
gen ci_upper = coef+1.96*se
gen ci_lower = coef-1.96*se

* Graph
twoway (connected coef k)                      ///  
	   (rcap ci_upper ci_lower k, lc(black))   ///  
	, xlabel(-6(1)6) xtitle("Time to import tariff increase (months)") xline(-0.5, lp(dash))  ///
	  ytit("Coefficients of event study on US log employment in agriculture") yline(0)  ///	  
	  legend(off) ///
	  graphregion(color(white)) 

* Save graph	
graph export "output_graph/import_eventstudy_agriculture.svg", replace

///////////////////////////////////////////////////////////////////////////////////
* Event study on employment in agricultural industry
* I have to write everything again because of the nature of Stata (not a Stata fan btw)
clear all

cd "C:\Coding sample" // Change the path to reproduce my results
import delimited "output_data\NAICS4_industry_import.csv"
gen time = date(date, "YMD")
gen ym = mofd(time)
format ym %tm

* We need the following variables:
gen logemplvl = log(emplvl*1000)
gen logCNimport = log(china_import)
gen importROW = total_import - china_import
gen logimportROW = log(importROW)
gen logtotalimport = log(total_import)
gen logtariff = log(1 + weighted_tariff/100)
gen naics4ym = naics4 *100000 + ym

local n = 6
bysort naics4: egen iftreat = max(treatment) //if ever treated

	* double-check: naics4 = 1111
	sort naics4 ym
	browse naics4 ym weighted_tariff iftreat if naics4 == 1111  // 1111

	* Determine the starting years for each treated naics4
bysort naics4: egen startyr = min(ym)   if treatment == 1
bysort naics4: replace startyr = startyr[_N] if startyr == . 
format startyr %tm

* Create startyear, lags and leads on T*I{t=k}
bys naics4: gen treat_startyr = iftreat*(ym == startyr)                // k = 0
forvalues i = 6(-1)1 {
	bysort naics4: gen treat_lagyr`i'  = iftreat*(ym == startyr - `i') // k = -i 
}             
forvalues i = 1/6 {
	bysort naics4: gen treat_leadyr`i' = iftreat*(ym == startyr + `i') // k = i
}
bysort naics4: replace treat_lagyr6  = iftreat*(ym <= startyr - 6) // grouping if over 6 yrs
bysort naics4: replace treat_leadyr6 = iftreat*(ym >= startyr + 6) 

reg logemplvl treat_lagyr6-treat_lagyr2 treat_startyr treat_leadyr1-treat_leadyr6 i.ym i.naics4 if naics2 == 31|naics2 == 32|naics2 == 33
			  
// outreg2 using "regression_results/import_eventstudy.tex", ctitle(OLS) label keep(treat_*) tex(frag) replace /// 
// 	title("Event Study Estimates for Import Tariff on US Employment")

* Save the coefficients and s.e. into a matrix of 17x2
matrix res = J(21,3,.)
matrix rownames res = lagyr6 lagyr5 lagyr4 lagyr3 lagyr2 lagyr1 ///
	                  startyear ///
					  leadyr1 leadyr2 leadyr3 leadyr4 leadyr5 leadyr6
matrix colnames res = coef se k 

forvalues i = 1/5 {
	local j = 7-`i'
	matrix res[`i',1] = _b[treat_lagyr`j']      // save coefficients 
	matrix res[`i',2] = _se[treat_lagyr`j']     // save s.e.
	matrix res[`i',3] = -`j'
}
matrix res[6,1] = 0  // normalized lag1, coefficient = 0
matrix res[6,2] = 0  // normalized lag1, s.e. = 0
matrix res[6,3] = -1 // normalized lag1
matrix res[7,1] = _b[treat_startyr]   
matrix res[7,2] = _se[treat_startyr]
matrix res[7,3] = 0
forval i = 1/6 {
	matrix res[`i'+7,1] = _b[treat_leadyr`i']
	matrix res[`i'+7,2] = _se[treat_leadyr`i']
	matrix res[`i'+7,3] = `i'
}
matlist res

* Graph using the saved matrix
clear
svmat res, names(col)

* calculate confidence intervals
gen ci_upper = coef+1.96*se
gen ci_lower = coef-1.96*se

* Graph
twoway (connected coef k)                      ///  
	   (rcap ci_upper ci_lower k, lc(black))   ///  
	, xlabel(-6(1)6) xtitle("Time to import tariff increase (months)") xline(-0.5, lp(dash))  ///
	  ytit("Coefficients of event study on US log employment in manufacturing") yline(0)  ///	  
	  legend(off) ///
	  graphregion(color(white)) 

* Save graph	
graph export "output_graph/import_eventstudy_manufacture.svg", replace