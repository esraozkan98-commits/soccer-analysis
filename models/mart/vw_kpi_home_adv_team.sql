{{ config(materialized='view') }}
SELECT 
    team_name, 
    COUNT(*) as total_matches
FROM {{ ref('fact_matches') }} m
JOIN {{ ref('dim_teams') }} t ON m.home_team_api_id = t.team_api_id
GROUP BY 1