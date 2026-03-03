---
title: US Imports
---

# How US Import Trends Shaped in 2025?

## Macro economic, front-tariff loading surge, and structural increasing categoies were adding fluctuations to the US imports.
<Tabs>
    <Tab label="Non-Tariff Driver">
        Non-Tariff Drivers:

- **Golds**: Spikes in Jan & Jul 2025 driven by rising gold prices and increased demand for safe-haven assets amid global economic uncertainties.
- **Petroleum**: Continuous decline due to low crude [oil prices](https://www.macrotrends.net/2483/brent-crude-oil-price-history) in 2025.

<Grid cols=2>
<BarChart 
    title="Gold"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Gold}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
    type=grouped
/>

<LineChart 
    title="Petroleum"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Petroleum}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
/>
</Grid>

```sql monthly_import_Gold
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Gold'
group by all
```

```sql monthly_import_Petroleum
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Petroleum'
group by all
```

    </Tab>
    <Tab label="Front-tariff Loading">
        Front-loading (surge in pre-tariff -> back to baseline):

- **Pharma:**
    Mar 2025 spike to $52B (vs ~$18-22B normal). Then reverted. And another smaller spike in Sep.
- **Finished Metal Shapes:** 
    Significant front-run surge in Q1 2025 with 10x than 2023/24 baseline ($20-30B vs $2-3B), then returned to near-normal levels after tariff affected.
- **Copper:**
    Surged from Apr to Jul due to tariff expectations. Imports crashed back after Aug when tariffs took effect, only to rise again in Dec along with prices.

<Grid cols=3>
<BarChart 
    title="Pharma"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Pharma}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
    type=grouped
/>

<BarChart 
    title="Finished Metal Shapes"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_FinishedMetal}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
    type=grouped
/>

<BarChart 
    title="Copper"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Copper}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
    type=grouped
/>
</Grid>

```sql monthly_import_Pharma
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Pharma'
group by all
```

```sql monthly_import_FinishedMetal
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Finished metal shapes'
group by all
```

```sql monthly_import_Copper
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Copper'
group by all
```

    </Tab>
    <Tab label="Structural Increase">
        Structural Increases:

- **Computers & Accessories:**
    Strong growth throughout 2025, with a notable surge in Q4. The increase is likely driven by demand for AI infrastructure, and tariff-exempted. (Notably, cell-phones which are also tariff-exempted, saw anegative YoY.)
- **Telecommunications Equipment:** Consistent growth similar to computers.

<Grid cols=2>
<LineChart 
    title="Computers & Accessories"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Computer}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
/>

<LineChart 
    title="Telecommunications Equipment"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Telecom}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
/>
</Grid>

```sql monthly_import_Computer
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Computers & Accessories'
group by all
```

```sql monthly_import_Telecom
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Telecom'
group by all
```

    </Tab>
</Tabs>


## Tariff pressured on most of Consumer Goods and Automotive categories were declining continuously after Apr. 2025.

- Consumer Goods (excluding Pharma)
- Automotive

<Grid cols=2>
<LineChart 
    title="Consumer Goods *"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Consumer}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
/>

<LineChart 
    title="Automotive"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Automotive}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
/>
</Grid>

```sql monthly_import_Consumer
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Consumer - Others'
group by all
```

```sql monthly_import_Automotive
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Automotive'
group by all
```

## Industrial, Capital Goods and Food & Beverage categories showed resilience under the tariffs, after excluding the Golds, front-traiff surge or structural increase of  some sub-categories.

- Industrial Goods (excluding Golds, Petroleum, Finished Metal Shapes, and Copper)
- Capital Goods (excluding Computers and Telecommunications equipment)
- Food, Feeds & Beverage

<!-- 
- Spotlight:
- Iron & Steel
- Gem diamonds & stones
-->
<Grid cols=3>
<LineChart 
    title="Industrial Goods *"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Industrial}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
/>
<LineChart 
    title="Capital Goods *"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Capital}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
/>
<LineChart 
    title="Food, Feeds & Beverage"
    subtitle="Import Value"
    yAxisTitle="USD"
    xAxisTitle="per month"
    data={monthly_import_Food}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
/>
</Grid>

```sql monthly_import_Industrial
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Industrial - Others'
group by all
```

```sql monthly_import_Capital
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Capital Goods - Others'
group by all
```

```sql monthly_import_Food
select 
	year,
    monthly,
	sum(gen_value) as gen_value,
from monthly_import
where enduse_detail = 'Foods & Bev'
group by all
```

# YoY Breakdown of US Import Trends, by End Use Categories

<LineChart 
    title="US Goods Import Value"
    xAxisTitle="per month"
    data={monthly_import_selected}
    x="monthly"
    y=gen_value
    series="year"
    xFmt="mmm"
    yFmt="usd1b"
    yGridlines=false
    colorPalette={['#a4b3bc', '#758ea2', '#3292b2']}
/>

<BarChart 
    title="YoY % Changes in US Goods Import Value, by End Use"
    subtitle="relative to 2023-24 avg."
    xAxisTitle="per month"
    data={monthly_import_change}
    x="monthly"
    y=pct_change_mixin
    series="enduse_detail"
    xFmt="yyyy-mmm"
    yFmt="pct1"
    yGridlines=false>
    <ReferencePoint data={monthly_import_change_ttl} x=monthly y=pct_change labelPosition=bottom align=right />
</BarChart>

<DimensionGrid 
    data={monthly_import_dim} 
    metric='sum(gen_value)' 
    name=multi_dimensions 
    limit=13
    multiple
/>

```sql monthly_import_dim
select 
    enduse_group,
    enduse,
    enduse_detail,
	-- year::INT::VARCHAR as year, 
	gen_value,
from monthly_import
```

```sql monthly_import_selected
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
    from monthly_import
    select
        monthly,
        sum(case when year=2025 then gen_value else 0 end) as value_25,
        sum(case when year<>2025 then gen_value else 0 end)/2.0 as value_2324,

    where ${inputs.multi_dimensions}
    group by all
)
from cte c
select 
    monthly,
    value_25 - value_2324 AS change,
    round( (value_25 / value_2324 *1.0) - 1.0, 5) AS pct_change,
```