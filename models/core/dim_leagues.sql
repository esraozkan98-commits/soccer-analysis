{{ config(materialized='table') }}

SELECT
    l.id AS league_id,
    c.name AS country_name,
    l.name AS league_name
FROM
    {{ source('european_soccer', 'League') }} l
INNER JOIN
    {{ source('european_soccer', 'Country') }} c 
    ON l.country_id = c.id
