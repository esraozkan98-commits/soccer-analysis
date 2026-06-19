# ⚽ Avrupa Futbol Ligleri Analizi
### Uçtan Uca Veri Projesi · 2008–2016 · BigQuery · dbt · Python · Looker

Avrupa'nın 11 futbol ligine ait 8 sezonluk veriyi (≈26.000 maç, 11.000+ oyuncu) uçtan uca bir veri pipeline'ından geçirerek **ev sahibi avantajını** istatistiksel ve makine öğrenmesi yöntemleriyle analiz eden bir projedir.

---

## 👥 Ekip ve Görev Dağılımı

| Üye | Sorumluluk |
|---|---|
| **Beril Erdem** | Veri mühendisliği — SQLite→BigQuery aktarımı, dbt modelleme, Star Schema mimarisi, SQL analizi, veri kalitesi testleri |
| **Esra Özkan** | İstatistiksel analiz & makine öğrenmesi — hipotez testleri, lojistik regresyon & random forest modelleri (Python) |
| **Gamze Barış** | Görselleştirme & raporlama — Looker Studio dashboard tasarımı, KPI panoları |

---

## 🎯 Projenin Amacı

Tek bir merkezi soru: **Avrupa futbolunda ev sahibi olmak gerçekten bir avantaj mı, yoksa algısal bir yanılgı mı?**

Bu soruyu yanıtlamak için ham veriyi buluta taşıdık, modelledik, SQL'le keşfettik, Python'la istatistiksel olarak test ettik, makine öğrenmesiyle maç sonucu tahmin ettik ve sonuçları interaktif bir dashboard'da görselleştirdik.

---

## 🛠️ Teknoloji Yığını

`SQLite (kaynak)` · `Google BigQuery` · `dbt (Cloud)` · `GitHub` · `Python (pandas, scikit-learn, scipy, statsmodels)` · `Google Colab` · `Looker Studio`

---

## 📊 Veri Kaynağı

[Kaggle — European Soccer Database](https://www.kaggle.com/datasets/hugomathien/soccer)

| Ham Tablo | İçerik |
|---|---|
| `Country` | Ülke bilgileri |
| `League` | Lig bilgileri |
| `Team` | Takım isim ve kodları |
| `Player` | Oyuncu kimlik ve fiziksel bilgileri |
| `Match` | Maç sonuçları, goller, bahis oranları, lineup'lar |
| `Team_Attributes` | Takım taktiksel özellikleri |
| `Player_Attributes` | Oyuncu rating geçmişi (FIFA benzeri) |

---

## 🗺️ Proje Akışı (6 Faz)

### Faz 1 — Veri Aktarımı · *Beril Erdem*
313 MB'lık `database.sqlite` dosyasındaki 7 tabloyu Python ile okuyup BigQuery'deki `soccer_raw` veri setine aktardık. Tüm ham veri bulutta, SQL ile sorgulanabilir hale geldi.

```python
import sqlite3, pandas as pd
from google.cloud import bigquery

con = sqlite3.connect("database.sqlite")
client = bigquery.Client(project="...")

tablolar = ["Country","League","Team","Player","Match","Team_Attributes","Player_Attributes"]
for t in tablolar:
    df = pd.read_sql(f"SELECT * FROM {t}", con)
    client.load_table_from_dataframe(df, f"...soccer_raw.{t.lower()}").result()
```

---

### Faz 2 — dbt ile Modelleme · *Beril Erdem*
Ham veriyi dbt ile temizleyip katmanlı bir **Star Schema** modeline dönüştürdük. Toplam **18 model** ve **50 otomatik test**.

```
models/
├── staging/      → 6 model: ham tabloların temizlenmiş hâli (stg_*)
├── core/
│   ├── dimensions/ → dim_leagues, dim_players, dim_teams
│   └── facts/      → fact_matches, fact_player_attributes
└── marts/        → mart_* (analize hazır) + kpis/ (Looker'a bağlı view'lar)
```

Katman mantığı: `staging → core → marts → kpis`. Her model `{{ ref() }}` ile bir öncekine bağlanır, böylece bağımlılık grafiği (DAG) otomatik yönetilir. Veri kalitesi `not_null`, `unique`, `accepted_values` ve `relationships` testleriyle güvence altına alındı.

---

### Faz 3 — SQL Analizi · *Beril Erdem*
dbt modellerinin üstünden BigQuery SQL sorgularıyla temel keşifleri yaptık.

**Öne çıkan bulgular:**
- Ev sahibi galibiyeti **%45.9**, beraberlik %25.4, deplasman %28.7 — net ev avantajı
- En gollü lig **Hollanda** (3.08 gol/maç), en az gollü **Polonya** (2.42)
- Türetilmiş metrikler: `home_advantage_index` (%33.3 eşitlik noktasından sapma) ve takım `tier` sınıflandırması (dominant / güçlü / zayıf)

---

### Faz 4 — İstatistiksel Testler · *Esra Özkan*
4 hipotez, 4 farklı istatistik testi (Python · Colab):

| # | Hipotez | Test | Sonuç |
|---|---|---|---|
| H1 | Ev avantajı gerçek mi? | Ki-kare | p≈0, anlamlı |
| H2 | Bahis favorisi tutuyor mu? | Binom | %53.3 isabet |
| H3 | Ev sahibi farklı mı oynuyor? | Eşli t-testi | +possession, −faul/kart |
| H4 | Takım kalitesi sonucu belirliyor mu? | Pearson + Lojistik reg. | r=0.45 |

Dört hipotez de istatistiksel olarak doğrulandı. Denk takımlarda bile ev galibiyet olasılığı **%44.9** — yani ev avantajı sadece kalite farkından kaynaklanmıyor.

---

### Faz 5 — Makine Öğrenmesi · *Esra Özkan*
Maç sonucunu (ev / beraberlik / deplasman) tahmin eden modeller eğitildi. Veri %80 eğitim / %20 test olarak bölündü.

| Yöntem | Doğruluk |
|---|---|
| Rastgele (temel) | %33.3 |
| Hep ev sahibi | %45.9 |
| Bahis favorisi | %52.9 |
| **Lojistik regresyon** | **%53.5** ✅ |
| Random Forest | %45.4 |

**Ana bulgu:** Lojistik regresyon hem bahis favorisini hem random forest'ı geçti. "Daha karmaşık model her zaman daha iyi değildir" — en belirleyici özellik `rating_diff` (reyting farkı) oldu.

---

### Faz 6 — Görselleştirme · *Gamze Barış*
Tüm bulgular Looker Studio'da çok sayfalı interaktif bir dashboard'da görselleştirildi:

- **Genel Bakış** — toplam maç, gol, lig, oyuncu KPI'ları
- **Lig & Maç** — ev avantajı, sonuç dağılımı, lig bazında goller
- **Takım Analizi** — en başarılı kulüpler, hücum-savunma scatter'ı
- **Oyuncu Analizi** — rating dağılımı, en iyi oyuncular
- **İstatistik & ML** — hipotez sonuçları, model karşılaştırmaları

---

## 📁 Repo Yapısı

```
soccer-analysis/
├── dbt_project.yml
├── models/
│   ├── staging/          # ham veri temizliği
│   ├── core/             # dim + fact (Star Schema)
│   └── marts/            # analiz tabloları + kpi view'ları
├── analyses/
│   └── report_findings.sql
├── soccer_analysis.ipynb # Python: istatistik + ML
└── README.md
```

---

## 🏆 Sonuç

Üç ana çıkarım:

1. **Ev avantajı gerçek ve istatistiksel olarak kanıtlı** — denk takımlarda bile sürüyor.
2. **Takım kalitesi sonucu belirleyen en önemli faktör** ama ev avantajını ortadan kaldırmıyor.
3. **Basit model (lojistik regresyon) karmaşık modeli (random forest) geçti** — model seçiminde karmaşıklık her zaman avantaj değil.



# ⚽ European Football League Analysis
### End-to-End Data Project · 2008–2016 · BigQuery · dbt · Python · Looker

An end-to-end data pipeline analyzing **home advantage** across 11 European football leagues over 8 seasons (≈26,000 matches, 11,000+ players), using statistical testing and machine learning.

---

## 👥 Team & Responsibilities

| Member | Responsibility |
|---|---|
| **Beril Erdem** | Data engineering — SQLite→BigQuery migration, dbt modeling, Star Schema architecture, SQL analysis, data quality tests |
| **Esra Özkan** | Statistical analysis & machine learning — hypothesis testing, logistic regression & random forest models (Python) |
| **Gamze Barış** | Visualization & reporting — Looker Studio dashboard design, KPI panels |

---

## 🎯 Project Goal

One central question: **Is home advantage in European football real, or just a perceived illusion?**

To answer this, we migrated raw data to the cloud, modeled it, explored it with SQL, tested it statistically with Python, predicted match outcomes with machine learning, and visualized the results in an interactive dashboard.

---

## 🛠️ Tech Stack

`SQLite (source)` · `Google BigQuery` · `dbt (Cloud)` · `GitHub` · `Python (pandas, scikit-learn, scipy, statsmodels)` · `Google Colab` · `Looker Studio`

---

## 📊 Data Source

[Kaggle — European Soccer Database](https://www.kaggle.com/datasets/hugomathien/soccer)

| Raw Table | Content |
|---|---|
| `Country` | Country information |
| `League` | League information |
| `Team` | Team names and codes |
| `Player` | Player identity and physical attributes |
| `Match` | Match results, goals, betting odds, lineups |
| `Team_Attributes` | Team tactical attributes |
| `Player_Attributes` | Player rating history (FIFA-style) |

---

## 🗺️ Project Workflow (6 Phases)

### Phase 1 — Data Migration · *Beril Erdem*
Read 7 tables from the 313 MB `database.sqlite` file using Python and loaded them into the `soccer_raw` dataset in BigQuery. All raw data became cloud-based and queryable via SQL.

```python
import sqlite3, pandas as pd
from google.cloud import bigquery

con = sqlite3.connect("database.sqlite")
client = bigquery.Client(project="...")

tables = ["Country","League","Team","Player","Match","Team_Attributes","Player_Attributes"]
for t in tables:
    df = pd.read_sql(f"SELECT * FROM {t}", con)
    client.load_table_from_dataframe(df, f"...soccer_raw.{t.lower()}").result()
```

---

### Phase 2 — dbt Modeling · *Beril Erdem*
Cleaned and transformed the raw data into a layered **Star Schema** model using dbt. A total of **18 models** and **50 automated tests**.

```
models/
├── staging/      → 6 models: cleaned raw tables (stg_*)
├── core/
│   ├── dimensions/ → dim_leagues, dim_players, dim_teams
│   └── facts/      → fact_matches, fact_player_attributes
└── marts/        → mart_* (analysis-ready) + kpis/ (Looker-facing views)
```

Layer logic: `staging → core → marts → kpis`. Each model connects to the previous one via `{{ ref() }}`, so the dependency graph (DAG) is managed automatically. Data quality is enforced with `not_null`, `unique`, `accepted_values`, and `relationships` tests.

---

### Phase 3 — SQL Analysis · *Beril Erdem*
Performed core exploration with BigQuery SQL queries on top of the dbt models.

**Key findings:**
- Home win rate **45.9%**, draw 25.4%, away win 28.7% — clear home advantage
- Highest-scoring league **Netherlands** (3.08 goals/match), lowest **Poland** (2.42)
- Derived metrics: `home_advantage_index` (deviation from the 33.3% equilibrium point) and team `tier` classification (dominant / strong / weak)

---

### Phase 4 — Statistical Testing · *Esra Özkan*
4 hypotheses, 4 different statistical tests (Python · Colab):

| # | Hypothesis | Test | Result |
|---|---|---|---|
| H1 | Is home advantage real? | Chi-square | p≈0, significant |
| H2 | Does the betting favorite hold? | Binomial | 53.3% accuracy |
| H3 | Does the home team play differently? | Paired t-test | +possession, −fouls/cards |
| H4 | Does team quality determine outcome? | Pearson + Logistic reg. | r=0.45 |

All four hypotheses were statistically confirmed. Even between evenly matched teams, the home win probability is **44.9%** — meaning home advantage doesn't stem solely from quality differences.

---

### Phase 5 — Machine Learning · *Esra Özkan*
Trained models to predict match outcome (home / draw / away). Data split 80% training / 20% test.

| Method | Accuracy |
|---|---|
| Random (baseline) | 33.3% |
| Always home | 45.9% |
| Betting favorite | 52.9% |
| **Logistic regression** | **53.5%** ✅ |
| Random Forest | 45.4% |

**Key finding:** Logistic regression beat both the betting favorite and random forest. "A more complex model isn't always better" — the most decisive feature was `rating_diff`.

---

### Phase 6 — Visualization · *Gamze Barış*
All findings were visualized in a multi-page interactive Looker Studio dashboard:

- **Overview** — total matches, goals, leagues, players KPIs
- **League & Match** — home advantage, result distribution, goals by league
- **Team Analysis** — top clubs, offense-defense scatter
- **Player Analysis** — rating distribution, top players
- **Statistics & ML** — hypothesis results, model comparisons

---

## 📁 Repo Structure

```
soccer-analysis/
├── dbt_project.yml
├── models/
│   ├── staging/          # raw data cleaning
│   ├── core/             # dim + fact (Star Schema)
│   └── marts/            # analysis tables + kpi views
├──
│   
├── soccer_analysis.ipynb # Python: statistics + ML
└── README.md
```

---

## 🏆 Conclusion

Three main takeaways:

1. **Home advantage is real and statistically proven** — it persists even between evenly matched teams.
2. **Team quality is the most important factor** in determining outcomes, but it doesn't eliminate home advantage.
3. **The simple model (logistic regression) beat the complex one (random forest)** — complexity isn't always an advantage in model selection.
