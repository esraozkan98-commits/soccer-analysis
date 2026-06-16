-- models/core/facts/fact_matches.sql
-- Kaynak: stg_matches
-- İş mantığı:
--   1. match_result hesapla (Home Win / Away Win / Draw)
--   2. total_goals hesapla
--   3. Bahisçi favori tarafını belirle (KPI katmanı için)

SELECT
    match_api_id,
    league_id,
    season,
    match_date,
    home_team_api_id,
    away_team_api_id,
    home_team_goal,
    away_team_goal,
    CASE
        WHEN home_team_goal > away_team_goal THEN 'Home Win'
        WHEN home_team_goal < away_team_goal THEN 'Away Win'
        ELSE 'Draw'
    END AS match_result,
    (home_team_goal + away_team_goal)  AS total_goals,

    -- Bahis oranları (null olabilir, sadece B365 olan maçlarda dolu)
    odds_home,
    odds_draw,
    odds_away,
    CASE
        WHEN odds_home < odds_away AND odds_home < odds_draw THEN 'Home Favorite'
        WHEN odds_away < odds_home AND odds_away < odds_draw THEN 'Away Favorite'
        ELSE 'Draw/Close'
    END AS bookmaker_favorite

FROM {{ ref('stg_matches') }}