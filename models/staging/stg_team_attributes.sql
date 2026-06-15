-- takimlarin zaman icindeki oyun stili metrikleri 
with source as (
    select * from {{ source('soccer_raw', 'Team_Attributes') }}
)
select
    team_api_id,                                          -- takim kimligi (stg_team ile eslesir)
    team_fifa_api_id,                                     -- FIFA kimligi
    date(cast(`date` as timestamp))   as measured_at,     -- olcum tarihi (string/timestamp ne ise duzgun tarihe cevir)
    buildUpPlaySpeed       as build_up_play_speed,        -- hucum baslatma hizi
    buildUpPlayPassing     as build_up_play_passing,      -- hucum baslatmada pas egilimi
    chanceCreationPassing  as chance_creation_passing,    -- firsat yaratmada pas
    chanceCreationCrossing as chance_creation_crossing,   -- orta yapma egilimi
    chanceCreationShooting as chance_creation_shooting,   -- sut egilimi
    defencePressure        as defence_pressure,           -- savunma baskisi
    defenceAggression      as defence_aggression,         -- savunma agresifligi
    defenceTeamWidth       as defence_team_width          -- savunma genisligi
from source