with base_data as (
  from marts.fact_us_manufacturing_employees_monthly

  select 
    month_begin_date,
    year, 
    month,
    value as value_in_THOUSAND,
    value * 1000 as value,
    case when data_type = 'ALL EMPLOYEES, THOUSANDS' then 'Total Employees'
         when data_type = 'PRODUCTION AND NONSUPERVISORY EMPLOYEES, THOUSANDS' then 'Production & Non-Supervisory Employees'
    else NULL end as data_type,
),

non_prod AS (
  from base_data
  select 
    month_begin_date, 
    year, 
    month,
    SUM(case when data_type = 'Total Employees' then value 
             when data_type = 'Production & Non-Supervisory Employees' then -value 
        else 0 end) AS value,
    'Non-Production Employees' AS data_type,
  group by all
)

from base_data
select 
  data_type, month_begin_date, year, month,
  value

UNION ALL

from non_prod
select 
  data_type, month_begin_date, year, month,
  value