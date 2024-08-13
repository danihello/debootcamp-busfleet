import os
from pathlib import Path

from dagster_dbt import DbtCliResource
from dagster import AssetExecutionContext, SourceAsset, AssetKey
from dagster_dbt import DbtCliResource, dbt_assets
from orchestrator.resources import dbt_warehouse_resource, dbt_project_dir


# generate manifest
# dbt_manifest_path = (
#     dbt_warehouse_resource.cli(
#         ["--quiet", "parse"],
#         target_path=Path("target"),
#     )
#     .wait()
#     .target_path.joinpath("manifest.json")
# )

#assuming manifest is in target folder of root dbt project
dbt_manifest_path = dbt_project_dir.joinpath("target", "manifest.json")

# create dbt asset
@dbt_assets(manifest=dbt_manifest_path)
def fleet_dbt_assets(
    context: AssetExecutionContext, dbt_warehouse_resource: DbtCliResource
):
    dbt_warehouse_resource.cli(["deps"]).wait()
    yield from dbt_warehouse_resource.cli(
        ["build"], context=context
    ).stream().fetch_row_counts()
