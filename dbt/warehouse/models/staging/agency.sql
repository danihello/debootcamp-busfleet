/**
 * Selects the agency details from the raw GTFS agency table.
 * The selected columns include:
 * - agency_id: The unique identifier for the agency.
 * - agency_name: The name of the agency.
 * - agency_url: The URL of the agency's website.
 * - agency_timezone: The timezone the agency operates in.
 * - agency_lang: The primary language used by the agency.
 * - agency_phone: The phone number for the agency.
 */
select 
    agency_id,
    agency_name,
    agency_url,
    agency_timezone,
    agency_lang,
    agency_phone
from {{ source('GTFS', 'raw_agency') }}