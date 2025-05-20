{% macro count_objects_in_project() %}
  {% if execute %}
    {% set all_nodes = graph.nodes.values() | list %}

    {% set models = all_nodes | selectattr("resource_type", "equalto", "model") | list %}
    {% set seeds = all_nodes | selectattr("resource_type", "equalto", "seed") | list %}
    {% set snapshots = all_nodes | selectattr("resource_type", "equalto", "snapshot") | list %}

    {% set model_count = models | length %}
    {% set seed_count = seeds | length %}
    {% set snapshot_count = snapshots | length %}

    {% do log("Всего в проекте:", info=True) %}
    {% do log("- " ~ model_count ~ " моделей", info=True) %}
    {% do log("- " ~ seed_count ~ " seed", info=True) %}
    {% do log("- " ~ snapshot_count ~ " snapshot", info=True) %}
  {% endif %}
{% endmacro %}
