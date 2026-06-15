{{ config(materialized='table') }}

WITH RankedAttributes AS (
    SELECT 
        player_api_id,
        DATE(CAST(date AS TIMESTAMP)) AS assessment_date,
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
        stamina,
        ROW_NUMBER() OVER(PARTITION BY player_api_id ORDER BY CAST(date AS TIMESTAMP) DESC) as row_num
    FROM 
        {{ source('european_soccer', 'Player_Attributes') }}
    WHERE
        overall_rating IS NOT NULL
)
SELECT
    p.player_api_id,
    p.player_name,
    p.birthday,
    a.assessment_date,
    a.overall_rating,
    a.potential,
    CASE WHEN a.preferred_foot IN ('left', 'right') THEN a.preferred_foot ELSE 'unknown' END AS preferred_foot,
    CASE WHEN a.attacking_work_rate IN ('low', 'medium', 'high') THEN a.attacking_work_rate ELSE 'medium' END AS attacking_work_rate,
    CASE WHEN a.defensive_work_rate IN ('low', 'medium', 'high') THEN a.defensive_work_rate ELSE 'medium' END AS defensive_work_rate,
    a.crossing,
    a.finishing,
    a.short_passing,
    a.dribbling,
    a.sprint_speed,
    a.stamina
FROM
    {{ ref('dim_players') }} p
INNER JOIN
    RankedAttributes a ON p.player_api_id = a.player_api_id
WHERE 
    a.row_num = 1