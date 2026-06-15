{{ config(materialized='table') }}

-- lig bazinda ozet: mac sayisi, ortalama gol, sonuc dagilimi (ev sahibi avantaji)
with matches  as ( select * from {{ ref('int_match_results') }} ),
     leagues  as ( select * from {{ ref('stg_league') }} ),
     countries as ( select * from {{ ref('stg_country') }} ),

summary as (
    select
        league_id,
        count(*)                   as total_matches,        -- toplam mac
        round(avg(total_goals), 2) as avg_goals_per_match,  -- mac basina ortalama gol
        -- oranlar: 1=o sonuc oldu, 0=olmadi; ortalamasi yuzde gibi okunur
        round(avg(case when result = 'home_win' then 1 else 0 end), 3) as home_win_rate,
        round(avg(case when result = 'draw'     then 1 else 0 end), 3) as draw_rate,
        round(avg(case when result = 'away_win' then 1 else 0 end), 3) as away_win_rate
    from matches
    group by league_id
)

select
    l.league_name,
    c.country_name,
    s.total_matches,
    s.avg_goals_per_match,
    s.home_win_rate,
    s.draw_rate,
    s.away_win_rate
from summary s
join leagues   l on s.league_id = l.league_id
join countries c on l.country_id = c.country_id
order by s.avg_goals_per_match desc