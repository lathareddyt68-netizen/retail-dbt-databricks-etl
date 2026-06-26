{{ config(materialized='table') }}

WITH source AS (

    SELECT * 
    FROM {{ ref('cleaned_customers') }}

),

-- Deduplicate (important if multiple updates exist)
deduplicated AS (

    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY signup_date DESC
        ) AS rn
    FROM source

),

final AS (

    SELECT
        customer_id,

        -- Standardize name
        INITCAP(customer_name) AS customer_name,

        -- Email already cleaned in silver
        email,

        -- Phone already validated
        phone,

        -- Handle unknown city
        COALESCE(city, 'UNKNOWN') AS city,

        signup_date,
        age

    FROM deduplicated
    WHERE rn = 1

)

SELECT
    -- Surrogate Key
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,

    customer_id,
    customer_name,
    email,
    phone,
    city,
    signup_date,
    age

FROM final