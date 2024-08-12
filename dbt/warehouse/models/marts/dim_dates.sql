--This code generates a date dimension table using the `dbt_date.get_date_dimension()` macro.
--The start and end dates for the date dimension are retrieved from the `date_range` model using the `dbt_utils.get_column_values()` macro.

--The generated date dimension table includes columns for the date, year, month, day, and other relevant date-related attributes.
-- This table can be used to power date-based reporting and analysis in the data warehouse.

{% set start_date = (dbt_utils.get_column_values(ref('date_range'), 'start_date'))[0] %}
{% set end_date = (dbt_utils.get_column_values(ref('date_range'), 'end_date'))[0] %}

    {{ dbt_date.get_date_dimension(
        start_date=start_date,
        end_date=end_date
    ) }}
