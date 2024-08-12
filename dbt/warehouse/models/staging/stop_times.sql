/**
 * Selects the trip_id, estimated_arrival_time, stop_id, and stop_sequence from the raw_stop_times table in the GTFS schema.
 * This model is used to stage the stop_times data for further processing.
 */
select
    trip_id,
    arrival_time as estimated_arrival_time,
    stop_id::int as stop_id,
    stop_sequence

from {{ source('GTFS', 'raw_stop_times') }}
