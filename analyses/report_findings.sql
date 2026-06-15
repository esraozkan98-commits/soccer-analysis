
-- BULGU 1: Ev sahibi avantaji gercek mi?
-- Tum maclarda ev/deplasman galibiyet oranlarini ve
-- mac basina ortalama gol sayilarini karsilastiriyoruz.

select
  count(*) as total_matches,                                                     -- toplam mac sayisi
  -- result kolonu 'home_win'/'draw'/'away_win' tutuyor; her sonuca 1/0 yazip
  -- ortalamasini alinca o sonucun gerceklesme orani cikiyor
  round(avg(case when result = 'home_win' then 1 else 0 end), 3) as home_win_rate,  -- ev sahibi kazanma orani
  round(avg(case when result = 'draw'     then 1 else 0 end), 3) as draw_rate,      -- beraberlik orani
  round(avg(case when result = 'away_win' then 1 else 0 end), 3) as away_win_rate,  -- deplasman kazanma orani
  round(avg(home_team_goal), 2) as avg_home_goals,                               -- ort. ev sahibi golu
  round(avg(away_team_goal), 2) as avg_away_goals                                -- ort. deplasman golu
from dbt_soccer.int_match_results;



-- BULGU 2: Hangi ligler daha gollu, ev avantaji nerede yuksek?
-- Hazir lig ozeti tablomuzu gol ortalamasina gore sıraladık.
select *
from dbt_soccer.mart_league_summary
order by avg_goals_per_match desc;   -- en gollu ligler en uste gelsin


-- BULGU 3: En cok sampiyonluk yasayan kulupler.
-- mart'ta league_rank = 1 olan her satir, o lig+sezonun sampiyonu;
-- bunlari takima gore sayiyoruz.
select
  team_long_name,
  count(*) as title_count          -- kac kez 1. olmus = sampiyonluk sayisi
from dbt_soccer.mart_team_season_performance
where league_rank = 1              -- sadece sampiyon olanlar
group by team_long_name
order by title_count desc
limit 10;


-- BULGU 4: Oyun stili basariyi etkiliyor mu?
-- Her takim icin (a) sezon basina ort. puan, (b) ort. oyun-stili
-- metrikleri cikarip corr() ile iliskiye bakiyoruz.
-- corr: +1'e yakin = guclu pozitif, 0 = iliski yok, -1 = negatif.

with team_points as (   -- her takimin sezon basina ortalama puani
  select team_api_id, avg(total_points) as avg_points
  from dbt_soccer.mart_team_season_performance
  group by team_api_id
),
team_style as (         -- her takimin ortalama oyun-stili metrikleri
  select team_api_id,
         avg(build_up_play_speed)      as speed,
         avg(chance_creation_shooting) as shooting,
         avg(defence_pressure)         as pressure,
         avg(defence_aggression)       as aggression
  from dbt_soccer.stg_team_attributes
  group by team_api_id
)
select
  round(corr(s.speed, p.avg_points), 3)      as corr_speed_points,      -- hiz <-> puan
  round(corr(s.shooting, p.avg_points), 3)   as corr_shooting_points,   -- sut egilimi <-> puan
  round(corr(s.pressure, p.avg_points), 3)   as corr_pressure_points,   -- savunma baskisi <-> puan
  round(corr(s.aggression, p.avg_points), 3) as corr_aggression_points  -- agresiflik <-> puan
from team_style s
join team_points p on s.team_api_id = p.team_api_id;



-- BULGU 5: Bahis oranlari sonucu ne kadar iyi tahmin ediyor?
-- En dusuk oran = bahiscinin favorisi (en olasi gordugu sonuc).
-- Favori gercek sonucla ne siklikla ortusuyor onu olcuyoruz.

with predictions as (
  select
    result,                          -- gercek mac sonucu
    -- uc orandan en dususu hangi sonuca aitse, bahiscinin favorisi odur
    case
      when bet365_home_win <= bet365_draw and bet365_home_win <= bet365_away_win then 'home_win'
      when bet365_away_win <= bet365_draw and bet365_away_win <= bet365_home_win then 'away_win'
      else 'draw'
    end as favorite
  from dbt_soccer.int_match_results
  where bet365_home_win is not null  -- orani girilmemis maclari disla
)
select
  count(*) as matches_with_odds,                                                    -- orani olan mac sayisi
  round(avg(case when result = favorite then 1 else 0 end), 3) as favorite_hit_rate  -- favori tutturma orani
from predictions;