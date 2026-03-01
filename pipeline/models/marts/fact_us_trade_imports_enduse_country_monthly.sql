{% set levels = [1,2,3] %}

from {{ source('raw', 'us_trade_imports_enduse_country_monthly') }} a
left join {{ ref('dim_enduse_code_import') }} c
  on a.I_ENDUSE = c.eu5_code 

select 
  a.I_ENDUSE AS enduse_code,
  c.eu5_desc AS enduse_desc,
  {% for lvl in levels %}
  c.eu{{ lvl }}_code,
  c.eu{{ lvl }}_desc,
  {% endfor %}

  CTY_CODE,
  CTY_NAME,

  YEAR(STRPTIME(time, '%Y-%m'))  as year,
  substr(time, 6, 2) as month,
  STRPTIME(time || '-01', '%Y-%m-%d')::DATE as month_begin_date,

  {% for column in ['GEN_VAL_MO', 'CON_VAL_MO', 'CAL_DUT_MO', 'CON_CHA_MO'] %}
  a.{{ column }}::DECIMAL(18,2) AS {{ column }},
  {% endfor %}
  
where a.comm_lvl = 'EU5'