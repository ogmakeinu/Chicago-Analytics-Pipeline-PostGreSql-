DROP MATERIALIZED VIEW IF EXISTS chicago_crime_5yr_avg_city;

CREATE MATERIALIZED VIEW chicago_crime_5yr_avg_city AS
SELECT
    month_number,
    AVG(yearly_total) AS avg_monthly_incidents
FROM (
    SELECT
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(MONTH FROM date) AS month_number,
        COUNT(*) AS yearly_total
    FROM chicago_crime
    WHERE date >= date_trunc('year', CURRENT_DATE) - INTERVAL '5 years'
      AND date < date_trunc('year', CURRENT_DATE)  -- exclude current partial year
    GROUP BY year, month_number
) yearly_counts
GROUP BY month_number;

CREATE INDEX idx_5yr_city_month
ON chicago_crime_5yr_avg_city (month_number);