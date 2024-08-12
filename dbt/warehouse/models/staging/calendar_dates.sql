select 
    service_id,
    to_date(date,'yyyyMMdd') as date
from {{ source('GTFS', 'raw_calendar_dates') }}
where exception_type = 1