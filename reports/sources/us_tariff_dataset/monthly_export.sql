from marts.fact_us_trade_exports_enduse_country_monthly

select 
  export_type,

  REGION_NAME AS region,

  case
		when CTY_NAME in ('CHINA', 'CANADA', 'MEXICO', 'SINGAPORE'
											, 'SWITZERLAND', 'ITALY', 'UNITED KINGDOM') 
		then CTY_NAME
		when REGION_NAME IN ('ASIA', 'EUROPE') then concat(REGION_NAME, ' Other')
	else 'Others' end AS country,

	case
		when enduse_code = '40100' then 'Pharma'
		when enduse_code = '12260' then 'Gold' 
		when enduse_code = '61030' then 'RE Gold'
	else 'Others' end AS category,

	case 
		when enduse_code IN ('12260', '61030', '40100') then 'Gold & Pharma'
		when export_type = 'Foreign Export' then 'Re-Export'
		when CTY_NAME in ('CHINA', 'CANADA', 'MEXICO') then CTY_NAME
		-- when REGION_NAME IN ('ASIA', 'EUROPE') then concat(REGION_NAME, ' OTHER')		
	else 'Rest of World' end AS reason,

	month_begin_date,
	year, 
	month,
	concat('2025-', month, '-01')::DATE AS monthly,

	sum(ALL_VAL_MO) as all_value,

where year in (2023, 2024, 2025) 
  and CTY_NAME is not null

group by all
order by all