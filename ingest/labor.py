# Data source, manually download from: https://download.bls.gov/pub/time.series/ce/
# Data tables: ce.data.00a.TotalNonfarm.Employment, etc.
# Info tables: ce.seasonal, ce.industry, ce.footnote.txt, ce.supersector.txt, ce.period, ce.series, ce.datatype
#
# For dimension / information tables, it works fine in one-time manual download.
# For data tables, a monthly update through API will be implemented
#     based on specific series IDs obtained from the dim_series table after initial download.

import duckdb
import glob
import os

# Configuration
DATA_PATH = "data/ce.*"
DATABASE_NAME = "us_tariff"
SCHEMA = "labor"

# Helper functions


def normalize_filename(path):
    base = os.path.basename(path)

    # remove prefix ce.
    if base.startswith("ce."):
        base = base[3:]

    # remove .txt extension if exists
    if base.endswith(".txt"):
        base = base[:-4]

    return base.replace(".", "_")


# Connect to MotherDuck
con = duckdb.connect(
    f"md:{DATABASE_NAME}"
)

# Table creation SQL template
CREATE_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS {database}.{schema}.raw_{table_name} AS
FROM read_csv_auto('{file_path}', sep='\t')
"""

# Process files
files = glob.glob(DATA_PATH)

for file_path in files:
    table_name = normalize_filename(file_path)

    sql = CREATE_TABLE_SQL.format(
        database=DATABASE_NAME,
        schema=SCHEMA,
        table_name=table_name,
        file_path=file_path
    )

    con.execute(sql)

    print(table_name)

con.close()

print("Upload completed.")
