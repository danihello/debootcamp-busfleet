/**
 * Selects the stop ID, name, latitude, and longitude from the raw GTFS stops table.
 * This model is used to stage the raw GTFS stops data for further transformation.
 **/
select
    stop_id::int as stop_id,
    stop_name,
    stop_lat as stop_latitude,
    stop_lon as stop_longitude
from {{ source('GTFS', 'raw_stops') }}
