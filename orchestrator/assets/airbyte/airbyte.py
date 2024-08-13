from datetime import datetime
from dagster import EnvVar, AutoMaterializePolicy, FreshnessPolicy
from dagster_airbyte import AirbyteResource, load_assets_from_airbyte_instance
from orchestrator.resources import airbyte_resource

airbyte_assets = load_assets_from_airbyte_instance(
    airbyte_resource,
    connection_filter=lambda meta: "snowflake" in meta.name
    )
