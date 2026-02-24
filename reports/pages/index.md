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

# What Trump's Tariffs Didn’t Do

## Trump's tariffs did not reshore production or create jobs for the US manufacturing sector.

```sql monthly_employees_mfg
select 
    data_type,
    month_begin_date, 
    year,
    month,
    concat('2026-', month, '-01')::DATE AS monthly,
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

## Trump's tariffs did not reduce the US trade deficit of goods.

# What Trump's Tariffs Did Do, and Yet the Reality.

## Well, Trump's tariffs did increase US fiscal revenue...

```sql monthly_treASury_tariff
select 
    month_begin_date, 
    cal_year,
    cal_month,
    amount AS tariff_amount
from monthly_treASury
where month_begin_date>='2023-01-01'
    and clASsification = 'Customs Duties'
```

```sql monthly_treASury_tariff_yoy
select 
    month_begin_date, 
    cal_year, 
    concat('2026-', cal_month, '-01')::DATE AS monthly,
    tariff_amount
from ${monthly_treASury_tariff}
```

```sql monthly_treASury_tariff_diff
with avg_2324 AS (
    select
        cal_month,
        avg(tariff_amount) AS avg_2324
    from ${monthly_treASury_tariff}
    where cal_year in (2023, 2024)
    group by all
)
select
    t.cal_year,
    t.cal_month,
    t.month_begin_date,
    concat('2026-', t.cal_month, '-01')::DATE AS monthly,
    t.tariff_amount - a.avg_2324 AS diff_vs_2324avg
from ${monthly_treASury_tariff} t
left join avg_2324 a
    on t.cal_month = a.cal_month
where t.cal_year in (2025, 2026)
order by all
```

Starting in March 2025, US customs duties increased, and have been >$20 billion higher per month since June 2025, compared with the 2023-2024 average for the same month.

<Grid cols=2>
<LineChart
    title="US customs duties by month"
    yAxisTitle="Customs duties"
    xAxisTitle="per month"
    data={monthly_treASury_tariff_yoy}
    x="monthly"
    y="tariff_amount"
    series="cal_year"
    xFmt="mmm"
    yFmt="usd1b"
    markers=true
    yGridlines=false
/>

<BarChart 
    title="Change in US customs duties"
    subtitle="relative to 2023-2024 average"
    yAxisTitle="Difference from previous years"
    xAxisTitle="per month"
    data={monthly_treASury_tariff_diff}
    x=monthly
    y=diff_vs_2324avg
    series=cal_year
    type=grouped
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false>
    <ReferenceLine y=20000000000 hideValue/>
</BarChart>

</Grid>

<!-- 
    xFmt="mmm yyyy"
-->


### **But it is a very small share of the US government's total fiscal revenue.**
```sql monthly_treASury_revenue
select 
    month_begin_date, 
    cal_year,
    cal_month,
    cASe when clASsification = 'Customs Duties' then clASsification
    else 'Fiscal Revenue - Others' end AS clASsification,
    sum(amount) AS tariff_amount
from monthly_treASury
where month_begin_date>='2025-01-01'
group by all
```
<!-- 
-- ```sql monthly_treASury_total_yoy
-- select 
--     month_begin_date, 
--     cal_year, 
--     concat('2026-', cal_month, '-01')::DATE AS month,
--     sum(amount) AS tariff_amount
-- from monthly_treASury
-- where month_begin_date>='2023-01-01'
-- group by all
-- ``` 
-->

<Grid cols=2>
<LineChart 
    data={monthly_treASury_revenue}
    x=month_begin_date
    y=tariff_amount
    series=clASsification
    xFmt="mmm yyyy"
    yFmt="usd0b"
    yGridlines=false
/>
</Grid>

<!-- Within the total US fiscal revenue over year, increased tariff only contributed 

<Grid cols=2>
<LineChart
    data={monthly_treASury_total_yoy}
    x="month"
    y="tariff_amount"
    series="cal_year"
    xFmt="mmm"
    yFmt="usd1b"
    ytickmarks=true
/>
</Grid> -->
