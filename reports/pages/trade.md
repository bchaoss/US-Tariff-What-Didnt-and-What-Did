# Imports

```sql monthly_import_dim
select 
    enduse_group,
    enduse,
    enduse_detail,
	-- year::INT::VARCHAR as year, 
	gen_value,
from monthly_import
```

```sql monthly_import_multi
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where ${inputs.multi_dimensions} 
group by all
```

```sql monthly_import_change
with cte AS (
select
    monthly,
    enduse_detail,
    sum(case when year=2025 then gen_value*1.0 else 0 end) as value_25,
    sum(case when year<>2025 then gen_value*1.0 else 0 end)/2.0 as value_2324,
from monthly_import
where ${inputs.multi_dimensions}
group by all
)
from cte c
select 
    monthly,
    enduse_detail,
    value_25 - value_2324 AS change,

    round( (value_25 / value_2324 *1.0) - 1.0, 5) AS pct_change,

    value_2324,
    SUM(value_2324) OVER (PARTITION BY monthly) as enduse_ttl,
    value_2324 / SUM(value_2324) OVER (PARTITION BY monthly) AS mix_byenduse,

    round( (value_25 / value_2324 *1.0) - 1.0, 5) * (value_2324 / SUM(value_2324) OVER (PARTITION BY monthly)) AS pct_change_mixin,
order by 1,2
```

```sql monthly_import_change_ttl
with cte AS (
select
    monthly,
    sum(case when year=2025 then gen_value else 0 end) as value_25,
    sum(case when year<>2025 then gen_value else 0 end)/2.0 as value_2324,
from monthly_import
where ${inputs.multi_dimensions}
group by all
)
from cte c
select 
    monthly,
    value_25 - value_2324 AS change,
    round( (value_25 / value_2324 *1.0) - 1.0, 5) AS pct_change,
```
<LineChart 
    title="US Goods Import Value"
    subtitle="by End Use"
    xAxisTitle="per month"
    data={monthly_import_multi}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
/>

<BarChart 
    title="YoY % Changes in US Goods Import Value"
    subtitle="by End Use"
    xAxisTitle="per month"
    data={monthly_import_change}
    x="monthly"
    y=pct_change_mixin
    series="enduse_detail"
    xFmt="yyyy-mmm"
    yFmt="pct1"
    yGridlines=false
>
    <ReferencePoint data={monthly_import_change_ttl} x=monthly y=pct_change labelPosition=bottom align=right />
</BarChart>

<DimensionGrid 
    data={monthly_import_dim} 
    metric='sum(gen_value)' 
    name=multi_dimensions 
    limit=16
    multiple
/>