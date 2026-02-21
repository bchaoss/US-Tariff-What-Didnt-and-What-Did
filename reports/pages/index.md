---
title: What didn't and what did the Trump's Tariff do?
---
To the USA and the world.

Markdown can be used to write expressively in text.

- it supports lists,
- **bolding**, _italics_ and `inline code`,

<!-- 
- links to [external sites](https://google.com) and other [Evidence pages](/another/page)
-->

# What didn't the Trump's Tariffs do

## Trump's tariffs did not reduce the US trade deficit of goods.


# What did the Trump's Tariffs do, and realy?

## Trump's tariff did increase US fiscal revenue..., but

```sql monthly_treasury_tariff
select 
    month_begin_date, 
    cal_year,
    cal_month,
    amount as tariff_amount
from monthly_treasury
where month_begin_date>='2023-01-01'
    and classification = 'Customs Duties'
```

```sql monthly_treasury_tariff_yoy
select 
    month_begin_date, 
    cal_year, 
    concat('2026-', cal_month, '-01')::DATE as month,
    tariff_amount
from ${monthly_treasury_tariff}
```

```sql monthly_treasury_tariff_diff
with avg_2324 as (
    select
        cal_month,
        avg(tariff_amount) as avg_2324
    from ${monthly_treasury_tariff}
    where cal_year in (2023, 2024)
    group by all
)
select
    t.cal_year,
    t.cal_month,
    t.month_begin_date,
    concat('2026-', t.cal_month, '-01')::DATE as month,
    t.tariff_amount - a.avg_2324 as diff_vs_2324avg
from ${monthly_treasury_tariff} t
left join avg_2324 a
    on t.cal_month = a.cal_month
where t.cal_year in (2025, 2026)
order by all
```

Customs duties increased >$20B monthly after Jun 2025, compared with same month in 2023-2024.

<Grid cols=2>
<LineChart
    data={monthly_treasury_tariff_yoy}
    x="month"
    y="tariff_amount"
    series="cal_year"
    xFmt="mmm"
    yFmt="usd1b"
    markers=true
/>

<BarChart 
    data={monthly_treasury_tariff_diff}
    x=month
    y=diff_vs_2324avg
    series=cal_year
    type=grouped
    xFmt="mmm"
    yFmt="usd1b"
/>
</Grid>

<!-- 
    xFmt="mmm yyyy"
-->


### **But it's a very small amount of total fiscal revenue of US goverment.**
```sql monthly_treasury_revenue
select 
    month_begin_date, 
    cal_year,
    cal_month,
    case when classification = 'Customs Duties' then classification
    else 'Fiscal Revenue - Others' end as classification,
    sum(amount) as tariff_amount
from monthly_treasury
where month_begin_date>='2025-01-01'
group by all
```
<!-- 
-- ```sql monthly_treasury_total_yoy
-- select 
--     month_begin_date, 
--     cal_year, 
--     concat('2026-', cal_month, '-01')::DATE as month,
--     sum(amount) as tariff_amount
-- from monthly_treasury
-- where month_begin_date>='2023-01-01'
-- group by all
-- ``` 
-->

<Grid cols=2>
<LineChart 
    data={monthly_treasury_revenue}
    x=month_begin_date
    y=tariff_amount
    series=classification
    xFmt="mmm yyyy"
    yFmt="usd0b"
/>
</Grid>

<!-- Within the total US fiscal revenue over year, increased tariff only contributed 

<Grid cols=2>
<LineChart
    data={monthly_treasury_total_yoy}
    x="month"
    y="tariff_amount"
    series="cal_year"
    xFmt="mmm"
    yFmt="usd1b"
    ytickmarks=true
/>
</Grid> -->
