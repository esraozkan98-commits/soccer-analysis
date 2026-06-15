-- ligler: id, bagli oldugu ulke ve lig adi
with source as (
    select * from {{ source('soccer_raw', 'League') }}
)
select
    id   as league_id,    -- lig kimligi
    country_id,           -- bagli oldugu ulke (zaten dogru isimde)
    name as league_name   -- Premier League, La Liga, Serie A...
from source