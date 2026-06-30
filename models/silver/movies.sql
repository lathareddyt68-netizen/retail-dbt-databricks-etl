{{ config(
    materialized='table',
    schema='silver'
) }}

SELECT *
FROM {{ ref('stg_mymoviedb') }}
WHERE record_status = 'VALID'