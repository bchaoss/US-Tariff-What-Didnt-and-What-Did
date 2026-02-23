# US Tariff: What didn't and what did do

[Please find the report here.](https://bchaoss.github.io/US-Tariff-What-Didnt-and-What-Did/)

![treasury_report](./docs/images/treasury_report.jpg)

## Data Source

[US Monthly Treasury Statement](https://fiscaldata.treasury.gov/datasets/monthly-treasury-statement/summary-of-receipts-by-source-and-outlays-by-function-of-the-u-s-government)

[US Census Bureau, International Trade Datasets](https://www.census.gov/data/developers/data-sets/international-trade.html)

## Reference

[Do Trump's Tariffs Make Sense? Douglas A.Irwin, Hayek Lecture Series](https://www.youtube.com/watch?v=rGafYjEqWWs&t=879s)

[Has Trump Actually Shrunk the Trade Deficit? TLDR News Global](https://www.youtube.com/watch?v=PWV3bFIh-go&t=221s)

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


