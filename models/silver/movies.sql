{{ config(
    materialized='incremental',
    schema='silver',
    unique_key=['title','release_date']
) }}    

WITH source_data AS (
    
SELECT *
FROM {{ ref('stg_mymoviedb') }}
WHERE record_status = 'VALID'
)

SELECT *
FROM source_data