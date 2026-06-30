{{ config(
    materialized='table',
    schema='gold'
) }}

SELECT
    genre,
    COUNT(*) AS total_movies,
    ROUND(AVG(vote_average),2) AS avg_rating,
    MAX(popularity) AS max_popularity,
    SUM(vote_count) AS total_votes
FROM {{ ref('movies') }}
GROUP BY genre
ORDER BY avg_rating DESC