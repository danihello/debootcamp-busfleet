
from dagster import RetryPolicy

retry_policy = RetryPolicy(max_retries=3, delay=10)