{%- macro concat_columns(columns, delim = ', ') -%}
  {%- for column in columns -%}
    {{ column }} {% if not loop.last %} || '{{ delim }}' || {% endif %}
  {%- endfor -%}
{% endmacro %}


{% macro drop_old_relations(dryrun=False) %}
{# находим все модели, seed, snapshot проекта dbt #}
{% set current_models = [] %}
{% for node in graph.nodes.values() | selectattr("resource_type", "in", ["model", "snapshot", "seed"]) %}
    {% do current_models.append(node.name) %}
{% endfor %}

{# {% do log(current_models, True) %} #}
{# формирование скрипта удаления всех таблиц и вьюх, которым не соответствует ни одна модель, сид или снэпшот #}

{% set cleanup_query %}
WITH MODELS_TO_DROP AS (
    SELECT
        CASE
            WHEN TABLE_TYPE = 'BASE TABLE' THEN 'TABLE'
            WHEN TABLE_TYPE = 'VIEW' THEN 'VIEW'
        END AS RELATION_TYPE,
        CONCAT_WS('.', TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME) AS RELATION_NAME
    FROM {{target.database}}.INFORMATION_SCHEMA.TABLES
    WHERE
        TABLE_SCHEMA = '{{ target.schema }}'
        AND UPPER(TABLE_NAME) NOT IN (
            {%- for model in current_models -%}
                '{{ model | upper() }}'
                {%- if not loop.last -%}
                , 
                {%- endif %}
            {%- endfor -%}
        )
)
SELECT 
    'DROP ' || RELATION_TYPE || ' ' || RELATION_NAME || ';' AS DROP_COMMANDS
FROM MODELS_TO_DROP;
{% endset %}

{# вывод скрипта удаления #}
{% do log(cleanup_query) %}
    
{% set drop_commands = run_query(cleanup_query).columns[0].values() %}

{# удаление лишних таблиц и вьюх / вывод скрипта удаления #}

{% if drop_commands %}
    {% if dryrun | as_bool == False %}
        {% do log('Executing DROP commands ...', True) %}
    {% else %}
        {% do log('Printing DROP commands ...', True) %}
    {% endif %}
    {% for drop_command in drop_commands %}
        {% do log(drop_command, True) %}
        {% if dryrun | as_bool == False %}
            {% do run_query(drop_command) %}
        {% endif %}
    {% endfor %}
{% else %}
    {% do log('No relations to clean', True) %}
{% endif %}

{% endmacro %}


{%- macro show_columns_relation(table_name) -%}
    {% set source_relation = load_relation(ref(table_name)) %}
    {% set columns = adapter.get_columns_in_relation(source_relation) %}

    {%- for column in columns -%}
        {%- if not loop.last %}
            {{ column.name ~ ', ' }}
        {%- else %}
            {{ column.name }}
        {%- endif -%}
    {%- endfor -%}
{%- endmacro -%}
