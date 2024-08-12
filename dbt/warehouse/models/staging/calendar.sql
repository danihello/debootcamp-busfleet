select
    service_id,
    to_date(start_date, 'yyyyMMdd') as start_date,
    to_date(end_date, 'yyyyMMdd') as end_date
from {{ source('GTFS', 'raw_calendar') }}
