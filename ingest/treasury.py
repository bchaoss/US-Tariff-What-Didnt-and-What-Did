import duckdb
import requests
import json
from pathlib import Path
import pyarrow as pa

table_name = "us_treasury_statement_monthly"
target_name = "us_tariff.raw." + table_name
print(target_name)


def get_api_data(date_greater='2026-01-01', page_size=1000):
    baseUrl = 'https://api.fiscaldata.treasury.gov/services/api/fiscal_service'
    endpoint = '/v1/accounting/mts/mts_table_9'
    fields = ''
    filter = f'&filter=record_date:gt:{date_greater}'
    sort = '&sort=-record_date'
    format = '&format=json'
    pagination = f'&page[number]=1&page[size]={page_size}'

    API = f'{baseUrl}{endpoint}?{fields}{filter}{sort}{format}{pagination}'
    resp = requests.get(API)
    resp.raise_for_status()

    data_json = resp.json()
    data_types = data_json['meta']['dataTypes']
    data_records = pa.Table.from_pylist(data_json['data'])

    if data_json['meta']['total-pages'] > 1:
        raise ValueError("Not total data are be fetched.")

    return data_types, data_records


type_map = {
    "STRING": "VARCHAR",
    "DATE": "DATE",
    "CURRENCY": "VARCHAR",  # "NUMERIC(18,2)",
    "INTEGER": "INTEGER",
    "YEAR": "INTEGER",
    "QUARTER": "INTEGER",
    "MONTH": "VARCHAR",
    "DAY": "VARCHAR"
}

# MotherDuck:
db_name = "us_tariff"
con = duckdb.connect(
    f"md:{db_name}"
)

# con = duckdb.connect(":memory:")

existing_cols = set(
    row[0] for row in con.execute(f"""
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{table_name}'
    """).fetchall()
)

# print(existing_cols)

# table_exists = con.execute(f"""
#     SELECT COUNT(*)
#     FROM information_schema.tables
#     WHERE table_name = '{table_name}'
# """).fetchone()[0] > 0

if not existing_cols:
    data_types, data_records = get_api_data(
        date_greater='2023-01-01', page_size=100000)

    columns_sql = ",\n    ".join(
        f"{col} {type_map.get(dtype, 'VARCHAR')}" for col, dtype in data_types.items())
    create_sql = f"CREATE TABLE IF NOT EXISTS {target_name} (\n    {columns_sql}\n);"

    con.execute(create_sql)

    con.execute(
        f"""INSERT INTO {target_name} SELECT * FROM data_records 
        where record_date < '2026-01-01'
        """)

else:
    max_date = con.execute(f"""
        SELECT COALESCE(MAX(record_date), '1900-01-01')
        FROM {target_name}
    """).fetchone()[0]

    data_types, data_records = get_api_data(
        date_greater=max_date, page_size=1000)

    if data_records.num_rows == 0:
        print(f"Data already up to date {max_date}.")
    elif existing_cols != set(data_types.keys()):
        raise ValueError("Schema mismatch detected.")
    else:
        con.execute(
            f"INSERT INTO {target_name} SELECT * FROM data_records")


# test
result = con.execute(
    f"SELECT * FROM {target_name} order by record_date desc limit 1").fetchall()
print(result)

con.close()
