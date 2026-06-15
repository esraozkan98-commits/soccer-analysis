{{ config(materialized='table') }}

-- oyuncu basina en guncel FIFA olcumu + oyuncu bilgisi
with attributes as ( select * from {{ ref('stg_player_attributes') }} ),
     players    as ( select * from {{ ref('stg_player') }} ),

ranked as (   -- her oyuncunun olcumlerini tarihe gore numarala
    select
        *,
        row_number() over (partition by player_api_id order by rating_date desc) as rn
    from attributes
),

latest as ( select * from ranked where rn = 1 )   -- sadece en guncel olcum

select
    p.player_id,
    p.player_name,
    p.birth_date,
    p.height,
    p.weight,
    l.rating_date,
    l.overall_rating,        -- analizde tahmin etmeye calisacagimiz hedef
    l.potential,
    l.preferred_foot,
    l.crossing, l.finishing, l.short_passing, l.dribbling, l.ball_control,
    l.acceleration, l.sprint_speed, l.shot_power, l.stamina, l.strength,
    l.vision, l.standing_tackle, l.sliding_tackle,
    l.gk_diving, l.gk_reflexes
from latest l
join players p on l.player_api_id = p.player_api_id