# Chicago Crime Analytics Pipeline (PostgreSQL)

## Overview

This project builds an end-to-end data pipeline using the Chicago Open Data Portal crime dataset. Data is ingested via API, loaded into PostgreSQL, and transformed into analytical views to support trend analysis, seasonal patterns, and detection of abnormal activity across districts and beats.

The goal is to simulate a real-world public safety analytics workflow used for operational insight and decision-making.

---

## Key Features

* API-based data ingestion (no manual CSVs)
* Batch loading with pagination and deduplication
* PostgreSQL materialized views for performance
* Time-series analysis (daily, monthly, rolling 30-day)
* Crime classification (violent vs property categories)
* 5-year baseline modeling for seasonal trends
* Deviation analysis to detect abnormal activity
* Indexed queries optimized for analytics

---

## Data Source

* Chicago Open Data Portal
* Dataset: Crime Incidents
* API Endpoint:
  https://data.cityofchicago.org/resource/ijzp-q8t2.json

---

## Tech Stack

* Python (requests, psycopg2)
* PostgreSQL (materialized views, indexing)
* SQL (aggregation, window functions, modeling)
* (Optional) Tableau for visualization

---

## Project Structure

```
chicago-crime-postgres-pipeline/
│
├── sql/
│   ├── 01_load_data.sql
│   ├── 02_district_monthly.sql
│   ├── 03_beat_monthly.sql
│   ├── 04_daily_and_rolling.sql
│   ├── 05_classification_layer.sql
│   ├── 06_district_classified.sql
│   ├── 07_city_5yr_avg.sql
│   ├── 08_chicago_crime_5yr_avg_beat.sql
│   ├── 09_chicago_crime_district_deviation.sql
│
├── scripts/
│   └── ingest_chicago.py
│
├── .gitignore
├── LICENSE
├── README.md
```

---

## Data Pipeline

### 1. Ingestion

* Data is pulled from the Chicago Open Data API
* Pagination handles large datasets (50k records per batch)
* Data is processed month-by-month to support backfills
* Duplicate records are ignored using `ON CONFLICT`

### 2. Storage

* Data is loaded into PostgreSQL (`chicago_crime` table)
* Indexed for time and geographic queries

### 3. Transformation

* Aggregations created using materialized views:

  * Monthly by district and beat
  * Daily totals and rolling 30-day trends

### 4. Classification

* Incidents categorized into:

  * Violent Index
  * Property Index
  * Violent Non-Index
  * Property Non-Index
  * Other

### 5. Baseline Modeling

* 5-year historical averages computed:

  * City-wide
  * District-level
  * Beat-level

### 6. Deviation Analysis

* Current activity compared to baseline
* % above/below expected levels calculated
* Highlights abnormal trends for investigation

---

## Example Analytical Questions

* Which districts are experiencing above-average crime levels?
* What seasonal patterns exist in crime trends?
* Where are short-term spikes occurring (rolling 30-day)?
* Which beats consistently deviate from historical baselines?
* How do arrest rates vary across districts and time?

---

## How to Run

### 1. Create database

```
createdb chicago_data
```

### 2. Create base table

```
psql -d chicago_data -f sql/01_load_data.sql
```

### 3. Run ingestion script

```
python scripts/ingest_chicago.py
```

### 4. Build analytical views

```
psql -d chicago_data -f sql/02_district_monthly.sql
psql -d chicago_data -f sql/03_beat_monthly.sql
psql -d chicago_data -f sql/04_daily_and_rolling.sql
...
```

---

## Sample Insights

* Certain districts show consistent seasonal increases during summer months
* Beat-level analysis reveals localized hotspots not visible at district level
* Rolling 30-day metrics highlight short-term spikes masked in monthly data
* Deviation modeling identifies areas exceeding historical expectations

---

## Future Improvements

* Automate scheduled ingestion (cron / Airflow)
* Add geospatial analysis (PostGIS / hex grids)
* Integrate Tableau dashboards for visualization
* Expand classification (e.g., firearm-specific incidents)
* Add real-time alerting for anomaly detection

---

## Author

Anthony Lindsey
Public Safety Analytics | Data Engineering | Tableau

---
