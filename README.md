# Chicago-Analytics-Pipeline-PostGreSql-
PostgreSQL analytics pipeline using Chicago Open Data crime data. Includes aggregation, classification, 5-year baseline modeling, and deviation analysis across districts and beats to identify trends and abnormal activity for public safety insights.
# Chicago Crime Analytics Pipeline (PostgreSQL)

## Overview

This project builds a PostgreSQL-based analytics pipeline using the Chicago Open Data Portal crime dataset. The goal is to transform raw incident-level data into structured, query-optimized views that support trend analysis, seasonal pattern detection, and identification of abnormal activity across districts and beats.

The pipeline focuses on real-world public safety use cases such as monitoring crime trends, evaluating enforcement activity, and detecting deviations from historical baselines.

---

## Objectives

* Aggregate crime data across multiple time intervals (daily, monthly, rolling)
* Classify incidents into meaningful analytical categories
* Establish historical baselines using a 5-year average model
* Identify deviations from expected activity at district and beat levels
* Optimize query performance using indexed materialized views

---

## Data Source

* Chicago Open Data Portal
* Dataset: Crime Incidents
* Data includes:

  * Incident date/time
  * Primary crime type
  * Beat and district
  * Arrest indicator
  * Location details

---

## Tech Stack

* PostgreSQL
* SQL (materialized views, window functions, indexing)
* Chicago Open Data Portal API / dataset
* (Optional) Tableau for visualization

---

## Data Model

### Base Table

`chicago_crime`

Key fields used:

* `date` – incident timestamp
* `primary_type` – offense classification
* `beat` – police beat
* `district` – police district
* `arrest` – boolean flag

---

## Pipeline Architecture

### 1. Aggregation Layer

* Monthly aggregation by district and beat
* Daily totals and rolling 30-day calculations

### 2. Classification Layer

* Categorizes incidents into:

  * Violent Index
  * Property Index
  * Violent Non-Index
  * Property Non-Index
  * Other

### 3. Baseline Layer

* Computes 5-year historical averages:

  * City-wide
  * District-level
  * Beat-level

### 4. Deviation Layer

* Compares current activity to historical baselines
* Calculates % above/below expected levels

---

## Key Features

* **Materialized Views**

  * Improves performance for repeated analytical queries

* **Rolling Time Windows**

  * 30-day rolling totals for short-term trend detection

* **Crime Classification Logic**

  * Standardized grouping for meaningful reporting

* **Baseline Modeling**

  * Uses 5-year averages to establish expected activity

* **Deviation Analysis**

  * Identifies abnormal increases or decreases in crime

* **Indexing Strategy**

  * Optimized for time-based and geographic queries

---

## Example Analytical Questions

* Which districts are experiencing above-average crime levels?
* How does current activity compare to historical seasonal patterns?
* What short-term spikes are occurring in the last 30 days?
* Which beats show consistent deviation from baseline expectations?
* How do arrest rates vary across districts and time?

---

## Sample Insights (Example)

* Certain districts show consistent seasonal increases during summer months
* Beat-level analysis reveals localized hotspots not visible at district level
* Rolling 30-day metrics highlight short-term spikes masked in monthly aggregates
* Arrest rates vary significantly across districts, indicating differences in enforcement or incident types

---

## Project Structure

```
chicago-crime-postgresql/
│
├── scripts/
│   ├── 02_district_monthly.sql
│   ├── 03_beat_monthly.sql
│   ├── 04_daily_and_rolling.sql
│   ├── 05_classification_layer.sql
│   ├── 06_district_classified.sql
│   ├── 07_city_5yr_avg.sql
│   ├── 08_chicago_crime_5yr_avg_beat.sql
│   ├── 09_chicago_crime_district_deviation.sql
│   └── ...
│
├── docs/
│   ├── query_results.png
│   ├── dashboard_preview.png
│
└── README.md
```

---

## How to Run

```bash
# Create database
createdb chicago_data

# Run scripts in order
psql -d chicago_data -f scripts/02_district_monthly.sql
psql -d chicago_data -f scripts/03_beat_monthly.sql
psql -d chicago_data -f scripts/04_daily_and_rolling.sql
```

---

## Future Improvements

* Automate ingestion using Python and Chicago API
* Add scheduled refresh for materialized views
* Integrate with Tableau dashboards for visualization
* Expand classification logic (e.g., firearm-related incidents)
* Add geospatial analysis (GIS / hex grids)

---

## Author

Anthony Lindsey
Public Safety Analytics | Data Engineering | Tableau

---
