DROP MATERIALIZED VIEW IF EXISTS chicago_crime_daily;

CREATE MATERIALIZED VIEW chicago_crime_daily AS
SELECT
    date::date AS incident_date,
    COUNT(*) AS daily_total
FROM chicago_crime
GROUP BY date::date
ORDER BY incident_date;

CREATE INDEX idx_daily_date
ON chicago_crime_daily (incident_date);

select count(*) from  chicago_crime_daily;

DROP MATERIALIZED VIEW IF EXISTS chicago_crime_rolling_30;

CREATE MATERIALIZED VIEW chicago_crime_rolling_30 AS
SELECT
    incident_date,
    SUM(daily_total) OVER (
        ORDER BY incident_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS rolling_30_total
FROM chicago_crime_daily;

CREATE INDEX idx_rolling_date
ON chicago_crime_rolling_30 (incident_date);

select *
from chicago_crime_rolling_30
order by incident_date desc 
limit 20;