{% macro limit_data_dev(column_name, days=5000) %}
{% if days < 0 %}
    {{ exceptions.raise_compiler_error("Days parameter cannot be negative. Please provide a positive number.") }}
{% endif %}
{% if target.name == 'dev' %}
WHERE
--  {{ column_name }} >= (CURRENT_DATE - INTERVAL '1 day')
{{ column_name }} >= {{ dbt.dateadd(datepart='day', interval=-days, from_date_or_timestamp="CURRENT_DATE") }}
{% endif %}
{% endmacro %}