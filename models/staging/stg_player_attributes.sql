-- oyuncularin zaman icindeki FIFA ozellikleri (overall_rating, dribbling, ...)
with source as (
    select * from {{ source('soccer_raw', 'Player_Attributes') }}
)
select
    * except(`date`),                                 -- tum yetenek kolonlarini oldugu gibi al
    date(cast(`date` as timestamp)) as rating_date    -- olcum tarihi
from source