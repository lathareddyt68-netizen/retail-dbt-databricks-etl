{{ config(
    materialized='incremental',
    schema='audit',
    unique_key='batch_id'
) }}

SELECT
    '{{ var("batch_id") }}' AS batch_id,
    '{{ var("pipeline_name") }}' AS pipeline_name,
    '{{ var("pipeline_run_id") }}' AS pipeline_run_id,

    CURRENT_TIMESTAMP() AS start_time,

    (SELECT COUNT(*) FROM {{ source('bronze','mymoviedb') }}) AS rows_read,

    (SELECT COUNT(*) FROM {{ ref('movies') }}) AS rows_loaded,

    (SELECT COUNT(*) FROM {{ ref('bad_movies') }}) AS bad_records,

    'SUCCESS' AS status