import os
from pathlib import Path
from dagster_dbt import DbtCliResource
from dagster import ConfigurableResource, EnvVar
from dagster_airbyte import AirbyteResource
from dagster_snowflake import SnowflakeResource
from dagster import ConfigurableResource

#configure airbyte resource
airbyte_resource = AirbyteResource(
    host=EnvVar("AIRBYTE_SERVER_NAME"),
    port="8000",
    username=EnvVar("AIRBYTE_USERNAME"),
    password=EnvVar("AIRBYTE_PASSWORD")
)

# configure snowflake resource
snowflake_resource = SnowflakeResource(
    account=EnvVar("SNOWFLAKE_ACCOUNT"),
    user=EnvVar("SNOWFLAKE_USERNAME"),
    password=EnvVar("SNOWFLAKE_PASSWORD"),
    database=EnvVar("SNOWFLAKE_DATABASE"),
    warehouse=EnvVar("SNOWFLAKE_WAREHOUSE"),
    role=EnvVar("SNOWFLAKE_ROLE"),
    schema=EnvVar("SNOWFLAKE_SCHEMA")
)

# configure dbt project resource
dbt_project_dir = Path(__file__).joinpath("..", "..","..", "dbt", "warehouse").resolve()
dbt_warehouse_resource = DbtCliResource(project_dir=os.fspath(dbt_project_dir))

class PostgresDatabaseResource(ConfigurableResource):
    server_name: str
    database_name: str
    username: str
    password: str
    port: str = "5432"
