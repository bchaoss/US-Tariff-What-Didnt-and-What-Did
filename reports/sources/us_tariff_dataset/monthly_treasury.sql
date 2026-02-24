from marts.fact_us_treasury_statement_monthly

select
  statement_type,
  classification_type,
  month_begin_date,
  month_end_date,
  record_calendar_year as cal_year,
  record_calendar_month as cal_month,
  case 
    when classification_desc in ('Employment and General Retirement', 'Unemployment Insurance', 'Other Retirement') 
    then 'Social Insurance & Retirement'
    else classification_desc
  end as classification,
  sum(amount) as amount

where statement_type = 'Receipt'
group by all