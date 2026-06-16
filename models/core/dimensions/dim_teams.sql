-- models/core/dimensions/dim_teams.sql

SELECT
    team_api_id,
    team_long_name   AS team_name,
    team_short_name
FROM {{ ref('stg_teams') }}