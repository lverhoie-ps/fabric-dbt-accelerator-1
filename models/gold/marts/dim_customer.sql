{{ config(materialized='table') }}

WITH customers AS (

    SELECT
        customer_pk,
        customer_id,
        full_name,
        email,
        country_code,
        country_name,
        city,
        created_at,
        updated_at
    FROM {{ ref('ads_customer') }}

),

unknown_member AS (

    SELECT
        CAST(0 AS BIGINT) AS customer_key,
        CAST('UNKNOWN' AS NVARCHAR(50)) AS customer_id,
        CAST('Unknown customer' AS NVARCHAR(200)) AS full_name,
        CAST(NULL AS NVARCHAR(320)) AS email,
        CAST(NULL AS NVARCHAR(2)) AS country_code,
        CAST('Unknown' AS NVARCHAR(100)) AS country_name,
        CAST('Unknown' AS NVARCHAR(100)) AS city,
        CAST(NULL AS DATETIME2) AS created_at,
        CAST(NULL AS DATETIME2) AS updated_at

),

known_members AS (

    SELECT
        customer_pk AS customer_key,
        customer_id,
        full_name,
        email,
        country_code,
        country_name,
        city,
        created_at,
        updated_at
    FROM customers

),

final AS (

    SELECT
        customer_key,
        customer_id,
        full_name,
        email,
        country_code,
        country_name,
        city,
        created_at,
        updated_at
    FROM unknown_member

    UNION ALL

    SELECT
        customer_key,
        customer_id,
        full_name,
        email,
        country_code,
        country_name,
        city,
        created_at,
        updated_at
    FROM known_members

)

SELECT
    customer_key,
    customer_id,
    full_name,
    email,
    country_code,
    country_name,
    city,
    created_at,
    updated_at
FROM final
