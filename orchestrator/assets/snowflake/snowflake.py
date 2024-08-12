import os
from dagster_snowflake import SnowflakeResource
from dagster import EnvVar, asset, MaterializeResult, AutoMaterializePolicy, AutomationCondition
from orchestrator.policies import retry_policy


#do context.log.info(f"raw_calendar")
@asset(group_name="s3_copy_into_snowflake",description="Raw calendar data",tags={"storage": "s3"},compute_kind="Snowflake")
def raw_calendar(snowflake: SnowflakeResource):
    s3_url = os.getenv("S3_URL")
    create_raw_stage_query = f"""
    CREATE or replace STAGE warehouse.raw.s3_calendar
    STORAGE_INTEGRATION = gtfs_storage_integration
    URL = '{s3_url}/calendar.txt'
    FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_DELIMITER=',' FIELD_OPTIONALLY_ENCLOSED_BY='"')
    """
    create_raw_table_definition_query = """
        create or replace table warehouse.raw.raw_calendar(
        service_id string,
        monday int,
        tuesday int,
        wednesday int,
        thursday int,
        friday int,
        saturday int,
        sunday int,
        start_date string,
        end_date string
    )"""
    copy_from_s3_into_raw_table = """
    copy into warehouse.raw.raw_calendar
    from @warehouse.raw.s3_calendar
    """
    queries = [
        create_raw_stage_query,
        create_raw_table_definition_query,
        copy_from_s3_into_raw_table,
    ]
    with snowflake.get_connection() as conn:
        for query in queries:
            conn.cursor().execute(query)
            # return MaterializeResult(
            #     metadata={"name": "query", "value": query},
            # )

@asset(group_name="s3_copy_into_snowflake", description="Raw agency data",tags={"storage": "s3"},compute_kind="Snowflake")
def raw_agency(snowflake: SnowflakeResource):
    s3_url = os.getenv("S3_URL")
    create_raw_stage_query = f"""
    CREATE or replace STAGE warehouse.raw.s3_calendar
    STORAGE_INTEGRATION = gtfs_storage_integration
    URL = '{s3_url}/agency.txt'
    FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_DELIMITER=',' FIELD_OPTIONALLY_ENCLOSED_BY='"')
    """
    create_raw_table_definition_query = """
        create or replace table warehouse.raw.raw_agency(
        agency_id string,
        agency_name string,
        agency_url string,
        agency_timezone string,
        agency_lang string,
        agency_phone string
        )
    """
    copy_from_s3_into_raw_table = """
    copy into warehouse.raw.raw_agency
    from @warehouse.raw.s3_agency
    """
    queries = [
        create_raw_stage_query,
        create_raw_table_definition_query,
        copy_from_s3_into_raw_table,
    ]
    with snowflake.get_connection() as conn:
        for query in queries:
            conn.cursor().execute(query)

@asset(group_name="s3_copy_into_snowflake", description="Raw calendar dates data",tags={"storage": "s3"},compute_kind="Snowflake")
def raw_calendar_dates(snowflake: SnowflakeResource):
    s3_url = os.getenv("S3_URL")
    create_raw_stage_query = f"""
    CREATE or replace STAGE warehouse.raw.s3_calendar_dates
    STORAGE_INTEGRATION = gtfs_storage_integration
    URL = '{s3_url}/calendar_dates.txt'
    FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_DELIMITER=',' FIELD_OPTIONALLY_ENCLOSED_BY='"')
    """
    create_raw_table_definition_query = """
        create or replace table warehouse.raw.raw_calendar_dates(
        service_id string,
        date string,
        exception_type int
        )
    """
    copy_from_s3_into_raw_table = """
    copy into warehouse.raw.raw_calendar_dates
    from @warehouse.raw.s3_calendar_dates
    """
    queries = [
        create_raw_stage_query,
        create_raw_table_definition_query,
        copy_from_s3_into_raw_table,
    ]
    with snowflake.get_connection() as conn:
        for query in queries:
            conn.cursor().execute(query)

@asset(group_name="s3_copy_into_snowflake", description="Raw shapes data",tags={"storage": "s3"},compute_kind="Snowflake")
def raw_shapes(snowflake: SnowflakeResource):
    s3_url = os.getenv("S3_URL")
    create_raw_stage_query = f"""
    CREATE or replace STAGE warehouse.raw.s3_shapes
    STORAGE_INTEGRATION = gtfs_storage_integration
    URL = '{s3_url}/shapes.txt'
    FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_DELIMITER=',' FIELD_OPTIONALLY_ENCLOSED_BY='"')
    """
    create_raw_table_definition_query = """
        create or replace table warehouse.raw.raw_shapes (
        shape_id string,
        shape_pt_lat float,
        shape_pt_lon float,
        shape_pt_sequence string
        )
    """
    copy_from_s3_into_raw_table = """
    copy into warehouse.raw.raw_shapes
    from @warehouse.raw.s3_shapes
    """
    queries = [
        create_raw_stage_query,
        create_raw_table_definition_query,
        copy_from_s3_into_raw_table,
    ]
    with snowflake.get_connection() as conn:
        for query in queries:
            conn.cursor().execute(query)

@asset(group_name="s3_copy_into_snowflake", description="Raw stop times data",tags={"storage": "s3"},compute_kind="Snowflake")
def raw_stop_times(snowflake: SnowflakeResource):
    s3_url = os.getenv("S3_URL")
    create_raw_stage_query = f"""
    CREATE or replace STAGE warehouse.raw.s3_stop_times
    STORAGE_INTEGRATION = gtfs_storage_integration
    URL = '{s3_url}/stop_times.txt'
    FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_DELIMITER=',' FIELD_OPTIONALLY_ENCLOSED_BY='"')
    """
    create_raw_table_definition_query = """
        create or replace table warehouse.raw.raw_stop_times (
        trip_id string,
        arrival_time string,
        departure_time string,
        stop_id string,
        stop_sequence int,
        pickup_type int,
        drop_off_type int,
        timepoint int
        )
    """
    copy_from_s3_into_raw_table = """
    copy into warehouse.raw.raw_stop_times
    from @warehouse.raw.s3_stop_times
    """
    queries = [
        create_raw_stage_query,
        create_raw_table_definition_query,
        copy_from_s3_into_raw_table,
    ]
    with snowflake.get_connection() as conn:
        for query in queries:
            conn.cursor().execute(query)

@asset(group_name="s3_copy_into_snowflake", description="Raw stops data",tags={"storage": "s3"},compute_kind="Snowflake")
def raw_stops(snowflake: SnowflakeResource):
    s3_url = os.getenv("S3_URL")
    create_raw_stage_query = f"""
    CREATE or replace STAGE warehouse.raw.s3_stops
    STORAGE_INTEGRATION = gtfs_storage_integration
    URL = '{s3_url}/stops.txt'
    FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_DELIMITER=',' FIELD_OPTIONALLY_ENCLOSED_BY='"')
    """
    create_raw_table_definition_query = """
        create or replace table warehouse.raw.raw_stops (
        stop_id string,
        stop_name string,
        stop_desc string,
        stop_lat float,
        stop_lon float,
        zone_id int,
        stop_url string,
        location_type int,
        parent_station string
        )
    """
    copy_from_s3_into_raw_table = """
    copy into warehouse.raw.raw_stops
    from @warehouse.raw.s3_stops
    """
    queries = [
        create_raw_stage_query,
        create_raw_table_definition_query,
        copy_from_s3_into_raw_table,
    ]
    with snowflake.get_connection() as conn:
        for query in queries:
            conn.cursor().execute(query)

@asset(group_name="s3_copy_into_snowflake", description="Raw trips data",tags={"storage": "s3"},compute_kind="Snowflake")
def raw_trips(snowflake: SnowflakeResource):
    s3_url = os.getenv("S3_URL")
    create_raw_stage_query = f"""
    CREATE or replace STAGE warehouse.raw.s3_trips
    STORAGE_INTEGRATION = gtfs_storage_integration
    URL = '{s3_url}/trips.txt'
    FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_DELIMITER=',' FIELD_OPTIONALLY_ENCLOSED_BY='"')
    """
    create_raw_table_definition_query = """
        create or replace table warehouse.raw.raw_trips(
        route_id string,
        service_id string,
        trip_id string,
        trip_headsign string,
        direction_id int,
        block_id string,
        shape_id string
        )
    """
    copy_from_s3_into_raw_table = """
    copy into warehouse.raw.raw_trips
    from @warehouse.raw.s3_trips
    """
    queries = [
        create_raw_stage_query,
        create_raw_table_definition_query,
        copy_from_s3_into_raw_table,
    ]
    with snowflake.get_connection() as conn:
        for query in queries:
            conn.cursor().execute(query)

@asset(group_name="s3_copy_into_snowflake", description="Raw routes data",tags={"storage": "s3"},compute_kind="Snowflake")
def raw_routes(snowflake: SnowflakeResource):
    s3_url = os.getenv("S3_URL")
    create_raw_stage_query = f"""
    CREATE or replace STAGE warehouse.raw.s3_trips
    STORAGE_INTEGRATION = gtfs_storage_integration
    URL = '{s3_url}/routes.txt'
    FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_DELIMITER=',' FIELD_OPTIONALLY_ENCLOSED_BY='"')
    """
    create_raw_table_definition_query = """
        create or replace table warehouse.raw.raw_routes (
        route_id string,
        agency_id string,
        route_short_name string,
        route_long_name string,
        route_desc string,
        route_type int,
        route_color string,
        route_text_color string
        )
    """
    copy_from_s3_into_raw_table = """
    copy into warehouse.raw.raw_routes
    from @warehouse.raw.s3_routes
    """
    queries = [
        create_raw_stage_query,
        create_raw_table_definition_query,
        copy_from_s3_into_raw_table,
    ]
    with snowflake.get_connection() as conn:
        for query in queries:
            conn.cursor().execute(query)