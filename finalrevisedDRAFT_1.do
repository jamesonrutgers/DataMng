// Jameson Colbert, Data Mgmt, Final, 28 April 2021
// 5 May 2021 REVISION
// Dr. Adam Okulicz-Kozaryn

/* 
My research into COVID in the Mid-Atlantic primarily looks into the possible
correlations between COVID cases (and deaths) with race, population, and poverty.
I find that the strongest correlation between Covid cases and deaths is population,
and particularly population density (although pop density merge is giving me some
new trouble, trouble which I had not had in previous problem sets). However,
there is some correlation with race, more so than poverty. I have found areas with
both high population as well as high proportions of black people tend to see
the highest covid numbers.
For the final, I have added data from several large counties across the United
States, including Los Angeles, Harris (Houston), Dallas, Bexar (San Antonio), and
Miami-Dade Counties. I find that targeting large, diverse counties has both benefits
and drawbacks to the research.
On one hand, large counties provide ample opportunities to research correlations
between race, poverty, and COVID deaths and cases. However, large counties may
obscure some important information. For instance, it is difficult to understand
whether COVID cases and mortality are correlated more with population/pop. density
or race and poverty. This is why I also wanted to look at low-pop counties with
high poverty rates, such as Cumberland, NJ. 
For this final, I have added high-poverty, low-population majority
black counties, such as those in Mississippi and Louisiana. However, for May 3,
I want to compare these counties to majority white counties with VERY similar
populations, not just approximated.
Problems remaining that need to be rectified for the May 3rd submission:
- Issues with population density (may just drop)
- Repetition. Have experimented with loops but need more work on them.
*/


clear
cd C:\Users\jhc157

insheet using https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv //NYTimes Github data, names 
// source: https://github.com/nytimes/covid-19-data
keep if state == "Pennsylvania" | state == "New Jersey" | state == "New York"
gen county2 = county + ", " + state
drop state county
rename county2 county
collapse cases deaths, by (county)

l
save NJ_PA_NY_CovidCasesAndDeathsByCounty.dta, replace 

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/DataMng/main/co-est2019-alldata.csv //Census data
keep if stname == "New Jersey" | stname == "Pennsylvania" | stname == "New York"
gen county2 = county + ", " + state
drop stname ctyname
drop county
rename county2 county
keep county* popestimate2019*
l
save NJ_PA_NY_CensusPop2019B.dta, replace
// data sourced from US Census

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/ACSST5Y2019.S1701_data_with_overlays_2021-03-02T224230.csv
// source: https://data.census.gov/cedsci/table?t=Income%20and%20Poverty&g=0400000US34.050000&y=2019&tid=ACSST5Y2019.S1701&hidePreview=true&tp=true
drop v1
rename v2 county
gen county2 = county + ", " + state

rename v125 belowpov
rename v247 percBelowpov
keep county* belowpov* percBelowpov*
l
save NJPoverty2019.dta, replace
// NJ poverty data. data sourced from US Census

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/2020%20County%20Health%20Rankings%20New%20Jersey%20Data%20-%20v1_0%20-%20RAW_B.csv
// source: https://www.countyhealthrankings.org/app/new-jersey/2020/downloads
rename v3 county
rename v2 state
gen county2 = county + ", " + state
drop state county
rename county2 county

rename v136 uninsPerc

keep county* uninsPerc*
replace county = "" if county == "CountyState"
replace uninsPerc = "" if uninsPerc == "% Uninsured" 
replace uninsPerc = "" if uninsPerc == "11"
save NJUninsuredPercent.dta, replace
// Rates of uninsured persons. data sourced from https://www.countyhealthrankings.org/app/new-jersey/2020/overview

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/Unemployment-RAW.csv
// source: https://data.census.gov/cedsci/table?t=Employment&g=0400000US34.050000&y=2019&tid=ACSST5Y2019.S2301&hidePreview=true&tp=true
keep if v2 == "NJ" | v2 == "PA" | v2 == "NY" //v2 being the state abbreviation
rename v3 county
gen county2 = county + ", " + state
rename v86 unempRate2019
keep county* unempRate2019*
l
save NJ_PA_NY_Unemployment2019.dta, replace 
// data on unemployment. data sourced from https://www.ers.usda.gov/data-products/county-level-data-sets/download-data/ 

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/NJ_PA_NY_Pop2019_Census.csv //Census data
// source: https://data.census.gov/cedsci/table?t=Populations%20and%20People&g=0400000US34.050000,36.050000,42.050000&y=2019&tid=ACSDT5Y2019.B01003&hidePreview=true&tp=true
drop v1
rename v2 county
gen county2 = county + ", " + state
rename v3 population
keep county population
save NJ_PA_NY_Pop2019census.dta, replace

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/NJ_PA_NY_Poverty2019census.csv //Census data
// source: https://data.census.gov/cedsci/table?t=Income%20and%20Poverty&g=0400000US34.050000,36.050000,42.050000&y=2019&tid=ACSST5Y2019.S1701&hidePreview=true&tp=true
drop v1
rename v2 county
gen county2 = county + ", " + state
rename v125 Popbelowpov
rename v247 Percbelowpov
keep county Popbelowpov Percbelowpov

save NJ_PA_NY_Poverty2019census.dta, replace

clear
insheet using https://raw.githubusercontent.com/camillol/cs424p3/master/data/Population-Density%20By%20County.csv //pop density by Github user camillol
// source: https://github.com/camillol/cs424p3/blob/master/data/Population-Density%20By%20County.csv
keep if geodisplaylabel == "Pennsylvania" | geodisplaylabel == "New Jersey" | geodisplaylabel == "New York"
rename gct_stubdisplaylabel county
gen county2 = county + ", " + geodisplaylabel
drop county
rename county2 county
replace county = subinstr(county, "CountyNew Jersey",", New Jersey", .)
replace county = subinstr(county, "CountyNew York",", New York", .)
replace county = subinstr(county, "CountyPennsylvania",", Pennsylvania", .)
replace county = subinstr(county," , New Jersey",", New Jersey",.)
replace county = subinstr(county," , Pennsylvania",", Pennyslvania",.)
replace county = subinstr(county," , New York",", New York",.)

rename densitypersquaremileoflandarea popdensitysqmi
keep county popdensitysqmi
save NJ_PA_NY_PopDensity.dta, replace

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/ACSDT5Y2019.B02001_data_with_overlays_2021-04-07T164844.csv
// source: https://data.census.gov/cedsci/table?t=Race%20and%20Ethnicity&g=0400000US34.050000,36.050000,42.050000&y=2019&tid=ACSDT5Y2019.B02001&hidePreview=true&tp=true
drop v1
rename v2 county
replace county = subinstr(county, " County, New Jersey",", New Jersey", .)
replace county = subinstr(county, " County, New York",", New York", .)
replace county = subinstr(county, " County, Pennsylvania",", Pennsylvania", .)
rename v5 white
rename v7 black
rename v9 indigenous
rename v11 asian
keep county* white* black* indigenous* asian*

save NJ_PA_NY_race.dta, replace

// Merging

clear
use NJ_PA_NY_CovidCasesAndDeathsByCounty.dta, clear // master
desc
merge 1:1 county using NJ_PA_NY_Pop2019census.dta //merge 1
drop _merge
save NJ_PA_NY_CovidAndPop.dta, replace

clear
use NJ_PA_NY_Poverty2019census.dta
merge 1:1 county using NJ_PA_NY_CovidAndPop.dta
l
drop _merge
save NJ_PA_NY_CovidPopPoverty.dta, replace

clear
use NJ_PA_NY_CovidPopPoverty.dta
merge 1:1 county using NJ_PA_NY_race.dta
l
drop _merge
save NJ_PA_NY_CovidPopRace.dta, replace

/* Two merges below giving me lots of issues, lots of unmatches, will have to
look further into this */

clear
use NJ_PA_NY_Unemployment2019.dta
merge 1:1 county using NJ_PA_NY_CovidPopRace.dta
l
save NJ_PA_NY_CovidPopRaceUnempETC.dta

clear
use NJ_PA_NY_PopDensity.dta
merge 1:1 county using NJ_PA_NY_CovidPopRace.dta
drop _merge
save NJ_PA_NY_CovidPopPovertyDensity.dta, replace 

//Graphing using NJ_PA_NY_CovidPopRace//

/* as written above, it seems the strongest correlation is that of population, but
from literature and recent news, it is worth exploring race as a factor in covid
severity, which I attempt to do. I use a selection of urban and suburban counties
in Pennsylvania and New Jersey. 
I have included larger counties below, such as Los Angeles and Houston counties, which
have large numbers of black residents, but it may be more illucidating in terms
of analyzing correlations to include counties such as Washington, MS, and comparing
them to majority white, high poverty, low pop counties in the south and elsewhere (such as Cumberland NJ)
I have also added Louisiana's "Cancer Alley" as well.
*/

clear
use NJ_PA_NY_CovidPopRace.dta
destring black, gen(black2) force
destring population, gen(population2) force
keep if county == "Allegheny, Pennsylvania" | county == "Philadelphia, Pennsylvania" | county == "Montgomery, Pennsylvania" 
graph hbar cases black2 population2, over(county)
scatter cases black2, mlabel(county)
scatter cases population2, mlabel(county)

use NJ_PA_NY_CovidPopRace.dta
destring black, gen(black2) force
destring white, gen(white2) force
destring population, gen(population2) force
keep if county == "Allegheny, Pennsylvania" | county == "Philadelphia, Pennsylvania" | county == "Montgomery, Pennsylvania" | county == "Essex, New Jersey" | county == "Mercer, New Jersey"
scatter white2 deaths, mlabel(county)
scatter black2 deaths, mlabel(county)

/* I still have to reconfigure the data in order to most accurately analyze race
and mortality risk, as I don't believe I'm quite "there" yet to analyze it fully.
In other words, more data, perhaps on racial percentages rather than raw numbers,
may be needed */

use NJ_PA_NY_CovidPopRace.dta
destring Percbelowpov, gen(povperc2) force
destring Popbelowpov, gen(pov) force
keep if county == "Allegheny, Pennsylvania" | county == "Philadelphia, Pennsylvania" | county == "Montgomery, Pennsylvania" | county == "Essex, New Jersey" | county == "Mercer, New Jersey"
scatter cases pov, mlabel(county)
scatter cases povperc2, mlabel(county)
scatter deaths pov, mlabel(county)
scatter deaths povperc2, mlabel(county)

/* Introducing different counties */
clear
insheet using https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv //NYTimes Github data, names 
keep if state == "Texas" | state == "Florida" | state == "California"
keep if county == "Los Angeles" | county == "Harris" | county == "Dallas" | county == "Bexar" | county == "Miami-Dade" 
collapse cases deaths, by (county)
save CA_FL_TX_COVID.dta, replace

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/ACSDT5Y2019.B02001_data_with_overlays_2021-04-28T131518.csv
// source: https://data.census.gov/cedsci/table?t=Race%20and%20Ethnicity&g=0400000US06.050000,12.050000,48.050000&y=2019&tid=ACSDT5Y2019.B02001&hidePreview=true&tp=true
drop v1 v20 v21 v22
keep v2* v3* v5* v7* v9* v11*
rename v2 county
rename v3 pop
rename v5 white
rename v7 black
rename v9 indigenous
rename v11 asian
replace county = subinstr(county,"County, Texas","", .)
replace county = subinstr(county,"County, California","", .)
replace county = subinstr(county,"County, Florida","", .)
replace county = subinstr(county," ","", .)
replace county = "Los Angeles" in 3
save CA_FL_TX_Race.dta, replace 

use CA_FL_TX_COVID.dta
merge 1:1 county using CA_FL_TX_Race.dta
drop _merge
save CA_FL_TX_COV_RACE.dta, replace

clear
use CA_FL_TX_COV_RACE.dta
destring black, gen(black2) force
destring white, gen(white2) force
scatter cases black2, mlabel(county)
scatter deaths black2, mlabel(county) //use graph combine, look at multiple factors at once

/* Municipal Data */

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/EssexCountyMunicCOVID.csv
// from https://essexcountynj.org/covid-19-municipality/
replace munic = subinstr(munic," ","", .)
l
save EssexCountyCOVID.dta, replace 

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/ACSDT5Y2019.B02001_data_with_overlays_2021-04-28T151712.csv
// from https://data.census.gov/cedsci/table?t=Race%20and%20Ethnicity&g=0500000US34013.060000&y=2019&tid=ACSDT5Y2019.B02001&hidePreview=true&tp=true
drop v1 v20 v21 v22
keep v2* v3* v5* v7* v9* v11*
rename v3 pop
rename v5 white
rename v7 black
rename v9 indigenous
rename v11 asian
rename v2 munic
replace munic = subinstr(munic,"Village township, Essex County, New Jersey","", .)
replace munic = subinstr(munic,"township, Essex County, New Jersey","", .)
replace munic = subinstr(munic,"city, Essex County, New Jersey","", .)
replace munic = subinstr(munic,"borough, Essex County, New Jersey","", .)
replace munic = "Orange " in 7
replace munic = subinstr(munic," ","", .)
save EssexCountyRace.dta, replace 

use EssexCountyCOVID.dta
merge 1:1 munic using EssexCountyRace.dta
drop _merge
save EssexCountyCOV_Race.dta, replace

destring black, gen(black2) force
destring white, gen(white2) force
scatter cases black2, mlabel(munic)
scatter deaths black2, mlabel(munic)
destring pop, gen(pop2) force
scatter pop2 deaths, mlabel(munic)

// Analyzing low-pop, high poverty, maj black counties
clear
insheet using https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv //NYTimes Github data, names 
keep if state == "Mississippi" | state == "New Jersey" 
gen county2 = county + state
drop state county
rename county2 county
collapse cases deaths, by (county)
keep if county ==  "WashingtonMississippi" | county == "CumberlandNew Jersey" | county == "WarrenNew Jersey"
replace county = subinstr(county,"Mississippi",", Mississippi", .)
replace county = subinstr(county,"New Jersey",", New Jersey", .)
save NJ_MS_COVID.dta, replace

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/My-Problem-Sets/main/ACSDT5Y2019.B02001_data_with_overlays_2021-04-28T171026.csv
// source: https://data.census.gov/cedsci/table?t=Race%20and%20Ethnicity&g=0500000US28151,34011,34041&y=2019&tid=ACSDT5Y2019.B02001&hidePreview=true&tp=true
drop v1 v20 v21 v22
keep v2* v3* v5* v7* v9* v11*
rename v3 pop
rename v5 white
rename v7 black
rename v9 indigenous
rename v11 asian
rename v2 county
replace county = subinstr(county,"County, Mississippi",", Mississippi", .)
replace county = subinstr(county,"County, New Jersey", ", New Jersey", .)
replace county = subinstr(county," , Mississippi",", Mississippi", .)
replace county = subinstr(county," , New Jersey", ", New Jersey", .)
save NJ_MS_Race.dta, replace

clear
use NJ_MS_COVID.dta
merge 1:1 county using NJ_MS_Race.dta
drop _merge
save NJ_MS_COV_Race.dta, replace

graph hbar cases deaths, over(county)

use NJ_MS_COV_Race.dta
destring black, gen(black2) force
destring white, gen(white2) force
scatter cases black2, mlabel(county)
scatter deaths black2, mlabel(county)
destring pop, gen(pop2) force
scatter pop2 deaths, mlabel(county)
replace pop2 = pop2/1000
replace black2 = black2/1000
replace white2 = white2/1000


graph hbar deaths black2 white2, over(county)

/* For May 3rd, should compare Washington, MS to counties in the south with
VERY similar populations, rather than approximately similar. */

/* Below I take a look at Louisiana's Cancer Alley, an area of majority-black
parishes in the state where there is a high number of industrial and chemical
activity */

clear
insheet using https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv //NYTimes Github data, names 
keep if state == "Louisiana"
gen county2 = county + state
drop state county
rename county2 county
collapse cases deaths, by (county)
keep if county == "St. CharlesLouisiana" | county == "St. JamesLouisiana" | county == "St. John the BaptistLouisiana" 
replace county = subinstr(county,"Louisiana",", Louisiana", .)
save LA_COVID.dta, replace

clear
insheet using https://raw.githubusercontent.com/jamesonrutgers/Raw-data/main/ACSDT5Y2019.B02001_data_with_overlays_2021-04-28T172625.csv
// source: https://data.census.gov/cedsci/table?t=Race%20and%20Ethnicity&g=0500000US22089,22093,22095&y=2019&tid=ACSDT5Y2019.B02001&hidePreview=true&tp=true
drop v1 v20 v21 v22
keep v2* v3* v5* v7* v9* v11*
rename v3 pop
rename v5 white
rename v7 black
rename v9 indigenous
rename v11 asian
rename v2 county
replace county = subinstr(county,"Parish, Louisiana",", Louisiana", .)
replace county = subinstr(county," , Louisiana",", Louisiana", .)
save LA_Race.dta, replace

clear
use LA_COVID.dta
merge 1:1 county using LA_Race.dta
drop _merge
save LA_COV_Race.dta, replace

destring black, gen(black2) force
destring white, gen(white2) force
graph hbar black2 white2 deaths, over(county) //express pop as thousands or mill, also graph combine
replace pop2 = pop2/1000

clear
use LA_COV_Race.dta
merge 1:1 county using NJ_MS_COV_Race.dta
drop _merge
save LA_NJ_MS_COV_Race.dta, replace

destring black, gen(black2) force
destring white, gen(white2) force
graph hbar black2 white2 deaths, over(county)

// Would be more helpful to include percentages of black, white, etc.

/*regress cases and deaths on pov and race. google ucla stata webbook for help
on regression */

// graph covid over time using nytimes data in a select number of counties
