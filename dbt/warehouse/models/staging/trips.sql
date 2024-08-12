/**
 * Selects the relevant trip data from the raw GTFS trips table.
 * The selected columns include:
 * - trip_id: The unique identifier for the trip.
 * - route_id: The identifier for the route the trip belongs to.
 * - service_id: The identifier for the service the trip belongs to.
 * - trip_desc: The description or headsign of the trip.
 * - direction_id: The direction of the trip (0 or 1).
 * - block_id: The identifier for the block the trip belongs to.
 * - shape_id: The identifier for the shape the trip follows.
 */
select 
    trip_id,
    route_id,
    service_id,
    trip_headsign as trip_desc,
    direction_id,
    block_id,
    shape_id
from {{ source('GTFS', 'raw_trips') }}