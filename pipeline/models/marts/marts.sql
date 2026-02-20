select 
    row_number() as id,
    * 
from who.ambient_air_quality 

limit 10
