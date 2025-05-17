{{
  config(
    materialized = 'table',
    pre_hook = '
      {% set current_date_time = run_started_at.strftime("%Y%m%d_%H%M%S") %}
      {% set backup_relation = adapter.Relation.create(
        database=this.database,
        schema=this.schema,
        identifier=this.identifier ~ "_" ~ current_date_time,
        type="table") %}
     
      {% do adapter.drop_relation(backup_relation) if adapter.get_relation(backup_relation.database, backup_relation.schema, backup_relation.identifier) %}
      {% do adapter.rename_relation(this, backup_relation) if adapter.get_relation(this.database, this.schema, this.identifier) %}
    '
  )
}}

select
    aircraft_code,
    model,
    "range"
from
    {{ source('demo_src', 'aircrafts') }}