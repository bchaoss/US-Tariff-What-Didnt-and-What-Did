from marts.fact_us_trade_imports_enduse_monthly

select 
	case 
		when eu1_code = '0' then 'Foods & Bev'
    when eu1_code = '1' then 'Industrial'
    when eu1_code = '2' then 'Capital Goods'
    when eu1_code = '3' then 'Automotive'
    when eu1_code = '4' then 'Consumer'
		else eu1_desc 
	end AS enduse_group,

	case 
		when enduse_code = '14270' then 'Gold'
    when enduse_code = '40100' then 'Pharma'
    when eu1_code = '1' then concat(enduse_group, ' (ex-Gold)')
    when eu1_code = '4' then concat(enduse_group, ' (ex-Pharma)')
		else enduse_group 
	end AS enduse,

	case
		when enduse_code = '14270' then 'Gold'
    when enduse_code = '40100' then 'Pharma'
    
    when enduse_code IN ('14000','14100','15000','15100') then 'Iron & Steel'
    when enduse_code IN ('14200') then 'Aluminum'
    when enduse_code in ('14220') then 'Copper'
    when enduse_code IN ('15200') then 'Finished metal shapes'
    
		when enduse_code IN ('42100', '42110') then 'Gem diamonds & stones'

  	when eu3_code='213' and enduse_code!='21320' then 'Computers & Accessories' -- Computers, peripherals
		when eu3_code='214' then 'Telecom' -- Telecommunications equipment
    
		when eu1_code in ('1', '2', '4') then concat(enduse_group, ' - Others')
    else enduse_group
	end AS enduse_detail,

	eu1_desc,
	eu2_desc,
	eu3_desc,
	enduse_desc as eu5_desc,

	month_begin_date,
	year, 
	month,
	concat('2026-', month, '-01')::DATE AS monthly,

	sum(GEN_VAL_MO) as gen_value,
	sum(CON_VAL_MO) as con_value,

where year in (2023, 2024, 2025) 
  and eu1_desc is not null

group by all
order by all