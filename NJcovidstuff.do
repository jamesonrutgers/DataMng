insheet using https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv
desc
tab date
desc
tab state
keep if state == "New Jersey"
desc
tab state
