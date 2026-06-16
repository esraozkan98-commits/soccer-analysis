

  # ─────────────────────────────────────────
  # BOYUT TABLOLARI
  # ─────────────────────────────────────────

  - name: dim_players
    description: "Oyuncu boyut tablosu — pound→kg dönüşümü yapılmış"
    columns:
      - name: player_api_id
        tests:
          - not_null
          - unique
      - name: player_name
        tests:
          - not_null
      - name: weight_kg
        tests:
          - not_null

  - name: dim_teams
    description: "Takım boyut tablosu"
    columns:
      - name: team_api_id
        tests:
          - not_null
          - unique
      - name: team_name
        tests:
          - not_null

  - name: dim_leagues
    description: "Lig boyut tablosu — League + Country JOIN'i yapılmış"
    columns:
      - name: league_id
        tests:
          - not_null
          - unique
      - name: league_name
        tests:
          - not_null
      - name: country_name
        tests:
          - not_null

  # ─────────────────────────────────────────
  # FACT TABLOLARI
  # ─────────────────────────────────────────

  - name: fact_player_attributes
    description: >
      Her oyuncunun yalnızca en güncel rating kaydı.
      ROW_NUMBER=1 filtresi sayesinde player_api_id burada UNIQUE olmalı.
    columns:
      - name: player_api_id
        tests:
          - not_null
          - unique                          # Artık tekil olmalı (ROW_NUMBER=1)
          - relationships:                  # Bu ID dim_players'da var mı?
              to: ref('dim_players')
              field: player_api_id
      - name: overall_rating
        tests:
          - not_null
      - name: preferred_foot
        tests:
          - accepted_values:
              values: ['left', 'right', 'unknown']    # CASE WHEN'in üretebileceği 3 değer
      - name: attacking_work_rate
        tests:
          - accepted_values:
              values: ['low', 'medium', 'high']       # Normalize ettik, başka değer olmamalı
      - name: defensive_work_rate
        tests:
          - accepted_values:
              values: ['low', 'medium', 'high']

  - name: fact_matches
    description: >
      Tüm maç verileri — match_result ve total_goals hesaplanmış.
      Bahisçi favori tarafı (bookmaker_favorite) da burada türetilmiş.
    columns:
      - name: match_api_id
        tests:
          - not_null
          - unique
      - name: league_id
        tests:
          - not_null
          - relationships:                  # Bu lig dim_leagues'da tanımlı mı?
              to: ref('dim_leagues')
              field: league_id
      - name: home_team_api_id
        tests:
          - not_null
          - relationships:                  # Ev sahibi takım dim_teams'de var mı?
              to: ref('dim_teams')
              field: team_api_id
      - name: away_team_api_id
        tests:
          - not_null
          - relationships:                  # Deplasman takımı dim_teams'de var mı?
              to: ref('dim_teams')
              field: team_api_id
      - name: home_team_goal
        tests:
          - not_null
      - name: away_team_goal
        tests:
          - not_null
      - name: match_result
        tests:
          - not_null
          - accepted_values:
              values: ['Home Win', 'Away Win', 'Draw']   # CASE WHEN'in 3 mümkün çıktısı
      - name: total_goals
        tests:
          - not_null
      - name: bookmaker_favorite
        tests:
          - accepted_values:
              values: ['Home Favorite', 'Away Favorite', 'Draw/Close']
              # NULL'lar kabul edilir — B365 verisi olmayan maçlar
              config:
                where: "bookmaker_favorite IS NOT NULL"