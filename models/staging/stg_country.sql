-- ham tabloda sadece id ve name var, biz isimleri netlestiriyoruz
with
    source as (select * from {{ source("soccer_raw", "Country") }}),

    cleaned as (

        select
            id as country_id,  -- ulke kimligi
            name as country_name  -- ulke adi: England, France, Spain...
        from source

    )

select *
from cleaned
