DROP MATERIALIZED VIEW IF EXISTS chicago_crime_district_deviation;

CREATE MATERIALIZED VIEW chicago_crime_district_deviation AS
SELECT
    m.month,
    m.district,
    m.total_incidents,
    b.avg_monthly_incidents,
    ROUND(
        (m.total_incidents - b.avg_monthly_incidents)
        / b.avg_monthly_incidents * 100,
        2
    ) AS pct_above_baseline
FROM chicago_crime_district_monthly m
JOIN chicago_crime_5yr_avg_district b
    ON m.district = b.district
    AND EXTRACT(MONTH FROM m.month) = b.month_number
WHERE m.month < date_trunc('month', CURRENT_DATE);

CREATE INDEX idx_district_dev
ON chicago_crime_district_deviation (district, month);

SELECT *
FROM chicago_crime_district_deviation
ORDER BY month DESC, pct_above_baseline DESC
LIMIT 20;