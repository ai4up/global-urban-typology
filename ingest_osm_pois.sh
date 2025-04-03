#!/bin/zsh

# Input and output file paths
PBF_FILE="data/planet-250317.osm.pbf"
FILTERED_PBF="data/planet-pois-250317.osm.pbf"
PARQUET_DIR="data/osm-pois"
DB_FILE="pois.duckdb"

# Tags to filter
TAGS="n/amenity n/shop n/office"

echo "Step 1: Download OSM data..."
aws s3 cp --no-sign-request s3://osm-planet-eu-central-1/planet/pbf/2025/planet-250317.osm.pbf "$PBF_FILE"

echo "Step 2: Extracting POIs from $PBF_FILE..."
# osmium tags-filter "$PBF_FILE" $TAGS -o "$FILTERED_PBF"

# echo "Step 2: Converting POIs to GeoParquet..."
# ./osm-pbf-parquet --input "$FILTERED_PBF" --output "$PARQUET_DIR"

echo "Step 3: Loading POIs into DuckDB..."
duckdb "$DB_FILE" <<SQL
    INSTALL spatial;
    LOAD spatial;
    CREATE OR REPLACE TABLE
        osm_places 
    AS SELECT 
        id,
        lat,
        lon,
        tags.amenity AS amenity,
        tags.shop AS shop,
        tags.office AS office
    FROM
        ST_ReadOSM('../data/planet-pois-250317.osm.pbf');
SQL

echo "Done! POIs are stored in $DB_FILE"
