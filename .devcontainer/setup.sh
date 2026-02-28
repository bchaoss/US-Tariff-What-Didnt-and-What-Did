#!/bin/bash
set -e # stop when error
set -x

# dbt install and deps
pip install -r requirements.txt

# bi install and setup
cd reports
npm install
if [ -z "${MOTHERDUCK_TOKEN}" ]; then
    echo "MOTHERDUCK_TOKEN is not setup."
else
    echo "EVIDENCE_SOURCE__us_tariff_dataset__token=${MOTHERDUCK_TOKEN}" >> .env
    npm run sources
fi

echo "post setup finished."