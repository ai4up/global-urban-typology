# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "geopandas",
#     "pyarrow",
# ]
# ///

import os
import geopandas as gpd

FILEPATH = os.path.join("data", "GHS_STAT_UCDB2015MT_GLOBE_R2019A_V1_2.gpkg")


def to_parquet(file_path: str) -> None:
    gpd.read_file(file_path).to_parquet(file_path.replace(".gpkg", ".parquet"), geometry_encoding="WKB")


if __name__ == "__main__":
    to_parquet(FILEPATH)
