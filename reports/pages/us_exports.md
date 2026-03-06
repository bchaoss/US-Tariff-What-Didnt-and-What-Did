---
title: US Exports
---


# Exports

- Gold: UK, Switzerland
- Pharma: Italy, EUPORE
- Re-Exports
- US Exports
    - Decrease:
        - China
        - Canada
        - Mexico
        - Singapore
    - Increase:
        - EUPORE
        
```sql monthly_export_dim
select 
    export_type,
    region,
    country,
    category,
	all_value,
from monthly_export
```

```sql monthly_export_selected
select 
    year,
    monthly,
    sum(all_value) as all_value,
from monthly_export
where ${inputs.multi_dimensions} 
group by all
```

```sql monthly_export_change
with cte AS (
select
    monthly,
    country,
    sum(case when year=2025 then all_value*1.0 else 0 end) as value_25,
    sum(case when year<2025 then all_value*1.0 else 0 end)/2.0 as value_2324,
from monthly_export
where ${inputs.multi_dimensions}
group by all
)
from cte c
select 
    monthly,
    country,
    value_25 - value_2324 AS change,

    round( (value_25 / value_2324 *1.0) - 1.0, 5) AS pct_change,

    value_2324,
    SUM(value_2324) OVER (PARTITION BY monthly) as enduse_ttl,
    value_2324 / SUM(value_2324) OVER (PARTITION BY monthly) AS mix_byenduse,

    round( (value_25 / value_2324 *1.0) - 1.0, 5) * (value_2324 / SUM(value_2324) OVER (PARTITION BY monthly)) AS pct_change_mixin,
order by 1,2
```

```sql monthly_export_change_ttl
with cte AS (
select
    monthly,
    sum(case when year=2025 then all_value else 0 end) as value_25,
    sum(case when year<2025 then all_value else 0 end)/2.0 as value_2324,
from monthly_export
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
    title="US Goods Export Value"
    subtitle="by Country"
    xAxisTitle="per month"
    data={monthly_export_selected}
    x="monthly"
    y=all_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
/>

<!-- <BarChart 
    title="YoY % Changes in US Goods Export Value"
    subtitle="by Country"
    xAxisTitle="per month"
    data={monthly_export_change}
    x="monthly"
    y=pct_change_mixin
    series="country"
    xFmt="yyyy-mmm"
    yFmt="pct1"
    yGridlines=false
>
    <ReferencePoint data={monthly_export_change_ttl} x=monthly y=pct_change labelPosition=bottom align=right />
</BarChart> -->

<BarChart 
    title="YoY Changes in US Goods Export Value $"
    subtitle="by Country"
    xAxisTitle="per month"
    data={monthly_export_change}
    x="monthly"
    y=change
    series="country"
    xFmt="yyyy-mmm"
    yFmt="usd1b"
    yGridlines=false
>
    <ReferencePoint data={monthly_export_change_ttl} x=monthly y=change labelPosition=bottom align=right />
</BarChart>

<DimensionGrid 
    data={monthly_export_dim} 
    metric='sum(all_value)' 
    name=multi_dimensions 
    limit=15
    multiple
/>