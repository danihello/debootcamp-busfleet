# Project plan

## Objective

The objective of this project is to create a robust data pipeline that will enable the analysis of NYC MTA bus route performance. This will be achieved by simulating an IoT company that installs IoT devices on MTA buses to collect data.

The project involves mining data from these IoT devices and integrating it with static data from GTFS (General Transit Feed Specification) provided by the MTA, which include information on agency, calendar, calendar_dates, routes, shapes, stop_times, and trips. The primary goal is to gather real-time bus location data from an API, which provides updates every 15 seconds. This data, combined with the GTFS data, will be used to construct detailed trip records.

Key objectives include:

1. **Data Collection** Extract real-time bus location data and combine it with static GTFS data.

2. **Trip Creation**: Develop a method to create detailed trip records using the continuous data stream and GTFS data.

3. **Performance Analysis**: Analyze the gathered data to measure bus route crowding and identify routes with significant delays.

4. **Dashboard Visualization**: Implement a PowerBI dashboard to visualize analytics and provide actionable insights.

## Consumers

The users of our datasets are Data Analysts and the Production team in the business.

## Questions

> - Which bus routes delay the most?
> - Which bus routes are overcrowded?
> - At what times routes are mostly delayed?
> - At what times the routes are mostly overcrowded?
> - Which bus routes are the most popular?

## Source datasets

What datasets are you sourcing from? How frequently are the source datasets updating?

Example:

| Source name | Source type | Source documentation |
| - | - | - |
| MTA Bus Time API | REST API | https://bt.mta.info/wiki/Developers/Index |

## Solution architecture

The project Architecture would involve the following components:
- MTA Bus Time API
- Postgres RDS imitating the production database
- Snowflake as a data warhouse
- Airbyte as the Extract and load tool
- Dagster as the orchestration tool
- dbt as the trasformation and data modeling tool
- Power BI as the visualization tool
- GitHub as the code repository
- GitHub Actions as the CI/CD tool


![images/sample-solution-architecture-diagram.png](images/architecture_pg3.png)

## Breakdown of tasks

The tasks will be listed on trello.
