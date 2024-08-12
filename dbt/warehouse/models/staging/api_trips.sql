--This SQL query creates a staging table for API trip data. 
--It selects only the start and end records for each trip, and extracts relevant fields such as trip ID, route ID, 
--trip date, start and end datetimes, distance traveled, passenger counts, vehicle ID, start and end stop IDs, start and end coordinates, direction ID, and agency ID.

--The query also includes a post-hook that creates a separate table `last_trip_date_per_bus` which stores the maximum trip end date for each vehicle.
{{
    config(
        post_hook="create or replace table {{ this.schema }}.last_trip_date_per_bus as select vehicle_id,max(trip_end_datetime)::datetime as max_end_date from {{this}} group by vehicle_id;",
    )
}}

with trans_only_start_and_end as (
    select
        trip_id,
        date as trip_date,
        recorded_datetime as trip_end_datetime,
        distance_traveled,
        vehicle_id,
        trip_avg_psngr_count,
        trip_max_psngr_capacity,
        latitude as end_latitude,
        longitude as end_longitude,
        direction_id,
        agency_id,
        current_stop_id as end_stop_id,
        route_id,
        trip_end,
        trip_start,
        lag(recorded_datetime) over (partition by vehicle_id order by recorded_datetime) as trip_start_datetime,
        lag(latitude) over (partition by vehicle_id order by recorded_datetime) as start_latitude,
        lag(longitude) over (partition by vehicle_id order by recorded_datetime) as start_longitude,
        lag(current_stop_id) over (partition by vehicle_id order by recorded_datetime) as start_stop_id
    from {{ ref('trans') }}
    where (trip_start = 1 or trip_end = 1)
)

select
    trip_id,
    route_id,
    trip_date,
    trip_start_datetime,
    trip_end_datetime,
    distance_traveled,
    trip_avg_psngr_count,
    trip_max_psngr_capacity,
    vehicle_id,
    start_stop_id,
    end_stop_id,
    start_latitude,
    start_longitude,
    end_latitude,
    end_longitude,
    direction_id,
    agency_id
from trans_only_start_and_end
where trip_end = 1
