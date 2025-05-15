{% snapshot dim_flights__aircraft_seats %}

{{
   config(
       target_schema='snapshots',
       unique_key='aircraft_code',
       strategy='check',
       check_cols=['seat_no', 'fare_conditions'],
       dbt_valid_to_current="'9999-12-31 23:59:59'",)
}}

SELECT
    aircraft_code,
    seat_no,
    fare_conditions
FROM {{ ref('stg_flights__seats') }}

{% endsnapshot %}