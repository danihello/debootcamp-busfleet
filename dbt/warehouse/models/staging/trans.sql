{{
    config(
        materialized = "incremental",
        unique_key = "trans_id",
        incremental_strategy = "delete+insert"
    )
}}

with raw_trans as (
--This code is part of a staging model for a data warehouse. 
--It selects various columns from the `vehicle_monitor_parsed` source table, including trip IDs, status, recorded datetime, distance traveled, vehicle IDs, location coordinates, direction IDs, agency IDs, stop IDs, route IDs, and passenger count information.
--The code also includes logic to identify the start and end of trips by checking for changes in the trip ID,
--and it filters out "noProgress" status records.
--Additionally, it includes an incremental loading strategy that only processes records with a recorded datetime after the maximum end date from the previous load.
select 
    date
    ,datedvehiclejourneyref as trip_id
    ,progressrate as status
    ,to_timestamp(recordedattime) as recorded_datetime
    ,distancetraveled::decimal(18,1) as distance_traveled
    ,replace(vehicleref,operatorref||'_','') as vehicle_id
    ,latitude
    ,longitude
    ,directionref as direction_id
    ,operatorref as agency_id
    ,replace(stoppointref,'MTA_','') as current_stop_id
    ,publishedlinename as route_id
    ,estimatedpassengercount
    ,estimatedpassengercapacity
    ,case when ifnull(lag(datedvehiclejourneyref) over(partition by vehicleref order by RecordedAtTime),'')<>datedvehiclejourneyref 
            and lead(datedvehiclejourneyref) over(partition by vehicleref order by RecordedAtTime)<>datedvehiclejourneyref		
    then 1 else 0 end as bad_trans,
    row_number() over(partition by replace(vehicleref,operatorref||'_',''),to_timestamp(recordedattime) order by recordedattime ) as rnk
from {{ source('api','vehicle_monitor_parsed') }} as vehicle_monitor_parsed
{% if is_incremental() %}
inner join {{this.schema}}.last_trip_date_per_bus as last_trip_date_per_bus
on last_trip_date_per_bus.vehicle_id = replace(vehicleref,operatorref||'_','')
{% endif %}
where progressrate not in ('noProgress')
{% if is_incremental() %}
and to_timestamp(recordedattime)  > max_end_date
{% endif %}
)
,stg_trips as (
select 
    vehicle_id ||'-'|| recorded_datetime  as trans_id,
    case when lag(trip_id) over(partition by vehicle_id order by recorded_datetime)<>trip_id then 1
			when lag(trip_id) over(partition by vehicle_id order by recorded_datetime) is null then 1
	else 0 end as trip_start,
	case when lead(trip_id) over(partition by vehicle_id order by recorded_datetime)<>trip_id then 1
	else 0 end as trip_end,
    *
from raw_trans
where bad_trans = 0
and rnk = 1
)
,trip_grp as (
select sum(trip_start) over(partition by vehicle_id order by recorded_datetime) as trip_grp,
*
from stg_trips
)
select 
trans_id,
trip_start,
trip_end,
recorded_datetime,
date,
trip_id,
status,
distance_traveled,
vehicle_id,
latitude,
longitude,
direction_id,
agency_id,
current_stop_id,
route_id,
avg(estimatedpassengercount) over(partition by trip_grp, vehicle_id) as trip_avg_psngr_count,
max(estimatedpassengercapacity) over(partition by trip_grp, vehicle_id) as trip_max_psngr_capacity,
estimatedpassengercount,
estimatedpassengercapacity,
from trip_grp