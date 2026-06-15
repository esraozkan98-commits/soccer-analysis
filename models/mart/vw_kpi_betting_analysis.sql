{{ config(materialized='table') }}
SELECT 
    season, 
    AVG(total_goals) as avg_goals
FROM {{ ref('fact_matches') }}
GROUP BY 1
