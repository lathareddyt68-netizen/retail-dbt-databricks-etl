{{ config(
    materialized='incremental',
    unique_key='customer_id',
    incremental_strategy='merge'
) }}

WITH cleaned AS (

    SELECT
        customer_id,
        TRIM(customer_name) AS customer_name,

        -- email validation
        CASE 
            WHEN email LIKE '%@%.%' THEN LOWER(email)
            ELSE NULL
        END AS email,

        -- phone validation
        CASE 
            WHEN REGEXP_LIKE(phone, '^[0-9]+$') THEN phone
            ELSE NULL
        END AS phone,

        COALESCE(city, 'UNKNOWN') AS city,

        TRY_CAST(signup_date AS DATE),
        TRY_CAST(age AS INT) AS age

    FROM {{ ref('customers') }}

),

filtered AS (

    SELECT *
    FROM cleaned
    WHERE age > 0 OR age IS NULL

)

SELECT *
FROM filtered