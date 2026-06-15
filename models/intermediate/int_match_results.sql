-- her mac icin hesaplanmis alanlar: toplam gol, gol farki ve sonuc
-- ham tablo degil, kendi stg_match modelimizi kullaniyoruz (ref ile)
with matches as (
    select * from {{ ref('stg_match') }}
)
select
    match_api_id,
    season,
    stage,
    match_date,
    league_id,
    country_id,
    home_team_api_id,
    away_team_api_id,
    home_team_goal,
    away_team_goal,
    home_team_goal + away_team_goal as total_goals,        -- macta atilan toplam gol
    home_team_goal - away_team_goal as goal_difference,    -- ev sahibi acisindan gol farki (+ ise ev onde)
    case
        when home_team_goal > away_team_goal then 'home_win'
        when home_team_goal < away_team_goal then 'away_win'
        else 'draw'
    end as result,                                         -- mac sonucu
    bet365_home_win,
    bet365_draw,
    bet365_away_win
from matches