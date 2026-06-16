-- models/staging/stg_player_attributes.sql

SELECT
    player_api_id,
    DATE(CAST(date AS TIMESTAMP))  AS assessment_date,
    overall_rating,
    potential,
    preferred_foot,
    attacking_work_rate,
    defensive_work_rate,
    crossing,
    finishing,
    short_passing,
    dribbling,
    sprint_speed,
    stamina
FROM {{ source('european_soccer', 'Player_Attributes') }}
WHERE overall_rating IS NOT NULL