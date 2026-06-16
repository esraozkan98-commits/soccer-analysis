-- models/staging/stg_countries.sql

SELECT
    id    AS country_id,
    name  AS country_name
FROM {{ source('european_soccer', 'Country') }}