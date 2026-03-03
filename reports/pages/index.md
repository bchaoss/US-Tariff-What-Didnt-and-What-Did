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

The US trade deficit fluctuated significantly throughout 2025.

<Grid cols=2>
<LineChart 
    title="US Intl. Trade of Goods"
    subtitle=""
    yAxisTitle="value in USD"
    xAxisTitle="per month"
    data={monthly_trade_deficit}
    x=month_begin_date
    y={['import', 'export']}
    y2=deficit
    y2SeriesType=bar
    xFmt="mmm yyyy"
    yFmt="usd1b"
    y2Fmt="usd1b"
    yGridlines=false
    y2Gridlines=false
    seriesColors={{'import': '#f4a261', 'export': '#3292b2', 'deficit': '#f4a261'}}
    chartAreaHeight=240
/>
</Grid>

On a seasonal year-over-year comparison: the deficit surged in Q1 as businesses adopted a "pre-tariff" purchasing strategy; then, despite the tariffs taking effect in April, the deficit remained consistent with historical levels; until a second wave of large-scale tariffs in August caused the deficit to fall below historical benchmarks.

<Grid cols=2>
<BarChart 
    title="US Intl. Trade Deficit of Goods, Yearly Comparison"
    subtitle=""
    xAxisTitle="per month"
    data={monthly_trade_deficit}
    x=monthly
    y=deficit
    series=year
    type=grouped
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    chartAreaHeight=240
/>
</Grid>

```monthly_trade_deficit
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
    sum(import_value) AS import,
	sum(export_value) AS export,
    -sum(import_value - export_value) AS deficit
group by all
```

To better understand these dynamics, we should break down the import and export values separately.

### Imports

There are several distinct factors shaped US import trend in 2025:

- Non-Tariff Drivers: Golds (spikes in Jan & Jul); Petroleum (continuous decline due to low crude oil prices);
- Front-loading (surge in pre-tariff -> back to baseline): Pharma (Q1); Finished metal shapes (Q1); Copper (Apr - Aug);
- Structural Increases: Computers (tariff-exempted) & Telecommunications equipment's strong growth. 
    <Note>(It's likely driven by demand for AI infrastructure, as cell-phones which are also tariff-exempted, saw anegative YoY.)</Note>

<BarChart 
    title="YoY $Changes in US Goods Import Value, by Reason"
    subtitle="relative to 2023-24 avg."
    xAxisTitle="per month"
    data={monthly_import_change}
    x="monthly"
    y=change
    series="reason"
    seriesOrder={['Non-Tariff Drivers', 'Front-loading', 'Structural Increase', 'Consumer & Automotive *', 'Others (Industrial, Capital Goods, Foods & Bev)']}
    seriesColors={{
        'Non-Tariff Drivers': '#8dacbf', 
        'Front-loading': '#a4b3bc', 
        'Structural Increase': '#3292b2', 
        'Consumer & Automotive *': '#f4a261', 
        'Others (Industrial, Capital Goods, Foods & Bev)': '#a5cdee'}}
    xFmt="yyyy-mmm"
    yFmt="usd1b"
    yGridlines=false
    chartAreaHeight=260
>
    <ReferencePoint data={monthly_import_change_ttl} x=monthly y=change labelPosition=bottom align=right />
</BarChart>

Apart from the above, US imports of most consumer goods and automotive declined significantly under tariff pressure. Conversely, industrial, capital goods, and food categories swere affected to a limited extent.

```sql monthly_import_change
with cte AS (
select
    monthly,
    role,
    sum(case when year=2025 then gen_value*1.0 else 0 end) as value_25,
    sum(case when year<2025 then gen_value*1.0 else 0 end)/2.0 as value_2324,
from monthly_import
where 1=1
group by all
)
from cte c
select 
    monthly,
    role AS reason,
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
    from monthly_import
    select
        monthly,
        sum(case when year=2025 then gen_value else 0 end) as value_25,
        sum(case when year<>2025 then gen_value else 0 end)/2.0 as value_2324,
    where 1=1
    group by all
)
from cte c
select 
    monthly,
    value_25 - value_2324 AS change,
    round( (value_25 / value_2324 *1.0) - 1.0, 5) AS pct_change,
```


See the details about US import trends [here](us_imports).

### Exports


See detailed US exports by country chart [here](us_exports).


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


### **It accounts for a small share of the US government's total fiscal receipts.**

Though the threefold increase in collections has made tariffs become a primary source of fiscal growth.

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
order by class
```

