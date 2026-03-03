from marts.fact_us_trade_exports_country_monthly

select 
  export_type,
  case when export_code = 'F' then '-'
		else REGION_NAME end AS region,
  case when export_code = 'F' then '-'
		else CTY_NAME end AS country,

	month_begin_date,
	year, 
	month,
	concat('2025-', month, '-01')::DATE AS monthly,

	sum(ALL_VAL_MO) as all_value,

where year in (2023, 2024, 2025) 
  and CTY_NAME is not null

group by all
order by all