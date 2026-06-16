-- models/staging/stg_matches.sql
-- B365 bahis oranlarını da alıyoruz (KPI katmanında kullanılacak)

SELECT
    match_api_id,
    league_id,
    season,
    DATE(CAST(date AS TIMESTAMP))  AS match_date,
    home_team_api_id,
    away_team_api_id,
    home_team_goal,
    away_team_goal,
    B365H  AS odds_home,   -- Bet365 ev sahibi kazanma oranı
    B365D  AS odds_draw,   -- Bet365 beraberlik oranı
    B365A  AS odds_away    -- Bet365 deplasman kazanma oranı
FROM {{ source('european_soccer', 'Match') }}
WHERE match_api_id IS NOT NULL