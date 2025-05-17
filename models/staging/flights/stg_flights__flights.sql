{{
  config(
    materialized = 'table',
    )
}}
select
  "flight_id",
  "flight_no"::varchar(10) as "flight_no",
  "scheduled_departure",
  "scheduled_arrival",
  "departure_airport",
  "arrival_airport",
  "status",
  "aircraft_code",
  "actual_departure",
  "actual_arrival",
  'Hi everyone' as "new_column"

from {{ source('demo_src', 'flights') }}
{% if is_incremental() %}
  WHERE 
    scheduled_departure  < (SELECT MAX(scheduled_departure ) FROM {{ source('demo_src', 'flights') }}) - interval '100 day'
{% endif %}  
