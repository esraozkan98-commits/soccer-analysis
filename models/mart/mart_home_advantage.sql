{{ config(materialized='table') }}

SELECT
    m.league_id,
    l.league_name,
    m.season,
    COUNT(m.match_api_id) AS total_matches,
    SUM(CASE WHEN m.match_result = 'Home Win' THEN 1 ELSE 0 END) AS home_wins,
    ROUND(SUM(CASE WHEN m.match_result = 'Home Win' THEN 1 ELSE 0 END) / COUNT(m.match_api_id) * 100 - 33.33, 2) AS home_advantage_index
FROM {{ ref('fact_matches') }} m
JOIN {{ ref('dim_leagues') }} l ON m.league_id = l.league_id
GROUP BY 1, 2, 3 -- league_id, league_name ve season için gruplandırma