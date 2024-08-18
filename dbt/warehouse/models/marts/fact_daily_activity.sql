/**
 * Aggregates daily activity data for vehicles, including total trip duration, average speed, and total distance traveled.
 * The data is grouped by vehicle_id, date_day, and route_id.
 */
select
    vehicle_id,
    dim_dates.date_day,
    route_id,
    sum(trip_duration_seconds / 3600)::decimal(18, 1) as sum_duration_hours,
    avg(trip_speed_kmh)::int as avg_speed_kmh,
    count(*) as trip_count,
    sum(distance_traveled) as sum_distance

from {{ ref('fact_trips') }} as fact_trips
inner join {{ ref('dim_dates') }} as dim_dates
    on fact_trips.trip_date = dim_dates.date_day
group by vehicle_id, dim_dates.date_day, route_id
