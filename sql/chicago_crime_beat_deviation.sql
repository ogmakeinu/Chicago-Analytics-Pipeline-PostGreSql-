DROP MATERIALIZED VIEW IF EXISTS chicago_crime_beat_deviation;

CREATE MATERIALIZED VIEW chicago_crime_beat_deviation AS
SELECT
    m.month,
    m.beat,
    m.total_incidents,
    b.avg_monthly_incidents,
    ROUND(
        (m.total_incidents - b.avg_monthly_incidents)
        / b.avg_monthly_incidents * 100,
        2
    ) AS pct_above_baseline
FROM chicago_crime_beat_monthly m
JOIN chicago_crime_5yr_avg_beat b
    ON m.beat = b.beat
    AND EXTRACT(MONTH FROM m.month) = b.month_number
WHERE m.month < date_trunc('month', CURRENT_DATE);

CREATE INDEX idx_beat_dev
ON chicago_crime_beat_deviation (beat, month);

SELECT COUNT(*)
FROM chicago_crime_beat_deviation;