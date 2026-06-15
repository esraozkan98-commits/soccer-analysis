{{ config(materialized='table') }}

SELECT 
    mha.league_name, 
    mha.season,
    AVG(pa.overall_rating) as avg_rating, 
    AVG(mha.home_advantage_index) as avg_adv
FROM {{ ref('fact_player_attributes') }} pa
JOIN {{ ref('fact_matches') }} m ON pa.player_api_id = m.home_player_1 
JOIN {{ ref('mart_home_advantage') }} mha ON m.league_id = mha.league_id AND m.season = mha.season
GROUP BY 1, 2