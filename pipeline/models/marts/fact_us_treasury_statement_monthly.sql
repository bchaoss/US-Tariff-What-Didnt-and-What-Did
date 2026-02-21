with cleaned as ( 
from {{ source('raw', 'us_treasury_statement_monthly') }}
select 
  data_type_cd,
  record_date,
  record_type_cd,
  classification_id,
  classification_desc,
  try_cast(current_month_rcpt_outly_amt as numeric(18,2)) as amount,
  record_calendar_year,
  record_calendar_quarter,
  record_calendar_month,
where 1=1
  -- and record_calendar_year=2026
  and data_type_cd = 'D'
  and not ( record_type_cd = 'SL' or current_month_rcpt_outly_amt = 'null' )
)
from cleaned
select
  case when record_type_cd = 'RSG' then 'Receipt'
    when record_type_cd = 'F' then 'Outlay'
    end as statement_type,
  case when record_type_cd = 'RSG' then 'Source'
    when record_type_cd = 'F' then 'Function'
    end as classification_type,
  date_trunc('month', record_date) as month_begin_date,
  record_date as month_end_date,
  * EXCLUDE (record_date)
order by 
  month_begin_date, statement_type, classification_type, classification_desc