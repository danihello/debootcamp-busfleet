from datetime import datetime
from orchestrator.policies import retry_policy
from dagster import job, AssetSelection, define_asset_job

run_pipeline = define_asset_job(
    name="run_pipeline",
    #runing a single group
    #selection=AssetSelection.groups("load_into_snowflake")
    #running all groups/assets
    selection=AssetSelection.all(),
    op_retry_policy=retry_policy,
    description="Runs the entire pipeline",
    tags={"kind": "pipeline"},
)

