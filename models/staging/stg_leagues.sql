-- models/staging/stg_leagues.sql
-- League tablosunu okur. Country ile JOIN'i dim katmanında yapacağız.

SELECT
    id          AS league_id,
    country_id,
    name        AS league_name
FROM {{ source('european_soccer', 'League') }}