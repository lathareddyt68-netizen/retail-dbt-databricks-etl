{% snapshot movies_snapshot %}

{{
    config(
        target_schema='snapshot',
        unique_key='movie_key',
        strategy='check',
        check_cols=[
            'overview',
            'popularity',
            'vote_count',
            'vote_average',
            'genre'
        ]
    )
}}

SELECT
    *,
    CONCAT(title, '_', CAST(release_date AS STRING)) AS movie_key
FROM {{ ref('movies') }}

{% endsnapshot %}