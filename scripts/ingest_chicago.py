import os
import requests
import psycopg2
from dotenv import load_dotenv
from datetime import datetime, timedelta

load_dotenv()

# === Database connection ===
conn = psycopg2.connect(
    host=os.getenv("DB_HOST", "localhost"),
    port=os.getenv("DB_PORT", "5432"),
    database=os.getenv("DB_NAME", "chicago_data"),
    user=os.getenv("DB_USER", "postgres"),
    password=os.getenv("DB_PASSWORD")
)
cur = conn.cursor()

print("Connected to database successfully.")

# === Ensure table exists (minimal version for testing) ===
cur.execute("""
    CREATE TABLE IF NOT EXISTS chicago_crime (
        id TEXT PRIMARY KEY,
        case_number TEXT,
        date TIMESTAMPTZ,
        block TEXT,
        iucr TEXT,
        primary_type TEXT,
        description TEXT,
        location_description TEXT,
        arrest BOOLEAN,
        domestic BOOLEAN,
        beat INTEGER,
        district INTEGER,
        ward INTEGER,
        community_area INTEGER,
        fbi_code TEXT,
        year INTEGER,
        latitude NUMERIC,
        longitude NUMERIC,
        location GEOMETRY(Point, 4326)
    );
""")
conn.commit()
print("Table 'chicago_crime' is ready.")

# === API settings ===
BASE_URL = "https://data.cityofchicago.org/resource/ijzp-q8t2.json"
LIMIT_PER_PAGE = 1000

# For testing: only recent data (change the date if you want more/less)
recent_date = (datetime.now() - timedelta(days=60)).strftime('%Y-%m-%dT%H:%M:%S')
where = f"date > '{recent_date}'"

print(f"Fetching crimes since: {recent_date}")

# === Fetch and insert in pages ===
offset = 0
total_inserted = 0

while True:
    params = {
        "$limit": LIMIT_PER_PAGE,
        "$offset": offset,
        "$where": where,
        "$order": "date DESC"
    }

    print(f"Requesting page with offset {offset}...")
    response = requests.get(BASE_URL, params=params)

    if response.status_code != 200:
        print(f"API request failed: {response.status_code} - {response.text}")
        break

    data = response.json()
    page_count = len(data)
    print(f"Received {page_count} records.")

    if page_count == 0:
        print("No more data to fetch.")
        break

    inserted_this_page = 0
    for record in data:
        try:
            cur.execute("""
                INSERT INTO chicago_crime (
                    id, case_number, date, block, iucr, primary_type, description,
                    location_description, arrest, domestic, beat, district, ward,
                    community_area, fbi_code, year, latitude, longitude, location
                ) VALUES (
                    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                    ST_SetSRID(ST_MakePoint(%s, %s), 4326)
                )
                ON CONFLICT (id) DO NOTHING;
            """, (
                record.get('id'),
                record.get('case_number'),
                record.get('date'),
                record.get('block'),
                record.get('iucr'),
                record.get('primary_type'),
                record.get('description'),
                record.get('location_description'),
                record.get('arrest') == 'true',
                record.get('domestic') == 'true',
                int(record.get('beat')) if record.get('beat') else None,
                int(record.get('district')) if record.get('district') else None,
                int(record.get('ward')) if record.get('ward') else None,
                int(record.get('community_area')) if record.get('community_area') else None,
                record.get('fbi_code'),
                int(record.get('year')) if record.get('year') else None,
                float(record.get('latitude')) if 'latitude' in record else None,
                float(record.get('longitude')) if 'longitude' in record else None,
                float(record.get('longitude')) if 'longitude' in record else None,
                float(record.get('latitude')) if 'latitude' in record else None
            ))

            if cur.rowcount == 1:
                inserted_this_page += 1
                total_inserted += 1

        except Exception as e:
            print(f"Error on record {record.get('id', 'unknown')}: {e}")
            continue  # keep going even if one fails

    conn.commit()
    print(f"Inserted {inserted_this_page} new records this page. Total so far: {total_inserted}")

    offset += LIMIT_PER_PAGE

print(f"Ingestion finished. Total new records inserted: {total_inserted}")

cur.close()
conn.close()