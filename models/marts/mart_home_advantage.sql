-- models/marts/mart_home_advantage.sql
-- Lig + sezon bazında ev sahibi avantaj metrikleri

SELECT
    l.league_name,
    m.season,
    COUNT(m.match_api_id)                                                             AS total_matches,
    SUM(CASE WHEN m.match_result = 'Home Win' THEN 1 ELSE 0 END)                     AS home_wins,
    SUM(CASE WHEN m.match_result = 'Away Win' THEN 1 ELSE 0 END)                     AS away_wins,
    SUM(CASE WHEN m.match_result = 'Draw'     THEN 1 ELSE 0 END)                     AS draws,
    ROUND(SUM(CASE WHEN m.match_result = 'Home Win' THEN 1 ELSE 0 END)
          / COUNT(m.match_api_id) * 100, 2)                                           AS home_win_percentage,
    ROUND(SUM(CASE WHEN m.match_result = 'Away Win' THEN 1 ELSE 0 END)
          / COUNT(m.match_api_id) * 100, 2)                                           AS away_win_percentage,
    ROUND(SUM(CASE WHEN m.match_result = 'Draw'     THEN 1 ELSE 0 END)
          / COUNT(m.match_api_id) * 100, 2)                                           AS draw_percentage,
    ROUND(SUM(CASE WHEN m.match_result = 'Home Win' THEN 1 ELSE 0 END)
          / COUNT(m.match_api_id) * 100 - 33.33, 2)                                  AS home_advantage_index,
    ROUND(AVG(m.home_team_goal), 2)                                                   AS avg_home_goals,
    ROUND(AVG(m.away_team_goal), 2)                                                   AS avg_away_goals
FROM {{ ref('fact_matches') }}  m
JOIN {{ ref('dim_leagues') }}   l  ON m.league_id = l.league_id
GROUP BY l.league_name, m.season