---
title: What didn't and what did the Trump's Tariff do?
---
To the USA and the world.

<!--
Markdown can be used to write expressively in text.

- it supports lists,
- **bolding**, _italics_ and `inline code`,
- links to [external sites](https://google.com) and other [Evidence pages](/another/page)
-->

# What Trump's Tariffs Didn't Do

## Did Trump's tariffs reduce the US trade deficit of goods?

### Imports

See detailed US imports by end use chart [here](us_imports).

See detailed US exports by country chart [here](us_exports).



```monthly_trade_gap
from (
select
    month_begin_date,
	year,
    month,
    monthly,
    sum(gen_value) AS import_value,
	0.0 AS export_value,
from monthly_import
group by all

union all

select
    month_begin_date,
	year,
    month,
    monthly,
    0.0 AS import_value,
	sum(all_value) AS export_value,
from monthly_export
group by all
)
select 
    month_begin_date,
	year,
    month,
    monthly,
    sum(import_value) import_value,
	sum(export_value) export_value,
    -sum(import_value - export_value) AS gap
group by all
```

<Grid cols=2>
<BarChart 
    title=""
    subtitle=""
    yAxisTitle=""
    xAxisTitle="per month"
    data={monthly_trade_gap}
    x=monthly
    y=gap
    series=year
    type=grouped
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
/>


<LineChart 
    title=""
    subtitle=""
    yAxisTitle=""
    xAxisTitle="per month"
    data={monthly_trade_gap}
    x=month_begin_date
    y={['import_value', 'export_value']}
    y2=gap
    y2SeriesType=bar
    xFmt="mmm yyyy"
    yFmt="usd1b"
    y2Fmt="usd1b"
    yGridlines=false
/>
</Grid>

## Trump's tariffs did not reshore production or create jobs for the US manufacturing sector.

```sql monthly_employees_mfg
select 
    data_type,
    month_begin_date, 
    year,
    month,
    monthly,
    value AS employee_amount
from monthly_labor
where month_begin_date>='2023-01-01'
```

```sql monthly_employees_mfg_prod
from ${monthly_employees_mfg}
where year>=2024
    and data_type = 'Production & Non-Supervisory Employees'
order by 1,2 desc
```

```sql monthly_employees_mfg_prod_non
from ${monthly_employees_mfg}
where year>=2024
    and data_type = 'Non-Production Employees'
order by 1,2 desc
```

There is no sign of employment revival in US manufacturing, whether in total staffing or among production employees. 

From a long-term perspective, manufacturing employment continues to decline, and the decline is more notably for production employees.

<Grid cols=2>
<LineChart
    title="Production & Non-Supervisory Employees, in US Manufacturing"
    yAxisTitle="Employees"
    data={monthly_employees_mfg_prod}
    x="month_begin_date"
    y="employee_amount"
    series=data_type
    xFmt="mmm yyyy"
    yFmt="num1m"
    yGridlines=false
    yBaseline=true
    yMin=8000000
    chartAreaHeight=220
/>

<LineChart
    title="Non-Production or Supervisory Employees, in US Manufacturing"
    yAxisTitle="Employees"
    data={monthly_employees_mfg_prod_non}
    x="month_begin_date"
    y="employee_amount"
    series=data_type
    xFmt="mmm yyyy"
    yFmt="num1m"
    yGridlines=false
    yBaseline=true
    yMin=3000000
    chartAreaHeight=220
/>

</Grid>


# What Trump's Tariffs Did Do, and Yet the Reality.

## Well, Trump's tariffs did increase US fiscal revenue...

Starting in March 2025, US customs duties increased, and have been >$20 billion higher per month since June 2025, compared with the 2023-2024 average for the same month.

<Grid cols=2>
<LineChart
    title="US Customs Duties, Yearly "
    xAxisTitle="per month"
    data={monthly_treasury_tariff_yoy}
    x="monthly"
    y="tariff_amount"
    series="cal_year"
    xFmt="mmm"
    yFmt="usd1b"
    markers=true
    yGridlines=false
/>

<BarChart 
    title="Change in US Customs Duties"
    subtitle="relative to 2023-2024 average"
    yAxisTitle="Difference from previous years"
    xAxisTitle="per month"
    data={monthly_treasury_diff_tariff}
    x=monthly
    y=diff_vs_2324avg
    series=cal_year
    type=grouped
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#45a1bf', '#236aa4']}>
    <ReferenceLine y=20000000000 hideValue/>
</BarChart>

</Grid>


### **But it is a very small share of the US government's total fiscal receipt.**

<Grid cols=2>
<AreaChart 
    title="Share of Customs Duties in US Fiscal Receipt"
    data={monthly_treasury_receipt_share}
    x=month_begin_date
    y=receipt_amount
    series=class
    xFmt="mmm yyyy"
    yFmt="pct0"
    yGridlines=false
    seriesColors={{'Fiscal Revenue - Others': '#45a1bf' ,'Customs Duties': '#236aa4'}}
    type=stacked100
/>

<BarChart
    data={monthly_treasury_diff}
    x=month_begin_date
    y=diff_vs_2324avg
    series=class
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    seriesColors={{'Fiscal Revenue - Others': '#45a1bf' ,'Customs Duties': '#236aa4'}}
/>
</Grid>



```sql monthly_treasury_base
select 
    month_begin_date, 
    cal_year,
    cal_month,
    monthly,
    case when classification = 'Customs Duties' then classification
        else 'Fiscal Receipt - Others' 
    end AS class,
    sum(amount) amount
from monthly_treasury
where month_begin_date>='2023-01-01'
group by all
```

```sql monthly_treasury_tariff_yoy
select
    month_begin_date, 
    cal_year, 
    monthly,
    amount AS tariff_amount
from ${monthly_treasury_base}
where class = 'Customs Duties'
```

```sql monthly_treasury_diff
with avg_2324 AS (
    select
        cal_month,
        class,
        avg(amount) AS avg_2324
    from ${monthly_treasury_base}
    where cal_year in (2023, 2024)
    group by all
)
select
    t.cal_year,
    t.cal_month,
    t.month_begin_date,
    t.monthly,
    t.class,
    t.amount - a.avg_2324 AS diff_vs_2324avg
from ${monthly_treasury_base} t
left join avg_2324 a
    on t.cal_month = a.cal_month and t.class = a.class
where t.cal_year in (2025, 2026)
order by all asc
```

```monthly_treasury_diff_tariff
select *
from ${monthly_treasury_diff}
where class = 'Customs Duties'
```

```sql monthly_treasury_receipt_share
select 
    month_begin_date,
    cal_year,
    cal_month,
    class,
    sum(amount) AS receipt_amount
from ${monthly_treasury_base}
where month_begin_date>='2025-01-01'
group by all
```

