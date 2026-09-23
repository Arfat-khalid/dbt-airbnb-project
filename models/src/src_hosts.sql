with raw_hosts AS (
    SELECT * FROM main.raw_hosts
)
select 
id as host_id, 
"name" as host_name, 
is_superhost, 
created_at, 
updated_at
FROM raw_hosts