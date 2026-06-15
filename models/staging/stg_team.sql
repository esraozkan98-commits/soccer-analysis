-- takimlar: kimlikler ve isimler
with source as (
    select * from {{ source('soccer_raw', 'Team') }}
)
select
    id               as team_id,    -- ic kimlik
    team_api_id,                    -- mac tablosunda kullanilan kimlik (onemli)
    team_fifa_api_id,               -- takim ozellikleri tablosuna baglayan kimlik
    team_long_name,                 -- tam ad: Manchester United
    team_short_name                 -- kisa ad: MUN
from source