{{ config(materialized='table') }}

SELECT
    match_api_id,
    league_id,
    season,
    home_team_api_id, -- Bu sütunu ekle
    away_team_api_id,
    home_team_goal,
    away_team_goal,
    home_player_1,
    (home_team_goal + away_team_goal) AS total_goals, -- Bu sütunu ekle
    CASE 
        WHEN home_team_goal > away_team_goal THEN 'Home Win'
        WHEN home_team_goal < away_team_goal THEN 'Away Win'
        ELSE 'Draw' 
    END AS match_result
FROM {{ source('european_soccer', 'Match') }}