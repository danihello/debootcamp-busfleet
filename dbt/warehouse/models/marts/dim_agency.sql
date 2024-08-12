/**
 * Generates a dimension table for agency data, including the agency ID, name, URL, timezone, language, and phone number.
 * 
 * This model is used to provide a centralized and denormalized view of agency information that can be joined with other fact tables.
 * 
 * The `agency_key` column is a surrogate key generated using the `dbt_utils.generate_surrogate_key` macro, which provides a unique identifier for each agency.
 */
select 
    {{ dbt_utils.generate_surrogate_key(["agency_id"]) }} as agency_key,
    agency_id,
    agency_name,
    agency_url,
    agency_timezone,
    agency_lang,
    agency_phone

from {{ ref('agency') }}  