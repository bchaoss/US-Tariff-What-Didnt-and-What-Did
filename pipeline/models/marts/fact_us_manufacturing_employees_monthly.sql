from {{ref('data_manufacturing_employment')}} AS e
left join {{ ref('dim_labor_series') }} AS s
  on e.series_id = s.series_id
left join {{ source('labor', 'raw_seasonal') }} AS sea
  on s.seasonal = sea.seasonal_code
left join {{ source('labor', 'raw_supersector') }} AS ss
  on s.supersector_code = ss.supersector_code
left join {{ source('labor', 'raw_period') }} AS p
  on e.period = p.period
left join {{ source('labor', 'raw_datatype') }} AS t
  on s.data_type_code = t.data_type_code
left join {{ source('labor', 'raw_footnote') }} AS f
  on e.footnote_codes = f.footnote_code

SELECT
  t.data_type_text AS data_type,
  e.series_id,
  e.year,
  e.period,
  SUBSTR(e.period, 2) AS month,
  e.value,
  e.footnote_codes,
  f.footnote_text,
  s.supersector_code,
  ss.supersector_name,
  s.industry_code,
  s.seasonal,
  sea.seasonal_text,
  s.series_title,

WHERE 1=1
  and e.year >= 2025
  and sea.seasonal_text = 'Not Seasonally Adjusted'
  and ss.supersector_name = 'Manufacturing'
  and p.period <> 'M13'
  and t.data_type_code in ('01', '06')

group by all