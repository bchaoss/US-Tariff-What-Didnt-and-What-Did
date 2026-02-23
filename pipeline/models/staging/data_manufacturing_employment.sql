from {{ source('labor', 'raw_data_30a_Manufacturing_Employment') }}
select
  TRIM(series_id) AS series_id,
  year,
  period,
  value,
  footnote_codes,