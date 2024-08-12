--This SQL query creates a dimension table `dim_trips` that contains information about each trip in the transit system.
--It joins data from the `routes`, `trips`, `agency`, and `stop_times` tables to gather relevant details about each trip, 
--such as the route name and description, direction, trip description, agency information, and the first and last stop IDs. 
--It also calculates the estimated trip duration in seconds.

--The query uses common table expressions (CTEs) to find the first and last stop for each trip,
-- and then joins this information with the other trip details to create the final dimension table.
WITH first_stop AS (
    SELECT
        trip_id,
        estimated_arrival_time,
        stop_id,
        row_number() OVER (PARTITION BY trip_id ORDER BY stop_sequence) AS rnk
    FROM
        {{ ref('stop_times') }}
),

last_stop AS (
    SELECT
        trip_id,
        estimated_arrival_time,
        stop_id,
        row_number() OVER (PARTITION BY trip_id ORDER BY stop_sequence DESC) AS rnk
    FROM
        {{ ref('stop_times') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(["agency.agency_id || '_' || trips.trip_id"]) }} AS trip_key,
    agency.agency_id || '_' || trips.trip_id AS trip_id,
    trips.trip_id AS original_trip_id,
    routes.route_short_name AS route_name,
    routes.route_long_name AS route_desc,
    trips.direction_id AS direction_id,
    trips.trip_desc AS trip_desc,
    '#' || lower(routes.route_color) AS route_color,
    {{ dbt_utils.generate_surrogate_key(["trips.service_id"]) }} AS service_key,
    agency.agency_id,
    {{ dbt_utils.generate_surrogate_key(["agency.agency_id"]) }} AS agency_key,
    {{ dbt_utils.generate_surrogate_key(["trips.shape_id"]) }} AS shape_key,
    (SELECT count(*) FROM {{ ref('stop_times') }} WHERE trip_id = trips.trip_id) AS stop_count,
    last_stop.stop_id AS last_stop_id,
    first_stop.stop_id AS first_stop_id,
    get_time(last_stop.estimated_arrival_time) - get_time(first_stop.estimated_arrival_time) AS estimated_trip_duration_seconds
FROM {{ ref('routes') }} AS routes
INNER JOIN {{ ref('trips') }} AS trips
    ON routes.route_id = trips.route_id
INNER JOIN {{ ref('agency') }} AS agency
    ON routes.agency_id = agency.agency_id
LEFT JOIN first_stop
    ON trips.trip_id = first_stop.trip_id AND first_stop.rnk = 1
LEFT JOIN last_stop
    ON trips.trip_id = last_stop.trip_id AND last_stop.rnk = 1
