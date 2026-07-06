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

    source_data.*,

    '{{ var("batch_id") }}' AS batch_id,

    'movie_pipeline' AS pipeline_name,

    '{{ var("pipeline_run_id") }}' AS pipeline_run_id,

    CURRENT_TIMESTAMP() AS load_timestamp,

    CURRENT_DATE() AS batch_date

FROM source_data