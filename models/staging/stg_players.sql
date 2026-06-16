-- models/staging/stg_players.sql
-- Ham Player tablosunu okur, sadece kullanacağımız sütunları seçer.

SELECT
    player_api_id,
    player_name,
    DATE(CAST(birthday AS TIMESTAMP))  AS birthday,  
    height,
    weight
FROM {{ source('european_soccer', 'Player') }}
WHERE player_api_id IS NOT NULL                       