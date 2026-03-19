DROP MATERIALIZED VIEW IF EXISTS chicago_crime_monthly_classified;

CREATE MATERIALIZED VIEW chicago_crime_monthly_classified AS
SELECT
    DATE_TRUNC('month', date) AS month,

    CASE
        -- INDEX VIOLENT
        WHEN primary_type IN (
            'HOMICIDE',
            'CRIMINAL SEXUAL ASSAULT',
            'ROBBERY',
            'AGGRAVATED ASSAULT',
            'AGGRAVATED BATTERY'
        ) THEN 'Violent Index'

        -- INDEX PROPERTY
        WHEN primary_type IN (
            'BURGLARY',
            'THEFT',
            'MOTOR VEHICLE THEFT',
            'ARSON'
        ) THEN 'Property Index'

        -- NON-INDEX VIOLENT
        WHEN primary_type IN (
            'BATTERY',
            'ASSAULT',
            'INTIMIDATION',
            'KIDNAPPING'
        ) THEN 'Violent Non-Index'

        -- NON-INDEX PROPERTY
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
GROUP BY DATE_TRUNC('month', date), crime_category
ORDER BY month;

CREATE INDEX idx_month_classified
ON chicago_crime_monthly_classified (month);

SELECT
    month,
    crime_category,
    total_incidents
FROM chicago_crime_monthly_classified
ORDER BY month DESC, crime_category;

SELECT
    month,
    SUM(CASE WHEN crime_category = 'Violent Index' THEN total_incidents ELSE 0 END) AS violent_index,
    SUM(CASE WHEN crime_category = 'Property Index' THEN total_incidents ELSE 0 END) AS property_index,
    SUM(CASE WHEN crime_category = 'Violent Non-Index' THEN total_incidents ELSE 0 END) AS violent_non_index,
    SUM(CASE WHEN crime_category = 'Property Non-Index' THEN total_incidents ELSE 0 END) AS property_non_index,
    SUM(CASE WHEN crime_category = 'Other' THEN total_incidents ELSE 0 END) AS other
FROM chicago_crime_monthly_classified
GROUP BY month
ORDER BY month DESC;