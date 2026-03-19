CREATE MATERIALIZED VIEW chicago_crime_monthly AS
SELECT
    month,
    primary_type,
    COUNT(*) AS total_incidents,
    SUM(arrest::int) AS arrests,
    ROUND(SUM(arrest::int)::numeric / COUNT(*) * 100, 2) AS arrest_rate_pct
FROM (
    SELECT
        DATE_TRUNC('month', date) AS month,
        primary_type,
        arrest
    FROM chicago_crime
) base
GROUP BY month, primary_type
ORDER BY month;

select COUNT(*) from chicago_crime_monthly;
