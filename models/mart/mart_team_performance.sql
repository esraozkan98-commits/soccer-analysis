{{ config(materialized='table') }}

SELECT
    t.team_name,
    m.season,
    COUNT(m.match_api_id) AS matches_played,
    SUM(m.home_team_goal) AS total_home_goals,
    SUM(CASE WHEN m.match_result = 'Home Win' THEN 1 ELSE 0 END) AS home_wins
FROM
    {{ ref('fact_matches') }} m
JOIN
    {{ ref('dim_teams') }} t ON m.home_team_api_id = t.team_api_id
GROUP BY
    t.team_name,
    m.season
