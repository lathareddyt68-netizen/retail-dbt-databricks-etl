{{ config(
    materialized='incremental',
    schema='audit',
    unique_key='batch_id'
) }}

SELECT
    CONCAT(
        'BATCH_',
        DATE_FORMAT(CURRENT_DATE(), 'yyyyMMdd'),
        '_001'
    ) AS batch_id,

'movie_pipeline' AS pipeline_name,

CONCAT(
    'RUN_',
    DATE_FORMAT(CURRENT_TIMESTAMP(), 'yyyyMMdd_HHmmss')
) AS pipeline_run_id,

    CURRENT_TIMESTAMP() AS start_time,

    (SELECT COUNT(*) FROM {{ source('bronze','mymoviedb') }}) AS rows_read,

    (SELECT COUNT(*) FROM {{ ref('movies') }}) AS rows_loaded,

    (SELECT COUNT(*) FROM {{ ref('bad_movies') }}) AS bad_records,

    'SUCCESS' AS status