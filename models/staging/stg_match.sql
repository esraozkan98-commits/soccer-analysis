-- maclar: temel bilgi, skorlar ve Bet365 bahis oranlari
with source as (
    select * from {{ source('soccer_raw', 'Match') }}
)
select
    match_api_id,                                    -- mac kimligi
    country_id,                                      -- ulke
    league_id,                                       -- lig
    season,                                          -- sezon, orn "2008/2009"
    stage,                                           -- kacinci hafta
    date(cast(`date` as timestamp)) as match_date,   -- mac tarihi
    home_team_api_id,                                -- ev sahibi takim
    away_team_api_id,                                -- deplasman takimi
    home_team_goal,                                  -- ev sahibi gol sayisi
    away_team_goal,                                  -- deplasman gol sayisi
    -- Bet365 oranlari (1 / X / 2): bahis tahmin gucu analizinde kullanacagiz
    B365H as bet365_home_win,                        -- ev sahibi kazanir
    B365D as bet365_draw,                            -- beraberlik
    B365A as bet365_away_win                         -- deplasman kazanir
from source