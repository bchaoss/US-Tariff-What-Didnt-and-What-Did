```sql monthly_import_dim
select 
    enduse_group,
    enduse,
    enduse_detail,
	year::INT::VARCHAR as year, 
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

<DimensionGrid 
    data={monthly_import_dim} 
    metric='sum(gen_value)' 
    name=multi_dimensions 
    limit=16
    multiple
/>

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