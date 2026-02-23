from {{ source('labor', 'raw_series') }}
select
  TRIM(series_id) AS series_id,
  * exclude (series_id)
where end_year >= 2026 -- monthly series only