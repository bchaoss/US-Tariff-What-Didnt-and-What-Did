from read_csv(
    'https://www.census.gov/foreign-trade/reference/codes/enduse/imeumstr.txt',
    delim='\n',
    header=False,
    columns={'content':'VARCHAR'}
)
select
    regexp_extract(content, '^([0-9]+)', 1) AS code,
    trim(regexp_replace(content, '^[0-9]+', '')) AS description
where regexp_matches(content, '^\s*[0-9]')