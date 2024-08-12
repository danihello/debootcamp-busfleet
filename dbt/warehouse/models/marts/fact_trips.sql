--This model creates a fact table for trips, with various metrics and dimensions related to each trip. 
--It is configured to be an incremental model, using the `trip_key` column as the unique key and a merge strategy for incremental updates.

--The model selects data from the `api_trips` table, 
--filtering out trips that are less than 60 seconds long or have an average speed greater than 100 km/h. 
--It generates a surrogate key for each trip using the `vehicle_id` and `trip_start_datetime` columns
-- and calculates various trip-related metrics such as duration, speed, and passenger count.

--The model is designed to be incrementally updated, only loading new trips 
--that have a `trip_start_datetime` greater than the maximum `trip_end_datetime` in the existing data.
{{
    config(
        materialized = "incremental",
        unique_key = "trip_key",
        incremental_strategy = "merge"
    )
}}


select
    {{ dbt_utils.generate_surrogate_key(["vehicle_id || '-' || trip_start_datetime"]) }} as trip_key,
    trip_id,
    route_id,
    trip_date,
    trip_start_datetime,
    trip_end_datetime,
    datediff(second,trip_start_datetime, trip_end_datetime) as trip_duration_seconds,
    distance_traveled,
    distance_traveled * 3.6 / datediff(second,trip_start_datetime, trip_end_datetime) as trip_speed_kmh,
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

from {{ref('api_trips')}} as trips
where datediff(second,trip_start_datetime, trip_end_datetime) > 60
and distance_traveled * 3.6 / datediff(second,trip_start_datetime, trip_end_datetime) < 100
{% if is_incremental() %}
and trip_start_datetime > (select max(trip_end_datetime) from {{this}})
{% endif %}