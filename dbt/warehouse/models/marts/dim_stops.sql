select 
    {{ dbt_utils.generate_surrogate_key(["stop_id"]) }} as stop_key,
    stop_id,
    stop_name,
    stop_latitude,
    stop_longitude
from {{ ref('stops') }}