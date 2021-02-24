// Jameson Colbert, Data Mgmt, PS3, 24 February 2021
// Dr. Adam Okulicz-Kozaryn

/* For this problem set, I merged COVID data with NJ census data, NJ poverty data, NJ unemployment data, data on contaminated sites in NJ counties, and rates of uninsurance */

cd C:\Users\jhc157

clear
insheet using https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv //NYTimes COVID Data
keep if state == "New Jersey"
replace county = "Atlantic County" if county == "Atlantic"
replace county = "Bergen County" if county == "Bergen"
replace county = "Burlington County" if county == "Burlington"
replace county = "Camden County" if county == "Camden"
replace county = "Cape May County" if county == "Cape May"
replace county = "Cumberland County" if county == "Cumberland"
replace county = "Essex County" if county == "Essex"
replace county = "Gloucester County" if county == "Gloucester"
replace county = "Hudson County" if county == "Hudson"
replace county = "Hunterdon County" if county == "Hunterdon"
replace county = "Mercer County" if county == "Mercer"
replace county = "Middlesex County" if county == "Middlesex"
replace county = "Monmouth County" if county == "Monmouth"
replace county = "Morris County" if county == "Morris"
replace county = "Ocean County" if county == "Ocean"
replace county = "Passaic County" if county == "Passaic"
replace county = "Salem County" if county == "Salem"
replace county = "Somerset County" if county == "Somerset"
replace county = "Sussex County" if county == "Sussex"
replace county = "Union County" if county == "Union"
replace county = "Warren County" if county == "Warren"
collapse cases deaths, by(county)
keep if county == "Atlantic County" | county == "Bergen County" | county == "Burlington County" | county == "Camden County" | county == "Cape May County" | county == "Cumberland County" | county == "Essex County" | county == "Gloucester County" | county == "Hudson County" | county == "Hunterdon County" | county == "Mercer County" | county == "Middlesex County" | county == "Monmouth County" | county == "Morris County" | county == "Ocean County" | county == "Passaic County" | county == "Salem County" | county == "Somerset County" | county == "Sussex County" | county == "Union County" | county == "Warren County"
l
save NJCovidCasesAndDeathsByCountyB.dta

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/co-est2019-alldata_CLEANED_UP_2.csv //Census data
keep if stname == "New Jersey"
l
save NJCensusPop2019B.dta

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/NJpoverty2019B.csv
save NJPoverty2019.dta

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/NJPercBelowPov2019.csv
save NJPovertyPerc2019.dta

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/2020countyhealthuninsuredRWJ.csv
drop uninsurednumber
save NJUninsuredPercent.dta

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/NJActiveContamSites2020.csv
save NJContamSites.dta

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/NJpoverty2019B.csv
drop pop
save NJBelowPov.dta

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/USDAunemp%26medianhouseholdinc_NJ2019.csv
drop civilian_labor_force_2019
drop employed_2019
drop unemployed_2019
drop median_household_income_2019
drop med_hh_income_percent_of_state_t
l
save NJUnemployment2019.dta

clear
use C:\Users\jhc157\NJCovidCasesAndDeathsByCountyB.dta
desc
use NJCensusPop2019B.dta, clear // master
desc
drop county
rename ctyname county
drop state 
rename stname state 
merge 1:m county using NJCovidCasesAndDeathsByCountyB.dta 
drop _merge
merge m:1 county using NJBelowPov.dta
drop _merge
merge m:1 county using NJPovertyPerc2019.dta
drop _merge
merge m:1 county using NJUninsuredPercent.dta
drop _merge
merge m:1 county using NJUnemployment2019
drop _merge
merge m:1 county using NJContamSites.dta 
tab _merge
tab county
desc _merge
l

drop _merge
reshape wide cases, i(uninsured) j(deaths) //reshape giving me lots of trouble
