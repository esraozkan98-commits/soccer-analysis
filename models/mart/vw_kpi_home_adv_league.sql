{{ config(materialized='view') }}

SELECT
    l.league_name,
    COUNT(m.match_api_id) AS total_matches,
    ROUND(SUM(CASE WHEN m.match_result = 'Home Win' THEN 1 ELSE 0 END) / COUNT(m.match_api_id) * 100, 1) AS home_win_rate_pct,
    ROUND(SUM(CASE WHEN m.match_result = 'Away Win' THEN 1 ELSE 0 END) / COUNT(m.match_api_id) * 100, 1) AS away_win_rate_pct,
    ROUND(SUM(CASE WHEN m.match_result = 'Draw' THEN 1 ELSE 0 END) / COUNT(m.match_api_id) * 100, 1) AS draw_rate_pct,
    ROUND(AVG(m.home_team_goal), 2) AS avg_goals_scored_at_home,
    ROUND(AVG(m.away_team_goal), 2) AS avg_goals_conceded_at_home
FROM
    {{ ref('fact_matches') }} m
JOIN {{ ref('dim_leagues') }} l ON m.league_id = l.league_id
GROUP BY 1
ORDER BY home_win_rate_pct DESC
