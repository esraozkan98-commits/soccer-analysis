-- oyuncular: kimlik, isim, dogum tarihi, fiziksel olculer
with source as (
    select * from {{ source('soccer_raw', 'Player') }}
)
select
    id                 as player_id,    -- ic kimlik
    player_api_id,                      -- mac & ozellik tablolarinda kullanilan kimlik
    player_fifa_api_id,                 -- FIFA kimligi
    player_name,                        -- oyuncu adi
    birthday           as birth_date,   -- dogum tarihi
    height,                             -- boy (cm)
    weight                              -- kilo (lbs)
from source