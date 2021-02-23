// Jameson Colbert, Data Mgmt, PS2, 17 Feb 2021: Updated 18 Feb 2021
// Dr. Adam Okulicz-Kozaryn
// MERGING

/* For this problem set, I merged COVID data with NJ census data, in an effort to see how NJ looked when it came to COVID. 
The merging was successful and allowed me to look at NJ county COVID data along with population numbers. Will be useful for my later PS, such as those including poverty numbers. 
Also ran generating, encoding, recoding, replacing, collapsing, drop, bys, and egen */

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
save NJCovidCases.dta

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/co-est2019-alldata.csv //Census data
keep if stname == "New Jersey"
save NJCensusPop.dta 

clear
use C:\Users\jhc157\NJCovidCases.dta
desc
use NJcensusPop.dta, clear // master
desc
drop county
rename ctyname county
drop state 
rename stname state 
merge 1:m county using NJCovidCases.dta 
tab _merge // not matched: 0 matched: 22  
tab county
desc _merge
l
desc _merge, detail
