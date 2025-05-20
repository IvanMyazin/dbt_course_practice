{{
  config(
    materialized = 'incremental',
    incremental_stratagy = 'append',
    tags = ['bookings']    
  )
}}
select
  "book_ref",
  "book_date",
  {{kopeck_to_ruble(column_name="total_amount", scale=-2)}} as total_amount

from {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
  WHERE 
    {{ bookref_to_bigint("book_ref") }} > (SELECT MAX({{ bookref_to_bigint("book_ref") }}) FROM {{this}})
{% endif %}
    





