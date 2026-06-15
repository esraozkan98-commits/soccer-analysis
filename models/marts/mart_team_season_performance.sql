{{ config(materialized='table') }}

-- takim x sezon performansi + lig ici siralama (RANK window fonksiyonu)
with team_matches as (
    select * from {{ ref('int_team_match_results') }}
),

season_stats as (   -- once sezon bazinda toplamlari cikar
    select
        team_api_id,
        team_long_name,
        league_id,
        season,
        count(*)                                          as matches_played,
        sum(case when outcome = 'win'  then 1 else 0 end) as wins,
        sum(case when outcome = 'draw' then 1 else 0 end) as draws,
        sum(case when outcome = 'loss' then 1 else 0 end) as losses,
        sum(goals_for)                                    as goals_for,
        sum(goals_against)                                as goals_against,
        sum(goal_difference)                              as goal_difference,
        sum(points)                                       as total_points
    from team_matches
    group by team_api_id, team_long_name, league_id, season
)

select
    *,
    -- her lig+sezon icinde puana (esitse averaja) gore sirala; 1 = sampiyon
    rank() over (
        partition by league_id, season
        order by total_points desc, goal_difference desc
    ) as league_rank
from season_stats