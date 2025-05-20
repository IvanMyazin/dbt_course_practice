{% macro limit_data_dev(column_name, days=2) %}
{% if target.name == 'dev' %}
WHERE
  {{ column_name }} >= (CURRENT_DATE - INTERVAL '{{ days }} days')
{% else %}
WHERE
  {{ column_name }} >= (CURRENT_DATE - INTERVAL '1 day')
{% endif %}
{% endmacro %}