# Avrupa Futbolunda Ev Sahibi Avantajı Gerçekten Etkili Mi?

Avrupa futbol liglerindeki ev sahibi avantajının arkasında yatan temel mekanizmaları incelemek amacıyla Google BigQuery, dbt, Python ve Power BI teknolojilerini bir arada kullanan, **Workintech** için hazırlanmış uçtan uca bir veri analizi projesi.

## Motivasyon
Futbolda **"ev sahibi avantajı"**, en yaygın kabul gören olgulardan biridir. Kendi sevinde oynayan takımların; tanıdık çevre, seyahat yorgunluğunun olmaması, hakem taraftarlığı ve yerel taraftarların psikolojik desteği gibi nedenlerle genellikle daha iyi performans göstermesi beklenir.

Ancak konuyla ilgili pek çok soru açıkta kalmaktadır: *Bu avantaj tüm Avrupa liglerinde bilimsel olarak kanıtlanabilir mi, yoksa sadece bir safsata mı? Ev sahibi olarak oynamak; taktiksel veya oyuncu özelliklerini, pas hızını, disiplin cezalarını ve topa sahip olma oranlarını ne ölçüde etkilemektedir?*

Bu proje, descriptive istatistiklerin ötesine geçerek bu soruları yanıtlamayı amaçlamaktadır. Projeyi **[buraya projenin sonunda elde edilen nihai çıktıların/bulguların özetini en son ekleyebiliriz]** ile tamamlıyoruz.

---

## Temel Sorular
Analiz ve modelleme çerçevemiz, aşağıdaki temel araştırma sorularını sistematik olarak ele alacak şekilde tasarlanmıştır:

* **İstatistik:** Ev sahibi ve deplasman takımlarının attığı goller arasında istatistiksel olarak anlamlı bir fark var mı?
* **Taktiksel Etki:** Ev sahibi olmak; topa sahip olma, şut isabeti ve disiplin cezaları (sarı/kırmızı kartlar) gibi standart maç metriklerini nasıl etkiliyor?
* **Kadro Kalitesi Faktörü:** FIFA özelliklerinden türetilen genel kadro reytingi, ev sahibi avantajının etkilerini hafifletiyor mu yoksa artırıyor mu?
* **Tahmin Gücü:** Ev sahibi avantajını ve takımların güncel form durumlarını yakalayan öznitelikler (features) oluşturarak maç sonuçlarını (Galibiyet/Beraberlik/Mağlubiyet) doğru bir şekilde tahmin edebilir miyiz?

---

## Projeye Genel Bakış
Bu projede, 2008 ile 2016 sezonlarını kapsayan ve son derece zengin bir veri seti olan **Kaggle European Soccer Database** kullanılmıştır. 

### Temel Veri Seti Boyutları
* **Kapsam:** Avrupa ülkeleri ve bu ülkelerin en üst düzey ligleri.
* **Hacim:** Maçlar ve benzersiz oyuncular. *(Not: Bu sayıları daha sonra buraya ekleyebilirsiniz)*
* **Detay Düzeyi (Granularity):** 10.000'den fazla maç için son derece detaylı, XML formatındaki maç içi olay günlükleri (şutlar, fauller, kartlar, topa sahip olma).
* **Özellikler:** Doğrudan EA Sports'un FIFA video oyunu serisinden alınan ve haftalık olarak güncellenen takım ve oyuncu performans özellikleri.

### Teknik Altyapı
* **Veri Aktarımı (Faz 2):** SQLite tablolarını doğrudan Google BigQuery'ye yüklemek için veri temizleme işlemlerini gerçekleştiren Python betikleri ve manuel yükleme prosedürleri.
* **Dönüşüm & Kalite Kontrol (Faz 3):** Yıldız şemalı (star-schema) bir veri ambarı modellemek ve şema doğrulama testlerini çalıştırmak için dbt kullanımı.
* **KPI Hesaplamaları (Faz 4):** Takım, oyuncu ve lig düzeyindeki analitik metriklerin formüle edilmesi ve hesaplanması.
* **İleri Analitik:** Ev sahibi avantajının istatistiksel geçerliliğini kanıtlamak amacıyla bağımsız Welch $t$-testlerini çalıştırmak için Python.
* **Makine Öğrenmesi:** Maç sonuçlarını tahmin etmek ve olasılık skorlarını BigQuery'ye geri aktarmak için Random Forest çok sınıflı sınıflandırma modeli kullanan Python.
* **Görselleştirme:** Yönetici düzeyinde, dinamik ve etkileşimli raporlama için Power BI veya Looker Studio.

---

## Proje Yapısı
Bu depo (repository) için planlanan dizin yapısı ve klasör organizasyonu aşağıdadır:

```text
.
├── dbt_project/             # dbt modelleri, testleri ve konfigürasyonları
├── src/
│   ├── ingestion/           # Veri temizleme ve BigQuery yükleme için Python betikleri
│   ├── modeling/            # ML eğitim, değerlendirme ve tahmin betikleri
│   └── api/                 # FastAPI uygulama kodları
├── notebooks/               # EDA ve prototipleme için Jupyter notebook'ları
├── dashboards/              # Power BI şablonları veya bağlantıları
└── README.md
```

---

## Proje Yol Haritası
* [x] **Faz 0: Keşif & Prototip** — Python ile ham verinin analizi, temizliği ve ilk baseline (taban) modelin kurulması.
* [ ] **Faz 1: GitHub Kurulumu** — Versiyon kontrol altyapısının kurulması ve iş birliği standartlarının belirlenmesi.
* [x] **Faz 2: BigQuery Entegrasyonu** — Verilerin Google Cloud BigQuery ortamına taşınması ve yüklenmesi.
* [ ] **Faz 3: dbt ile Katmanlı Dönüşüm** — Staging, Business ve Analytics veri ambarı katmanlarının tasarlanması ve oluşturulması.
* [ ] **Faz 4: KPI Hesaplamaları** — Takım, oyuncu ve lig bazlı analitik metriklerin doğrudan dbt üzerinde modellenmesi.
* [ ] **Faz 5: 3 ML Modeli** — Tahmin modellerinin eğitilmesi, optimize edilmesi ve kaydedilmesi.
* [ ] **Faz 6: FastAPI Geliştirme** — Canlı tahmin API'sinin yazılması ve test edilmesi?
* [ ] **Faz 7: Power BI Dashboard** — Karar destek mekanizması için 7 sayfalık rapor/dashboard tasarımının tamamlanması.
* [ ] **Faz 8: Sunum ve Canlıya Geçiş** — 20 Haziran'daki bitirme (capstone) sunumu için son hazırlıkların tamamlanması.

---

## Ekip
Bu proje, aşağıdaki ekip üyelerinin ortak bir çalışmasıdır:

* **Esra Özkan** ([esraozkan98-commits](https://github.com/esraozkan98-commits))
  * **Rol:** [Rol, örn. Veri Mühendisi]
  * **Responsibilities:** [Sorumluluklar, örn. dbt modelleme ve BigQuery kurulumu]
* **Beril Erdem** ([berilcommits](https://github.com/berilcommits))
  * **Rol:** [Rol]
  * **Sorumluluklar:** [Sorumluluklar]
* **Rıza Sarı** ([GitHub Profili](https://github.com/))
  * **Rol:** [Rol]
  * **Sorumluluklar:** [Sorumluluklar]
* **Burak Şahin** ([GitHub Profili](https://github.com/))
  * **Rol:** [Rol]
  * **Sorumluluklar:** [Sorumluluklar]

---
_Bu proje, 20 Haziran 2026 tarihinde Workintech Veri Analisti Programı için Bitirme Projesi olarak sunulmuştur._

******************************************************************************************************************************************************

# Is Home Advantage Really Significant in European Football?

An end-to-end data analysis project prepared for **Workintech**, combining Google BigQuery, dbt, Python, and Power BI to investigate the underlying mechanisms of home advantage across European football leagues.

## Motivation
In football, **"home advantage"** is one of the most widely accepted phenomena. Teams playing in their own stadiums are generally expected to perform better due to factors such as:
* Familiar environment
* Lack of travel fatigue
* Referee bias
* Psychological support or pressure from local fans

However, many questions remain: *Can this advantage be scientifically proven across all European leagues, or is it just a myth? To what extent does playing at home affect tactical or player attributes, passing speed, disciplinary actions, and possession rates?*

This project aims to go beyond descriptive statistics to answer these questions. We conclude the project with **[buraya çıkarımlarımızı yazacağız proje sonunda]**.

---

## Core Questions
Our analysis and modeling framework is designed to systematically address the following core research questions:

* **Statistical Decision:** Is there a statistically significant difference between the goals scored by home and away teams?
* **Tactical Impact:** How does being the home team affect standard match metrics such as possession, shot accuracy, and disciplinary sanctions (yellow/red cards)?
* **Squad Quality Factor:** Does the overall squad rating, derived from FIFA attributes, mitigate or amplify the effects of home advantage?
* **Predictive Power:** Can we accurately predict match outcomes (Win/Draw/Loss) by engineering features that capture home advantage and teams' recent form?

---

## Project Overview
This project utilizes the **Kaggle European Soccer Database**, a highly rich dataset covering the 2008 to 2016 seasons.

### Key Dataset Dimensions
* **Scope:** European countries and their top-tier leagues.
* **Volume:** Matches and unique players. *(Note: You can add these numbers here later)*
* **Granularity:** Highly detailed, XML-formatted in-game event logs (shots, fouls, cards, possession) for over 10,000 matches.
* **Features:** Team and player performance attributes directly sourced from EA Sports' FIFA video game series, updated weekly.

### Technical Infrastructure
* **Data Ingestion (Phase 2):** Python scripts for data cleaning and manual loading procedures to upload SQLite tables directly to Google BigQuery.
* **Transformation & Quality Control (Phase 3):** Utilizing dbt to model a star-schema data warehouse and run schema validation tests.
* **KPI Calculations (Phase 4):** Formulating and calculating analytical metrics at the team, player, and league levels.
* **Advanced Analytics:** Python to run independent Welch $t$-tests to prove the statistical validity of the home advantage.
* **Machine Learning:** Python utilizing a Random Forest multi-class classification model to predict match outcomes and write probability scores back to BigQuery.
* **Visualization:** Power BI or Looker Studio for executive-level, dynamic, and interactive reporting.

---

## Project Structure
The planned directory structure and folder organization for this repository is as follows:

```text
.
├── dbt_project/             # dbt models, tests, and configurations
├── src/
│   ├── ingestion/           # Python scripts for data cleaning and BigQuery ingestion
│   ├── modeling/            # ML training, evaluation, and prediction scripts
│   └── api/                 # FastAPI application source code
├── notebooks/               # notebooks for EDA 
├── dashboards/              # Power BI templates or connections
└── README.md
```

---

## Project Roadmap
* [x] **Phase 0: Discovery & Prototype** — Python analysis, cleaning of raw data, and building the first baseline model.
* [ ] **Phase 1: GitHub Setup** — Establishing version control infrastructure and defining collaboration standards.
* [x] **Phase 2: BigQuery Integration** — Migrating and loading data into the Google Cloud BigQuery environment.
* [ ] **Phase 3: Layered Transformation with dbt** — Designing and building Staging, Business, and Analytics data warehouse layers.
* [ ] **Phase 4: KPI Calculations** — Modeling team, player, and league-based analytical metrics directly on dbt.
* [ ] **Phase 5: 3 ML Models** — Training, optimizing, and saving predictive models.
* [ ] **Phase 6: FastAPI Development** — Writing and testing the live prediction API.?
* [ ] **Phase 7: Power BI Dashboard** — Completing the design of a 7-page report/dashboard for decision support.
* [ ] **Phase 8: Presentation and Deployment** — Completing final preparations for the capstone presentation on June 20th.

---

## Team
This project is a collaborative effort of the following team members:

* **Esra Özkan** ([esraozkan98-commits](https://github.com/esraozkan98-commits))
  * **Role:** [Enter role, e.g., Data Engineer]
  * **Responsibilities:** [Enter responsibilities, e.g., dbt modeling and BigQuery setup]
* **Beril Erdem** ([berilcommits](https://github.com/berilcommits))
  * **Role:** [role]
  * **Responsibilities:** [responsibilities]
* **Rıza Sarı** ([GitHub Profile](https://github.com/))
  * **Role:** [role]
  * **Responsibilities:** [responsibilities]
* **Burak Şahin** ([GitHub Profile](https://github.com/))
  * **Role:** [role]
  * **Responsibilities:** [responsibilities]

---
_This project was presented on June 20, 2026, as the Capstone Project for the Workintech Data Analyst Program._
