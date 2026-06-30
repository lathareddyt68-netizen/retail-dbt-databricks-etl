{{ config(
    materialized='view',
    schema='silver'
) }}

SELECT
    TRY_CAST(Release_Date AS DATE)       AS release_date,
    TRIM(Title)                          AS title,
    TRIM(Overview)                       AS overview,
    TRY_CAST(Popularity AS DOUBLE)       AS popularity,
    TRY_CAST(Vote_Count AS INT)          AS vote_count,
    TRY_CAST(Vote_Average AS DOUBLE)     AS vote_average,
    UPPER(TRIM(Original_Language))       AS original_language,
    TRIM(Genre)                          AS genre,
    TRIM(Poster_Url)                     AS poster_url,

    CASE
        WHEN TRY_CAST(Release_Date AS DATE) IS NULL THEN 'INVALID_DATE'
        WHEN TRY_CAST(Popularity AS DOUBLE) IS NULL THEN 'INVALID_POPULARITY'
        WHEN TRY_CAST(Vote_Count AS INT) IS NULL THEN 'INVALID_VOTE_COUNT'
        WHEN TRY_CAST(Vote_Average AS DOUBLE) IS NULL THEN 'INVALID_VOTE_AVERAGE'
        ELSE 'VALID'
    END AS record_status

FROM {{ ref('mymoviedb') }}