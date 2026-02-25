from read_csv(
    'https://www.census.gov/foreign-trade/reference/codes/enduse/exeumstr.txt',
    delim='\n',
    header=False,
    columns={'content':'VARCHAR'}
)
select
    regexp_extract(content, '^([0-9]+)', 1) AS code,
    TRIM(regexp_replace(content, '^[0-9]+', '')) AS description,
    LENGTH(code)::VARCHAR AS lvl
where regexp_matches(content, '^\s*[0-9]')