select 
    {{ dbt_utils.generate_surrogate_key(["service_id"]) }} as service_key,
    service_id,
    date
from {{ ref('calendar_dates') }}
