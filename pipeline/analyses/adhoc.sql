{# select * 
from read_json_auto('{{ var("raw_data_path") }}/mts.json') #}

{# from {{ref('fact_us_manufacturing_employees_monthly')}}
select * 
limit 20 #}