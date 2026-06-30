{{ config(
    materialized='table',
    schema='dev'
) }}

SELECT *
FROM {{ ref('stg_mymoviedb') }}
WHERE record_status <> 'VALID'