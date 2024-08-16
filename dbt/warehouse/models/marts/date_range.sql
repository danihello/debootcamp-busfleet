/**
 * Calculates the minimum and maximum trip dates from the `fact_trips` table.
 * This is used to determine the date range for the data in the data warehouse.
 **/
select
    dateadd('day', 1, max(trip_date))::date as end_date,
    min(trip_date) as start_date
from {{ ref('fact_trips') }}
