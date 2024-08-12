from dagster import ScheduleDefinition

from orchestrator.jobs import run_pipeline

pipline_schedule = ScheduleDefinition(
    job=run_pipeline,
    name="run_pipeline_every_day_at_midnight",
    cron_schedule="0 0 * * *",
    execution_timezone="America/New_York",
)