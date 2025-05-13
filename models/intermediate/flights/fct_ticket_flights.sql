{{
  config(
    materialized = 'table',
    )
}}
select
  tf."ticket_no",
  "flight_id",
  "fare_conditions",
  "amount"
from
    {{ ref('stg_flights__ticket_flights') }} as tf
    join {{ ref('stg_flights__tickets') }} as t
    on tf.ticket_no = t.ticket_no
where passenger_id not in (
  select
    employee_id
  from {{ ref('stg_dict__employee_id') }}
  )