# RTI USAID Forecast Alerter

This is a simple application to alert changes in online documents:

  - [https://www.usaid.gov/business-forecast/search](https://www.usaid.gov/business-forecast/search) - USAID Forecast Search page
  - [https://www.usaid.gov/sites/default/files/business_forecast/usaid-business-forecast.xls](https://www.usaid.gov/sites/default/files/business_forecast/usaid-business-forecast.xls) - Excel version of the forecast
  - [https://www.grants.gov/grantsws/rest/opportunities/search/](https://www.grants.gov/grantsws/rest/opportunities/search/) - Grants.gov search page

## Model

  - `Snapshot` A capture of the Forecast data from the USAID business forecast search
    - *id* - integer - DB ID
    - *forecast_workbook* - blob - forecast excel workbook
    - *forecast_web* - text - content of forecast search results
  - `GrantsSnapshot` A capture of the Forecast data from the Grants.gov online search
    - *id* - integer - DB ID
    - *grantsgov_web* - text - content of forecast search results

## Process

  1. Download the online document from a new Snapshot
  2. Iterate over the record and:
    a. Find `id` in the web snapshot
    b. Create or update existing awards and return changed fields
    c. If award isn't in forecast workbook anymore, mark removed date and return removed
  3. Send summary of changes in snapshot to designated email address.

