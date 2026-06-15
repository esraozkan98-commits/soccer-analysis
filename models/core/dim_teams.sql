{{ config(materialized='table') }}
SELECT
    team_api_id,
    team_long_name AS team_name
FROM {{ source('european_soccer', 'Team') }}