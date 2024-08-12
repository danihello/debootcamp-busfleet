/**
 * Calculates the minimum and maximum trip dates from the `fact_trips` table.
 * This is used to determine the date range for the data in the data warehouse.
 **/
select
    min(trip_date) as start_date,
    max(trip_date) as end_date
from {{ ref('fact_trips') }}
