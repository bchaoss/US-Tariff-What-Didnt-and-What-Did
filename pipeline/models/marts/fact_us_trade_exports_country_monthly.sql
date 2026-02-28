-- depends_on: {{ ref('dim_region_lookup') }}

from {{ source('raw', 'us_trade_exports_country_monthly') }} a
left join {{ ref('dim_region_lookup') }} c
  on SUBSTR(a.cty_code,1,1) = c.region_code

select
  DF,

  a.CTY_CODE,
  a.CTY_NAME,
  c.REGION_NAME,

  YEAR(STRPTIME(time, '%Y-%m'))  as year,
  SUBSTR(time, 6, 2) as month,
  STRPTIME(time || '-01', '%Y-%m-%d')::DATE as month_begin_date,

  {% for column in ['ALL_VAL_MO'] %}
  {{ column }}::DECIMAL(18,2) AS {{ column }},
  {% endfor %}

where not (
  a.cty_code='-'         -- Total
  OR
  a.cty_code like '00%'  -- Orgs
  OR
  a.cty_code like '%XXX' -- Regions
)