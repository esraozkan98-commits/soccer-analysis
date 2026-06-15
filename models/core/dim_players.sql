{{ config(materialized='table') }}

SELECT
    player_api_id,
    player_name,
    birthday,
    height,
    weight AS weight_lbs,
    ROUND(weight * 0.453592, 1) AS weight_kg
FROM
    {{ source('european_soccer', 'Player') }}