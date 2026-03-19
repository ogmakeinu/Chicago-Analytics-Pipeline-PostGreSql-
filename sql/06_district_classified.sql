DROP MATERIALIZED VIEW IF EXISTS chicago_crime_district_monthly_classified;

CREATE MATERIALIZED VIEW chicago_crime_district_monthly_classified AS
SELECT
    DATE_TRUNC('month', date) AS month,
    district,

    CASE
        WHEN primary_type IN (
            'HOMICIDE',
            'CRIMINAL SEXUAL ASSAULT',
            'ROBBERY',
            'AGGRAVATED ASSAULT'
        ) THEN 'Violent Index'

        WHEN primary_type IN (
            'BURGLARY',
            'THEFT',
            'MOTOR VEHICLE THEFT',
            'ARSON'
        ) THEN 'Property Index'

        WHEN primary_type IN (
            'BATTERY',
            'ASSAULT',
            'INTIMIDATION',
            'KIDNAPPING'
        ) THEN 'Violent Non-Index'

        WHEN primary_type IN (
            'CRIMINAL DAMAGE',
            'DECEPTIVE PRACTICE',
            'STOLEN PROPERTY',
            'CRIMINAL TRESPASS'
        ) THEN 'Property Non-Index'

        ELSE 'Other'
    END AS crime_category,

    COUNT(*) AS total_incidents

FROM chicago_crime
WHERE district IS NOT NULL
GROUP BY month, district, crime_category;

CREATE INDEX idx_district_class_month
ON chicago_crime_district_monthly_classified (month);

CREATE INDEX idx_district_class_district
ON chicago_crime_district_monthly_classified (district);

SELECT
    month,
    district,
    crime_category,
    total_incidents
FROM chicago_crime_district_monthly_classified
ORDER BY month DESC, district
LIMIT 30;