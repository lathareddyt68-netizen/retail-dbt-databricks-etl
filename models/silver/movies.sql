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

SELECT
    *,
    CONCAT(
    'BATCH_',
    DATE_FORMAT(CURRENT_TIMESTAMP(), 'yyyyMMdd_HHmmss')
) AS batch_id,

'movie_pipeline' AS pipeline_name,
CONCAT(
    'RUN_',
    DATE_FORMAT(CURRENT_TIMESTAMP(), 'yyyyMMdd_HHmmss')
) AS pipeline_run_id,
    CURRENT_TIMESTAMP() AS load_timestamp,
    CURRENT_DATE() AS batch_date

FROM source_data