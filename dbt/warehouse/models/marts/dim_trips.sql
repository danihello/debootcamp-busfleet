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
        row_number() over(partition by trip_id order by stop_sequence) as rnk
    FROM
        {{ref('stop_times')}}
    )
 ,last_stop AS (
    SELECT
        trip_id,
        estimated_arrival_time,
        stop_id,
        row_number() over(partition by trip_id order by stop_sequence desc) as rnk
    FROM
        {{ref('stop_times')}}
    )

select 
        {{ dbt_utils.generate_surrogate_key(["agency.agency_id || '_' || trips.trip_id"]) }} as trip_key,
        agency.agency_id || '_' || trips.trip_id as trip_id,
        trips.trip_id as original_trip_id,
        routes.route_short_name as route_name,
        routes.route_long_name as route_desc,
        trips.direction_id as direction_id,
        trips.trip_desc as trip_desc,
        '#'||lower(routes.route_color) as route_color,
        {{ dbt_utils.generate_surrogate_key(["trips.service_id"]) }} as service_key,
        agency.agency_id,
        {{ dbt_utils.generate_surrogate_key(["agency.agency_id"]) }} as agency_key,
        {{ dbt_utils.generate_surrogate_key(["trips.shape_id"]) }} as shape_key,
        (select count(*) from {{ ref('stop_times') }} as stop_times where trip_id = trips.trip_id) as stop_count,
        last_stop.stop_id as last_stop_id,
        first_stop.stop_id as first_stop_id,
        get_time(last_stop.estimated_arrival_time) - get_time(first_stop.estimated_arrival_time) as estimated_trip_duration_seconds
from {{ ref('routes')}} as routes
inner join {{ ref('trips')}} as trips
on trips.route_id = routes.route_id
inner join {{ ref('agency')}} as agency
on agency.agency_id = routes.agency_id
left join first_stop
on first_stop.trip_id = trips.trip_id and first_stop.rnk=1
left join last_stop
on last_stop.trip_id = trips.trip_id and last_stop.rnk=1