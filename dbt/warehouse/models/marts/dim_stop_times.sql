/**
 * This query joins the `stop_times` and `dim_trips` tables to create a dimension table for stop times. The key features of this query are:
 *
 * - It generates a surrogate key `trip_key` using the `dbt_utils.generate_surrogate_key` function, which combines the `agency_id` and `trip_id` columns.
 * - It selects the `trip_id`, `estimated_arrival_time`, `stop_id`, and `stop_sequence` columns.
 * - It performs an inner join between the `stop_times` and `dim_trips` tables on the `trip_id` column.
 *
 * This dimension table can be used to provide detailed information about the stop times for each trip in the data warehouse.
 */
select
    {{ dbt_utils.generate_surrogate_key(["dim_trips.agency_id || '_' || stop_times.trip_id"]) }} as trip_key,
    dim_trips.agency_id || '_' || stop_times.trip_id as trip_id,
    estimated_arrival_time,
    stop_id,
    stop_sequence

from {{ ref('stop_times') }} as stop_times
inner join {{ ref('dim_trips') }} as dim_trips
    on stop_times.trip_id = dim_trips.original_trip_id
