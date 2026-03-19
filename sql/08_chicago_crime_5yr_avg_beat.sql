DROP MATERIALIZED VIEW IF EXISTS chicago_crime_5yr_avg_beat;

CREATE MATERIALIZED VIEW chicago_crime_5yr_avg_beat AS
SELECT
    beat,
    month_number,
    AVG(yearly_total) AS avg_monthly_incidents
FROM (
    SELECT
        beat,
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(MONTH FROM date) AS month_number,
        COUNT(*) AS yearly_total
    FROM chicago_crime
    WHERE date >= date_trunc('year', CURRENT_DATE) - INTERVAL '5 years'
      AND date < date_trunc('year', CURRENT_DATE)
    GROUP BY
        beat,
        EXTRACT(YEAR FROM date),
        EXTRACT(MONTH FROM date)
) yearly_counts
GROUP BY beat, month_number;

CREATE INDEX idx_5yr_beat
ON chicago_crime_5yr_avg_beat (beat, month_number);

SELECT COUNT(*) FROM chicago_crime_5yr_avg_beat;