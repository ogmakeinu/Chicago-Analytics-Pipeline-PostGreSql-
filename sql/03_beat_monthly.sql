
DROP MATERIALIZED VIEW IF EXISTS chicago_crime_beat_monthly;

CREATE MATERIALIZED VIEW chicago_crime_beat_monthly AS
SELECT
    DATE_TRUNC('month', date) AS month,
    beat,
    COUNT(*) AS total_incidents,
    SUM(arrest::int) AS arrests,
    ROUND(SUM(arrest::int)::numeric / COUNT(*) * 100, 2) AS arrest_rate_pct
FROM chicago_crime
WHERE beat IS NOT NULL
GROUP BY DATE_TRUNC('month', date), beat
ORDER BY month, beat;

CREATE INDEX idx_beat_month
ON chicago_crime_beat_monthly (month);

CREATE INDEX idx_beat_code
ON chicago_crime_beat_monthly (beat);

SELECT
    COUNT(DISTINCT month) AS months,
    COUNT(DISTINCT beat) AS beats
FROM chicago_crime_beat_monthly;

select count(*)
from chicago_crime_beat_monthly;