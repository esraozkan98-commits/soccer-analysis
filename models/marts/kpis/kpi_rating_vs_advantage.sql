-- models/marts/kpis/kpi_rating_vs_advantage.sql


SELECT
    CASE
        WHEN home_win_rate_pct >= 60 THEN 'Tier 1 (Dominant at Home)'
        WHEN home_win_rate_pct >= 45 THEN 'Tier 2 (Strong at Home)'
        ELSE                               'Tier 3 (Weak at Home)'
    END AS team_strength_tier,
    COUNT(team_name)                           AS number_of_teams,
    ROUND(AVG(home_win_rate_pct), 2)           AS average_home_win_rate,
    ROUND(AVG(avg_goals_scored_at_home), 2)    AS avg_home_goals
FROM {{ ref('kpi_home_adv_team') }}    
GROUP BY 1
ORDER BY average_home_win_rate DESC