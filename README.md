# Analytics Engineering Template
Using [dbt](https://www.getdbt.com/), [duckdb](https://duckdb.org/) ([MotherDuck](https://www.motherduck.com/)) and [Evidence BI](https://github.com/evidence-dev/evidence?tab=readme-ov-file).

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
