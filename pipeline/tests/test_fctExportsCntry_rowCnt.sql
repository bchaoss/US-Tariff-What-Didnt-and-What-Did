with a as (
    select count(*) as cnt from {{ ref('fact_us_trade_exports_country_monthly') }}
),
b as (
    select count(*) as cnt 
    from {{ source('raw', 'us_trade_exports_country_monthly') }} a
    where not (
        a.cty_code='-'
        OR
        a.cty_code like '00%'
        OR
        a.cty_code like '%XXX'
        )
    and a.DF <> '-'
)

select *
from a
    join b on 1=1
where a.cnt != b.cnt