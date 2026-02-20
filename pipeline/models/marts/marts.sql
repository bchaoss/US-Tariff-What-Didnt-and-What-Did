select 
    row_number() over (order by tpep_pickup_datetime) as id,
    * 
from sample_data.nyc.taxi
limit 10
