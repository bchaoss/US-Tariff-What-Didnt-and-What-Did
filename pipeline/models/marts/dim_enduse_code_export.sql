{% set levels = [1,2,3,5] %}

with base AS ( from {{ ref('enduse_code_export') }} ),

codes AS (
	select
		{% for lvl in levels[0:4] %}
		LEFT(code, {{ lvl }}) AS eu{{ lvl }}_code,
		{% endfor %}
		code AS eu5_code,
	from base
	where LENGTH(code) = 5
)

select
	{% for lvl in levels %}
	c.eu{{ lvl }}_code,
	eu{{ lvl }}.description AS eu{{ lvl }}_desc,
	{% endfor %}
from codes c
	{% for lvl in levels %}
	left join base eu{{ lvl }} on eu{{ lvl }}.code = c.eu{{ lvl }}_code
	{% endfor %}
