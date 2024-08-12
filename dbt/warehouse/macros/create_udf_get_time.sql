/**
 * Converts a time string in the format 'HH:MM:SS' to an integer representing the number of seconds since midnight.
 *
 * @param time_str The time string to convert.
 * @return An integer representing the number of seconds since midnight.
 */
{% macro create_f_get_time() %}
create or replace function {{target.schema}}.get_time(time_str string)
returns int

as 
 $$   
    left(time_str,2)*3600 + substr(time_str,4,2)*60 + right(time_str,2)
 
$$

{% endmacro %}