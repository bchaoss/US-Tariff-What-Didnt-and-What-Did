from {{ source('raw', 'us_trade_exports_country_monthly') }}

select 
    SUBSTR(cty_code,1,1) AS region_code,
    cty_name AS region_name,
    
where cty_code like '%XXX'
group by all