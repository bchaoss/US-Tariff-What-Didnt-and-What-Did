{% set levels = [1,2,3] %}

from {{ source('raw', 'us_trade_exports_enduse_monthly') }} a
left join {{ ref('dim_enduse_code_export') }} c
  on a.E_ENDUSE = c.eu5_code and a.comm_lvl = 'EU5'

select 
  a.DF,
  
  a.E_ENDUSE AS enduse_code,
  c.eu5_desc AS enduse_desc,
  {% for lvl in levels %}
  c.eu{{ lvl }}_code,
  c.eu{{ lvl }}_desc,
  {% endfor %}

  YEAR(STRPTIME(time, '%Y-%m'))  as year,
  MONTH(STRPTIME(time, '%Y-%m')) as month,
  STRPTIME(time || '-01', '%Y-%m-%d') as month_begin_date,

  {% for column in ['ALL_VAL_MO'] %}
  a.{{ column }}::DECIMAL(18,2) AS {{ column }},
  {% endfor %}