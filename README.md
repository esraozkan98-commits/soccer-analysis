# soccer-analysis
# European Soccer Analysis — dbt + BigQuery

Avrupa'nın 5 büyük ligine ait futbol verilerini BigQuery üzerinde Star Schema mimarisiyle modelleyen, dbt ile katmanlı pipeline'a dönüştürülmüş bir veri analiz projesidir.

---

## Proje Özeti

Kaggle'dan alınan ham futbol verisini;
- **Boyut ve Fact tablolarına** dönüştürerek Star Schema kurduk
- **dbt pipeline'ı** ile staging → core → marts → kpi katmanlarına ayırdık
- **50 otomatik test** ile veri kalitesini güvence altına aldık
- **Looker** bağlantısına hazır KPI view'ları ürettik

---


##  Veri Kaynakları (Sources)

Ham veriler `soccer-analysis-499207.european_soccer` veri setinden gelmektedir.

| Tablo | Açıklama |
|---|---|
| `Player` | Oyuncu kimlik ve fiziksel bilgileri |
| `Player_Attributes` | Oyuncu rating geçmişi (FIFA benzeri) |
| `Team` | Takım isimleri ve kodları |
| `League` | Lig bilgileri |
| `Country` | Ülke adları |
| `Match` | Maç sonuçları ve Bet365 bahis oranları |

---

##  Mimari: Star Schema + Katmanlı dbt Modeli

```
HAM VERİ (BigQuery Sources)
        │
        ▼
┌─────────────────┐
│    STAGING      │  → Ham tabloları okur, tip dönüşümü yapar (VIEW)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│      CORE       │  → Dimension ve Fact tabloları üretir (TABLE)
│  dim_players    │
│  dim_teams      │
│  dim_leagues    │
│  fact_matches   │
│  fact_player_.. │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│     MARTS       │  → İş analizine hazır tablolar (TABLE)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│      KPIs       │  → Looker'a bağlanan view'lar (VIEW)
└─────────────────┘
```

---

##  Klasör Yapısı

```
models/
├── staging/
│   ├── _sources.yml
│   ├── _staging.yml
│   ├── stg_players.sql
│   ├── stg_player_attributes.sql
│   ├── stg_teams.sql
│   ├── stg_leagues.sql
│   ├── stg_countries.sql
│   └── stg_matches.sql
├── core/
│   ├── _core.yml
│   ├── dimensions/
│   │   ├── dim_players.sql
│   │   ├── dim_teams.sql
│   │   └── dim_leagues.sql
│   └── facts/
│       ├── fact_player_attributes.sql
│       └── fact_matches.sql
└── marts/
    ├── _marts.yml
    ├── mart_home_advantage.sql
    ├── mart_team_performance.sql
    ├── mart_top_players.sql
    └── kpis/
        ├── kpi_home_adv_league.sql
        ├── kpi_home_adv_team.sql
        ├── kpi_betting_analysis.sql
        └── kpi_rating_vs_advantage.sql
```

---

## Üretilen Modeller

### Boyut Tabloları (Dimensions)
| Model | Açıklama |
|---|---|
| `dim_players` | Oyuncu bilgileri + pound→kg dönüşümü |
| `dim_teams` | Takım isimleri |
| `dim_leagues` | Lig ve ülke bilgileri (JOIN yapılmış) |

### Fact Tabloları
| Model | Açıklama |
|---|---|
| `fact_matches` | Tüm maçlar — `match_result`, `total_goals`, `bookmaker_favorite` hesaplanmış |
| `fact_player_attributes` | Her oyuncunun en güncel rating kaydı (ROW_NUMBER ile tekilleştirilmiş) |

### Mart Tabloları
| Model | Açıklama |
|---|---|
| `mart_home_advantage` | Lig & sezon bazında ev sahibi avantaj metrikleri |
| `mart_team_performance` | Takım bazında sezonluk performans özeti |
| `mart_top_players` | Overall rating'e göre sıralı ilk 500 oyuncu |

### KPI View'ları (Looker'a bağlı)
| Model | Açıklama |
|---|---|
| `kpi_home_adv_league` | Lig bazında ev/deplasman kazanma oranları |
| `kpi_home_adv_team` | Takım bazında ev avantajı (30+ maç filtreli) |
| `kpi_betting_analysis` | Bet365'in tahmin doğruluk oranı analizi |
| `kpi_rating_vs_advantage` | Takımları ev avantajına göre Tier 1/2/3 olarak sınıflandırma |

---

## Test Kapsamı

```
50 test — 4 katmanda uygulandı

not_null        → Zorunlu sütunlarda boş değer kontrolü
unique          → ID sütunlarında tekrar kontrolü
accepted_values → match_result, preferred_foot, work_rate değer seti kontrolü
relationships   → Fact → Dim foreign key bütünlüğü (BigQuery native FK'ya alternatif)
```

Testleri çalıştırmak için:

```bash
dbt test
```

---

## Projeyi Çalıştırmak

```bash
# Bağlantıyı kontrol et
dbt debug

# Tüm modelleri build et
dbt run

# Tüm testleri çalıştır
dbt test

# Build + test birlikte (önerilen)
dbt build

# DAG görselleştirmesi
dbt docs generate
dbt docs serve
```

---

## Öne Çıkan Analiz Soruları

- Hangi ligde ev sahibi avantajı en yüksek?
- Bahisçiler favori takımı ne kadar doğru tahmin ediyor?
- En yüksek potansiyelli genç oyuncular kimler?
- Sezondan sezona takım performansı nasıl değişiyor?