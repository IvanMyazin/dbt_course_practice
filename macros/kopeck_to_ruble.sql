{% macro kopeck_to_ruble(column_name, scale=2) %}
  {% if scale < 0%}
    {% do exceptions.warn("Invalid scale: " ~ scale ~ " - must be greater than 0") %}
  {% endif %}
  ({{ column_name }} / 100)::numeric(16, {{ scale }})
{% endmacro %}