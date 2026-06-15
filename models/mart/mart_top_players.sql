{{ config(materialized='table') }}

SELECT
    p.player_name,
    ROUND(DATE_DIFF(a.assessment_date, DATE(CAST(p.birthday AS TIMESTAMP)), DAY) / 365.25, 1) AS estimated_age,
    a.overall_rating,
    a.potential,
    a.preferred_foot,
    a.sprint_speed,
    a.finishing
FROM
    {{ ref('dim_players') }} p
JOIN
    {{ ref('fact_player_attributes') }} a 
    ON p.player_api_id = a.player_api_id
ORDER BY
    a.overall_rating DESC
LIMIT 500
