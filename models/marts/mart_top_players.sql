-- models/marts/mart_top_players.sql


SELECT
    player_name,
    ROUND(DATE_DIFF(assessment_date, birthday, DAY) / 365.25, 1)  AS estimated_age,
    overall_rating,
    potential,
    preferred_foot,
    sprint_speed,
    finishing
FROM {{ ref('fact_player_attributes') }}
ORDER BY overall_rating DESC
LIMIT 500