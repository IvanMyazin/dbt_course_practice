{%- macro bookref_to_bigint( column_name ) -%}
  ('0x' || {{ column_name }})::bigint
  
{%- endmacro -%}



{% macro safe_select(table_name) %}
{% if execute %}
        SELECT 
        *
        FROM {{ table_name }}
{% else %}
    SELECT NULL as dummy
{% endif %}
{% endmacro %}



