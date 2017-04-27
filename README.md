# RTI USAID Forecast Alerter

This is a simple application to alert changes in items on the USAID Business Forecast:

  - [https://www.usaid.gov/business-forecast/search](https://www.usaid.gov/business-forecast/search) - Search age
  - [https://www.usaid.gov/sites/default/files/business_forecast/usaid-business-forecast.xls](https://www.usaid.gov/sites/default/files/business_forecast/usaid-business-forecast.xls) - Excel version of the forecast

## Model

  - `Award` An item in the USAID forecast
    - *id* - integer - DB ID
    - *usaid_web_id* - string - Internal USAID web ID (ID on URL)
    - *mbio_name* - text -  M/B/IO Name
    - *aa_specialist* - text - A&A Specialist
    - *title* - text - Award Title
    - *description* - text - Award Description
    - *sector* - text - Sector
    - *code* - string - Code
    - *cost_range* - string - Total Estimated Cost/Amount Range
    - *incumbent* - text - Incumbent
    - *type* - string - Award/Action Type
    - *sb_setaside* - string - Small Business Set Aside
    - *fiscal_year* - string - Fiscal Year of Action
    - *award_date* - date - Anticipated Award Date
    - *release_date* - date - Anticipated Solicitation Release Date
    - *award_length* - string - Award Length
    - *solicitation_number* - string - Solicitation Number
    - *bf_status_change* - text - Business Forecast Status Change
    - *location* - string - Location
    - *last_modified_at* - datetime - Last Modified Date
    - *removed_at* - datetime - Removal detected date
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