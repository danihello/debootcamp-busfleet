/**
 * Selects the route information from the raw_routes table in the GTFS schema.
 * The selected columns include:
 * - route_id: The unique identifier for the route.
 * - agency_id: The identifier for the agency that operates the route.
 * - route_short_name: The short name or number of the route.
 * - route_long_name: The full name of the route.
 * - route_desc: A description of the route.
 * - route_color: The color associated with the route, represented as a hexadecimal value.
 */
select
    route_id,
    agency_id,
    route_short_name,
    route_long_name,
    route_desc,
    route_color
from {{ source('GTFS', 'raw_routes') }}
