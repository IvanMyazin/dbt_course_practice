{% snapshot dim_flights__aircrafts %}

{{
   config(
       target_schema='snapshots',
       unique_key='aircraft_code',
       strategy='check',
       check_cols=['model', 'range'],
       dbt_valid_to_current="'9999-12-31 23:59:59'",
   )
}}

SELECT
    aircraft_code,
    model,
    range
FROM {{ ref('stg_flights__aircrafts') }}

{% endsnapshot %}