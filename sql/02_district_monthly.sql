CREATE MATERIALIZED VIEW chicago_crime_district_monthly AS
SELECT
    DATE_TRUNC('month', date) AS month,
    district,
    COUNT(*) AS total_incidents,
    SUM(arrest::int) AS arrests,
    ROUND(SUM(arrest::int)::numeric / COUNT(*) * 100, 2) AS arrest_rate_pct
FROM chicago_crime
WHERE district IS NOT NULL
GROUP BY DATE_TRUNC('month', date), district
ORDER BY month, district;

CREATE INDEX idx_district_month
ON chicago_crime_district_monthly (month);

CREATE INDEX idx_district_code
ON chicago_crime_district_monthly (district);

create index idx_district_month
on chicago_crime_district_monthly (month);


drop index if exists idx_district_codealter;
create index idx_district_code
on chicago_crime_district_monthly (district);

SELECT indexname
FROM pg_indexes
WHERE tablename = 'chicago_crime_district_monthly';

