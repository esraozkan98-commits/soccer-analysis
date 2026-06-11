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

### Technological Infrastructure
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
* [ ] **Phase 2: BigQuery Integration** — Migrating and loading data into the Google Cloud BigQuery environment.
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
  * **Role:** [Enter role]
  * **Responsibilities:** [Enter responsibilities]
* **Rıza Sarı** ([GitHub Profile](https://github.com/))
  * **Role:** [Enter role]
  * **Responsibilities:** [Enter responsibilities]
* **Burak Şahin** ([GitHub Profile](https://github.com/))
  * **Role:** [Enter role]
  * **Responsibilities:** [Enter responsibilities]

---
_This project was presented on June 20, 2026, as the Capstone Project for the Workintech Data Analyst Program._
