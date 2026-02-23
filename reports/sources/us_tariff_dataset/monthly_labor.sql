with base_data as (
  from marts.fact_us_manufacturing_employees_monthly
  select 
    concat(year, '-', month, '-01')::DATE AS month_begin_date,
    value as value_in_THOUSAND,
    value * 1000 as value,
    case when data_type = 'ALL EMPLOYEES, THOUSANDS' then 'Total Employees'
         when data_type = 'PRODUCTION AND NONSUPERVISORY EMPLOYEES, THOUSANDS' then 'Production & Non-Supervisory Employees'
    else NULL end as data_type,
    * exclude (value, data_type),
),
non_prod AS (
  select 
    month_begin_date, year, month,
    'Non-Production Employees' AS data_type,
    SUM(case when data_type = 'Total Employees' then value 
             when data_type = 'Production & Non-Supervisory Employees' then -value 
        else 0 end) AS value
  from base_data
  group by all
)

select 
  data_type, month_begin_date, year, month, 
  value
from base_data

UNION ALL

select 
  data_type, month_begin_date, year, month, 
  value
from non_prod