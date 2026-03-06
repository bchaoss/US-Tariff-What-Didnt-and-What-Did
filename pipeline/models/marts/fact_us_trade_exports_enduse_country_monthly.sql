{% set levels = [1,2,3] %}

from {{ source('raw', 'us_trade_exports_enduse_country_monthly') }} a
left join {{ ref('dim_enduse_code_export') }} c
  on a.E_ENDUSE = c.eu5_code 
left join {{ ref('dim_region_lookup') }} r
  on SUBSTR(a.cty_code,1,1) = r.region_code

select 
  a.DF,
  case when a.DF = '1' then 'Domestic Export'
    when a.DF = '2' then 'Foreign Export'
  end AS export_type,

  a.E_ENDUSE AS enduse_code,
  c.eu5_desc AS enduse_desc,
  {% for lvl in levels %}
  c.eu{{ lvl }}_code,
  c.eu{{ lvl }}_desc,
  {% endfor %}

  a.CTY_CODE,
  a.CTY_NAME,
  r.REGION_NAME,

  YEAR(STRPTIME(time, '%Y-%m'))  as year,
  substr(time, 6, 2) as month,
  STRPTIME(time || '-01', '%Y-%m-%d')::DATE as month_begin_date,

  {% for column in ['ALL_VAL_MO'] %}
  a.{{ column }}::DECIMAL(18,2) AS {{ column }},
  {% endfor %}

where not (
  a.cty_code='-'         -- Total
  OR
  a.cty_code like '00%'  -- Orgs
  OR
  a.cty_code like '%XXX' -- Regions
)
and a.DF <> '-'
and a.comm_lvl = 'EU5'