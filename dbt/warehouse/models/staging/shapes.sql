/**
 * Selects the shape ID, latitude, longitude, and sequence of shape points from the raw GTFS shapes table.
 * This query is used to stage the GTFS shapes data for further processing and analysis.
 */
select 
    shape_id,
    shape_pt_lat,
    shape_pt_lon,
    shape_pt_sequence::int as shape_pt_seq
    
from {{ source('GTFS', 'raw_shapes') }}