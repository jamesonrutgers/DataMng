// Jameson Colbert, Data Mgmt, PS3 REVISED, 24 February 2021 (rev. 3 March 2021)
// Dr. Adam Okulicz-Kozaryn

/* For this problem set, I merged COVID data with NJ census data, NJ poverty data 
(both raw poverty numbers and percentages), NJ unemployment data, data on contaminated 
sites in NJ counties, and rates of 
uninsurance. My hypothesis would be that counties with greater poverty rates and signs
of socioeconomic distress (unemployment and lack of health insurance)
would see higher mean deaths/cases from COVID. After the merge, I am noticing some 
correlation between poverty rates and pandemic deaths, however this can be attr-
ibuted to population and population density. An example would be Bergen County,
a wealthy suburb of New York with low poverty rate but high mean cases and 
deaths from COVID. It is New Jersey's most populated county with nearly 1 million
residents. Another example is Cumberland county, one of NJ's poorest but least 
populated counties. It has a low mean case and death rate.
Future research should include population density numbers by county as
well as information on health rankings by county.
Reshape was difficult.
*/

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
l
save NJCovidCasesAndDeathsByCountyB.dta
// data sourced the NYTimes Github

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/co-est2019-alldata.csv //Census data
keep if stname == "New Jersey"
keep ctyname* popestimate2019*
rename ctyname county
l
save NJCensusPop2019B.dta, replace
// data sourced from US Census

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/ACSST5Y2019.S1701_data_with_overlays_2021-03-02T224230.csv
drop v1
rename v2 county
replace county = "Atlantic County" if county == "Atlantic County, New Jersey"
replace county = "Bergen County" if county == "Bergen County, New Jersey"
replace county = "Burlington County" if county == "Burlington County, New Jersey"
replace county = "Camden County" if county == "Camden County, New Jersey"
replace county = "Cape May County" if county == "Cape May County, New Jersey"
replace county = "Cumberland County" if county == "Cumberland County, New Jersey"
replace county = "Essex County" if county == "Essex County, New Jersey"
replace county = "Gloucester County" if county == "Gloucester County, New Jersey"
replace county = "Hudson County" if county == "Hudson County, New Jersey"
replace county = "Hunterdon County" if county == "Hunterdon County, New Jersey"
replace county = "Mercer County" if county == "Mercer County, New Jersey"
replace county = "Middlesex County" if county == "Middlesex County, New Jersey"
replace county = "Monmouth County" if county == "Monmouth County, New Jersey"
replace county = "Morris County" if county == "Morris County, New Jersey"
replace county = "Ocean County" if county == "Ocean County, New Jersey"
replace county = "Passaic County" if county == "Passaic County, New Jersey"
replace county = "Salem County" if county == "Salem County, New Jersey"
replace county = "Somerset County" if county == "Somerset County, New Jersey"
replace county = "Sussex County" if county == "Sussex County, New Jersey"
replace county = "Union County" if county == "Union County, New Jersey"
replace county = "Warren County" if county == "Warren County, New Jersey"
rename v125 belowpov
rename v247 percBelowpov
keep county* belowpov* percBelowpov*
l
save NJPoverty2019.dta
// NJ poverty data. data sourced from US Census


clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/2020%20County%20Health%20Rankings%20New%20Jersey%20Data%20-%20v1_0%20-%20RAW_B.csv
rename v3 county
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
rename v136 uninsPerc
replace county = "" in 2
replace uninsPerc = "" in 2
replace uninsPerc = "" in 3
keep county* uninsPerc*
save NJUninsuredPercent.dta, replace
// Rates of uninsured persons. data sourced from https://www.countyhealthrankings.org/app/new-jersey/2020/overview

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/NJActiveContamSites2020.csv
save NJContamSites.dta
// Data on contaminated sites in NJ by county. data sourced from https://www.state.nj.us/dep/srp/kcsnj/ 

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/Unemployment-RAW.csv
keep if v2 == "NJ" //v2 being the state abbreviation
rename v3 county
replace county = "Atlantic County" if county == "Atlantic County, NJ"
replace county = "Bergen County" if county == "Bergen County, NJ"
replace county = "Burlington County" if county == "Burlington County, NJ"
replace county = "Camden County" if county == "Camden County, NJ"
replace county = "Cape May County" if county == "Cape May County, NJ"
replace county = "Cumberland County" if county == "Cumberland County, NJ"
replace county = "Essex County" if county == "Essex County, NJ"
replace county = "Gloucester County" if county == "Gloucester County, NJ"
replace county = "Hudson County" if county == "Hudson County, NJ"
replace county = "Hunterdon County" if county == "Hunterdon County, NJ"
replace county = "Mercer County" if county == "Mercer County, NJ"
replace county = "Middlesex County" if county == "Middlesex County, NJ"
replace county = "Monmouth County" if county == "Monmouth County, NJ"
replace county = "Morris County" if county == "Morris County, NJ"
replace county = "Ocean County" if county == "Ocean County, NJ"
replace county = "Passaic County" if county == "Passaic County, NJ"
replace county = "Salem County" if county == "Salem County, NJ"
replace county = "Somerset County" if county == "Somerset County, NJ"
replace county = "Sussex County" if county == "Sussex County, NJ"
replace county = "Union County" if county == "Union County, NJ"
replace county = "Warren County" if county == "Warren County, NJ"
rename v86 unempRate2019
keep county* unempRate2019*
l
save NJUnemployment2019.dta, replace 
// data on unemployment. data sourced from https://www.ers.usda.gov/data-products/county-level-data-sets/download-data/ 

clear
use NJCensusPop2019B.dta, clear // master
desc
merge 1:1 county using NJCovidCasesAndDeathsByCountyB.dta 
drop _merge
merge 1:1 county using NJPoverty2019.dta
drop _merge
merge 1:1 county using NJUninsuredPercentB.dta
drop _merge
merge 1:1 county using NJUnemployment2019
drop _merge
merge 1:1 county using NJContamSites.dta 
tab _merge
tab county
desc _merge
replace county = "" if county == "Geographic Area Name" 
replace county = "" if county == "NAME"
replace belowpov = "" if belowpov == "Estimate!!Below poverty level!!Population for whom poverty status is determined"
replace percBelowpov = "" if percBelowpov == "Estimate!!Percent below poverty level!!Population for whom poverty status is determined"
replace belowpov = "" if belowpov == "S1701_C02_001E"
replace percBelowpov = "" if percBelowpov == "S1701_C03_001E"
l

drop _merge
drop state
help reshape
reshape wide cases, i(census2010pop) j(popestimate2019) //reshape giving me lots of trouble. Not very sensible!
reshape long

clear
// merge again
reshape wide activesiteswithconfirmedcontamin, i(census2010pop) j(popestimate2019
