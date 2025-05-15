{% snapshot snap_city_region %}

{{
   config(
       target_schema='snapshots',
       unique_key='city',

       strategy='timestamp',
       updated_at='updated_at',
       dbt_valid_to_current="'9999-12-31 23:59:59'",

       
       hard_deletes='new_record',

       snapshot_meta_column_names={
           'dbt_is_deleted': 'dbt_is_deleted',}
   )
}}

SELECT
    city,
    region,
    updated_at
FROM {{ ref('city_region') }}

{% endsnapshot %}