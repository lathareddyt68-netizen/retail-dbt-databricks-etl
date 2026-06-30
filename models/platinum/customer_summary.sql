SELECT
    customer_key,
    customer_name,
    city,
    age,

    CASE 
        WHEN age < 25 THEN 'YOUNG'
        WHEN age BETWEEN 25 AND 40 THEN 'ADULT'
        ELSE 'SENIOR'
    END AS age_group,

    signup_date,

    DATEDIFF(DAY, signup_date, CURRENT_DATE) AS customer_tenure_days

FROM {{ ref('dim_customers') }}