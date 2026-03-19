DROP MATERIALIZED VIEW IF EXISTS chicago_crime_5yr_avg_district;

CREATE MATERIALIZED VIEW chicago_crime_5yr_avg_district AS
SELECT
    district,
    month_number,
    AVG(yearly_total) AS avg_monthly_incidents
FROM (
    SELECT
        district,
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(MONTH FROM date) AS month_number,
        COUNT(*) AS yearly_total
    FROM chicago_crime
    WHERE date >= date_trunc('year', CURRENT_DATE) - INTERVAL '5 years'
      AND date < date_trunc('year', CURRENT_DATE)
    GROUP BY
        district,
        EXTRACT(YEAR FROM date),
        EXTRACT(MONTH FROM date)
) yearly_counts
GROUP BY district, month_number;

CREATE INDEX idx_5yr_district
ON chicago_crime_5yr_avg_district (district, month_number);

SELECT COUNT(*) FROM chicago_crime_5yr_avg_district;