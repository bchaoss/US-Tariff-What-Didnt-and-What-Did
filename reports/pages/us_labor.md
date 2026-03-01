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