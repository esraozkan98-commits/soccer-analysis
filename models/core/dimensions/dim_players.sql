-- models/core/dimensions/dim_players.sql
-- pound → kg dönüşümü

SELECT
    player_api_id,
    player_name,
    birthday,
    height,
    weight                              AS weight_lbs,
    ROUND(weight * 0.453592, 1)         AS weight_kg
FROM {{ ref('stg_players') }}           -- ← ref() ile staging'e bağlanıyoruz