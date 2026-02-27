from datetime import datetime
import duckdb
import requests
import json
import pyarrow as pa

# Configuration
target_monthly_start = "2022-01"
DATABASE_NAME = "us_tariff"
SCHEMA = "raw"

# target_trade_type_list = ["imports", "exports"]
# BY_COUNTRY = False
# BY_ENDUSE = True

target_trade_type_list = ["exports"]
BY_COUNTRY = True
BY_ENDUSE = False


def calc_timeout(monthly_start, by_country=False):
    start = datetime.strptime(monthly_start, "%Y-%m")
    now = datetime.now()
    month_diff = (now.year - start.year) * 12 + (now.month - start.month)

    return 10 * month_diff * (50 if by_country else 1)


def get_api_data(trade_type,
                 by_country=False,
                 by_enduse=True,
                 monthly_start="2026-01"):

    BASE_URL = "https://api.census.gov/data/timeseries/"

    if trade_type not in ["imports", "exports"]:
        raise ValueError("Wrong trade_type, pls check typo.")

    dataset = f"intltrade/{trade_type}/enduse"

    variables_list = {
        "imports": (
            ("COMM_LVL,I_ENDUSE,I_ENDUSE_SDESC,I_ENDUSE_LDESC," if by_enduse else "") +
            ("CTY_CODE,CTY_NAME," if by_country else "") +
            "GEN_VAL_MO,CON_VAL_MO,CAL_DUT_MO,CON_CHA_MO"
        ),
        "exports": (
            "DF," +
            ("COMM_LVL,E_ENDUSE,E_ENDUSE_SDESC,E_ENDUSE_LDESC," if by_enduse else "") +
            ("CTY_CODE,CTY_NAME," if by_country else "") +
            "ALL_VAL_MO"
        )
    }
    query = f"get={variables_list[trade_type]}"
    period = f"time=from+{monthly_start}"

    API_URL = f"{BASE_URL}{dataset}?{query}&{period}"
    print(API_URL)

    try:
        timeout_val = calc_timeout(monthly_start, by_country)
        resp = requests.get(API_URL, timeout=timeout_val)

        resp.raise_for_status()
    except requests.Timeout:
        return "timeout"
    except requests.RequestException as e:
        return f"Error: {str(e)}"

    if not resp.text.strip():
        return ValueError("No data returned for given parameters")

    try:
        data_json = resp.json()
        print("len:", len(data_json))
    except ValueError:
        return None

    return data_json


# Connect to MotherDuck
con = duckdb.connect(
    f"md:{DATABASE_NAME}"
)

for target_trade_type in target_trade_type_list:
    # Fetch Data
    data_records = get_api_data(
        trade_type=target_trade_type,
        monthly_start=target_monthly_start,
        by_country=BY_COUNTRY,
        by_enduse=BY_ENDUSE
    )

    if data_records in ["timeout", None] or isinstance(data_records, str):
        print("API fetch failed or returned empty.")
        con.close()
        exit()

    headers = data_records[0]
    rows = data_records[1:]
    arrow_table = pa.Table.from_arrays(
        [pa.array(col) for col in zip(*rows)] if rows else [],
        names=headers
    )

    con.register("arrow_table", arrow_table)

    # target_table
    table_name = f"us_trade_{target_trade_type}_enduse_monthly"

    target_table_name = (f"us_trade_{target_trade_type}" +
                         ("_enduse" if BY_ENDUSE else "") +
                         ("_country" if BY_COUNTRY else "") +
                         "_monthly"
                         )

    target_table = f"{DATABASE_NAME}.{SCHEMA}.{target_table_name}"
    print(target_table)

    # create new tables
    try:
        con.execute(f"""
            CREATE OR REPLACE TABLE {target_table} AS
            FROM arrow_table
        """)

        print(f"Table {target_table} created, started {target_monthly_start}.")
    except Exception as e:
        print(f"Table creation failed: {e}")

    # Test
    result = con.execute(f"SELECT * FROM {target_table} LIMIT 1").fetchall()
    print(result)

con.close()
