from dagster import Definitions,EnvVar, load_assets_from_modules, load_assets_from_package_module, AutoMaterializePolicy
from orchestrator.assets.airbyte.airbyte import airbyte_assets
from orchestrator.resources import airbyte_resource, snowflake_resource, PostgresDatabaseResource
from orchestrator.assets.dbt.dbt import fleet_dbt_assets, dbt_warehouse_resource
from orchestrator.assets import snowflake
from orchestrator.jobs import run_pipeline
from orchestrator.schedules import pipline_schedule

snow_flake_assets = load_assets_from_package_module(snowflake)

defs = Definitions(
    assets=[airbyte_assets, fleet_dbt_assets, *snow_flake_assets],
    resources={
        "airbyte_resource": airbyte_resource,
        "dbt_warehouse_resource": dbt_warehouse_resource,
        "snowflake": snowflake_resource,
        "postgres_conn": PostgresDatabaseResource(
            server_name=EnvVar("POSTGRES_SERVER_NAME"),
            database_name=EnvVar("POSTGRES_DATABASE"),
            username=EnvVar("POSTGRES_USERNAME"),
            password=EnvVar("POSTGRES_PASSWORD"),
            port=EnvVar("POSTGRES_PORT"),
        ),
    },
    jobs=[run_pipeline],
    schedules=[pipline_schedule],
)
