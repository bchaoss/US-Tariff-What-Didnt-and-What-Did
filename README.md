# US Tariff: What didn't and what did do

<img width="2244" height="1266" alt="image" src="https://github.com/user-attachments/assets/e53c4a9f-095f-41fc-86b0-73db94f078f2" />

## Data Source

[US Monthly Treasury Statement](https://fiscaldata.treasury.gov/datasets/monthly-treasury-statement/summary-of-receipts-by-source-and-outlays-by-function-of-the-u-s-government)

[US Census Bureau, International Trade Datasets](https://www.census.gov/data/developers/data-sets/international-trade.html)


***

<pre>
.
├── ingest/
├── data/
│
├── pipeline/
│   ├── analyses/
│   ├── macros/
│   ├── models/
│   ├── seeds/
│   ├── tests/
│   ├── dbt_project.yml
│   └── profiles.yml
│
├── reports/
│   ├── .evidence/customization
│   ├── build/
│   ├── pages/
│   ├── scripts/
│   ├── sources/
│   ├── evidence.config.yaml
│   ├── package-lock.json
│   └── package.json
│
├── .devcontainer/
├── .github/workflows
└── requirements.txt
</pre>


##  Get start

Using [dbt](https://www.getdbt.com/), [duckdb](https://duckdb.org/) ([MotherDuck](https://www.motherduck.com/)) and [Evidence BI](https://github.com/evidence-dev/evidence?tab=readme-ov-file).

Open in Github Codespace by `.devcontainer`:

### dbt Pipeline
```bash
cd pipeline
dbt deps
dbt test
dbt run
dbt docs generate
```

### Reports
```bash
cd reports
npm install 
npm run sources
npm run dev 
```


