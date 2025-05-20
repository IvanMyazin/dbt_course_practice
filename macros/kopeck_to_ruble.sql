{% macro kopeck_to_ruble(column_name, scale=2, some_parameter=4) %}
  ({{ column_name }} / 100)::numeric(16, {{ scale }})
{% endmacro %}