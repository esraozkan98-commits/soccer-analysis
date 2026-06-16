-- models/marts/kpis/kpi_home_adv_team.sql

SELECT
    l.league_name,
    t.team_name,
    COUNT(m.match_api_id)                                                                       AS total_home_matches,
    ROUND(SUM(CASE WHEN m.match_result = 'Home Win' THEN 1 ELSE 0 END) / COUNT(m.match_api_id) * 100, 1) AS home_win_rate_pct,
    ROUND(AVG(m.home_team_goal), 2)                                                             AS avg_goals_scored_at_home,
    ROUND(AVG(m.away_team_goal), 2)                                                             AS avg_goals_conceded_at_home
FROM {{ ref('fact_matches') }}  m
JOIN {{ ref('dim_leagues') }}   l  ON m.league_id = l.league_id
JOIN {{ ref('dim_teams') }}     t  ON m.home_team_api_id = t.team_api_id
GROUP BY 1, 2
HAVING COUNT(m.match_api_id) > 30
ORDER BY home_win_rate_pct DESC