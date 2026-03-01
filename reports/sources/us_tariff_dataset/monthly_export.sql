from marts.fact_us_trade_exports_country_monthly

select 
  export_type,
  REGION_NAME AS region,
  CTY_NAME AS country,

	month_begin_date,
	year, 
	month,
	concat('2025-', month, '-01')::DATE AS monthly,

	sum(ALL_VAL_MO) as all_value,

where year in (2023, 2024, 2025) 
  and CTY_NAME is not null

group by all
order by all