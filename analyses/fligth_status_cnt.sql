SELECT
    status,
    COUNT(*) AS cnt
FROM
    {{ref("fct_flights")}}
GROUP BY 1;