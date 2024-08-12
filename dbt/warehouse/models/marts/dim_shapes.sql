  /**
   * This CTE aggregates the shape data from the `shapes` table, generating a `points` column that contains a comma-separated list of longitude and latitude coordinates for each shape. 
   * The final query then generates a surrogate key for each shape, the original `shape_id`, and a Well-Known Text (WKT) representation of the shape as a LINESTRING.
   *
   * This model is used to create a dimension table for shapes, which can be joined with other fact tables to provide shape information.
   */
  with shapes_agg as (
    SELECT 
        shape_id,
        listagg(shape_pt_lon ||' ' ||shape_pt_lat||', ') within group (order by shape_pt_seq) AS points
    FROM {{ ref('shapes') }}
    GROUP BY shape_id
    )

    select 
       {{ dbt_utils.generate_surrogate_key(['shape_id']) }} as shape_key,
       shape_id,
       'LINESTRING(' || left(points, length(points)-2) || ')' as wkt
    from shapes_agg