-- models/staging/stg_teams.sql

SELECT
    team_api_id,
    team_long_name,
    team_short_name
FROM {{ source('european_soccer', 'Team') }}
WHERE team_api_id IS NOT NULL