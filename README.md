# RTI USAID Forecast Alerter

This is a simple application to alert changes in items on the USAID Business Forecast:

  - [https://www.usaid.gov/business-forecast/search](https://www.usaid.gov/business-forecast/search) - Search age
  - [https://www.usaid.gov/sites/default/files/business_forecast/usaid-business-forecast.xls](https://www.usaid.gov/sites/default/files/business_forecast/usaid-business-forecast.xls) - Excel version of the forecast

## Model

  - `User` A user to be notified of changes
    - *id* - integer - DB ID
    - *email* - text - Email address of user
  - `Snapshot` A capture of the Forecast data
    - *id* - integer - DB ID
    - *forecast_workbook* - blob - forecast excel workbook
    - *forecast_web* - text - content of forecast search results
    - *changes* - json - list of changes

## Process

  1. Download Forecast Workbook and Forecast Web from a new Snapshot
  2. Iterate over awards in workbook and:
    a. Find `usaid_web_id` in the web snapshot
    b. Create or update existing awards and return changed fields
    c. If award isn't in forecast workbook anymore, mark removed date and return removed
  3. Send summary of changes in snapshot to users