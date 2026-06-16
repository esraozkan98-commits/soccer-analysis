-- models/core/facts/fact_player_attributes.sql
-- Kaynak: stg_player_attributes + dim_players
-- İş mantığı: 
--   1. ROW_NUMBER ile en güncel rating kaydını seç
--   2. Geçersiz kategori değerlerini ('low','medium','high' dışını) 'medium'a çek

WITH ranked_attributes AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY player_api_id
            ORDER BY assessment_date DESC
        ) AS row_num
    FROM {{ ref('stg_player_attributes') }}
)

SELECT
    p.player_api_id,
    p.player_name,
    p.birthday,
    a.assessment_date,
    a.overall_rating,
    a.potential,
    CASE
        WHEN a.preferred_foot IN ('left', 'right')
        THEN a.preferred_foot
        ELSE 'unknown'
    END AS preferred_foot,
    CASE
        WHEN a.attacking_work_rate IN ('low', 'medium', 'high')
        THEN a.attacking_work_rate
        ELSE 'medium'
    END AS attacking_work_rate,
    CASE
        WHEN a.defensive_work_rate IN ('low', 'medium', 'high')
        THEN a.defensive_work_rate
        ELSE 'medium'
    END AS defensive_work_rate,
    a.crossing,
    a.finishing,
    a.short_passing,
    a.dribbling,
    a.sprint_speed,
    a.stamina
FROM {{ ref('dim_players') }}  p
INNER JOIN ranked_attributes  a  ON p.player_api_id = a.player_api_id
WHERE a.row_num = 1             -- sadece en güncel kaydı al