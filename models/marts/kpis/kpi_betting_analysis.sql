-- models/marts/kpis/kpi_betting_analysis.sql

SELECT
    bookmaker_favorite,
    COUNT(match_api_id)                                         AS total_matches_predicted,
    SUM(CASE
        WHEN bookmaker_favorite = 'Home Favorite' AND match_result = 'Home Win' THEN 1
        WHEN bookmaker_favorite = 'Away Favorite' AND match_result = 'Away Win' THEN 1
        ELSE 0
    END)                                                        AS correct_predictions,
    ROUND(SUM(CASE
        WHEN bookmaker_favorite = 'Home Favorite' AND match_result = 'Home Win' THEN 1
        WHEN bookmaker_favorite = 'Away Favorite' AND match_result = 'Away Win' THEN 1
        ELSE 0
    END) / COUNT(match_api_id) * 100, 2)                        AS bookmaker_accuracy_pct
FROM {{ ref('fact_matches') }}
WHERE odds_home IS NOT NULL    -- sadece B365 verisi olan maçları dahil et
GROUP BY 1