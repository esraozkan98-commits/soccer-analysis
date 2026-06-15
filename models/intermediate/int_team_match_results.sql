-- her maci ev/deplasman olarak iki satira aciyoruz (UNION ALL)
with matches as (
    select * from {{ ref('int_match_results') }}
),

home as (   -- ev sahibi bakisi
    select
        match_api_id, season, league_id, match_date,
        home_team_api_id as team_api_id,
        'home' as venue,
        home_team_goal as goals_for,
        away_team_goal as goals_against,
        result
    from matches
),

away as (   -- deplasman bakisi
    select
        match_api_id, season, league_id, match_date,
        away_team_api_id as team_api_id,
        'away' as venue,
        away_team_goal as goals_for,
        home_team_goal as goals_against,
        result
    from matches
),

combined as (
    select * from home
    union all
    select * from away
)

select
    c.match_api_id,
    c.season,
    c.league_id,
    c.match_date,
    c.team_api_id,
    t.team_long_name,                                   -- takim adini stg_team'den ekliyoruz
    c.venue,
    c.goals_for,
    c.goals_against,
    c.goals_for - c.goals_against as goal_difference,
    case                                                -- bu takim icin sonuc
        when c.goals_for > c.goals_against then 'win'
        when c.goals_for < c.goals_against then 'loss'
        else 'draw'
    end as outcome,
    case                                                -- galibiyet 3, beraberlik 1, maglubiyet 0 puan
        when c.goals_for > c.goals_against then 3
        when c.goals_for = c.goals_against then 1
        else 0
    end as points
from combined c
left join {{ ref('stg_team') }} t
    on c.team_api_id = t.team_api_id