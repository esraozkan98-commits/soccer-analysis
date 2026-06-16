-- models/core/dimensions/dim_leagues.sql
-- 2 staging modeli birleşiyor (stg_leagues + stg_countries)


SELECT
    l.league_id,
    c.country_name,
    l.league_name
FROM {{ ref('stg_leagues') }}   l
INNER JOIN {{ ref('stg_countries') }}  c  ON l.country_id = c.country_id