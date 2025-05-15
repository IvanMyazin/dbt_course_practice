SELECT
    aircraft_code,
    count(*) as count_seats 
FROM {{ ref('stg_flights__seats') }}
GROUP BY aircraft_code
ORDER BY count_seats DESC
