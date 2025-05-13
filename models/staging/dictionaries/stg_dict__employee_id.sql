{{
  config(
    materialized = 'table',
    )
}}

SELECT
    employee_id,
    employee_name
FROM
    {{ ref('employee_id') }}