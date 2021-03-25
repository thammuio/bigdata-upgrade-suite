-- Find a table or partitioin with wrong path
-- here im testing path that has "//""



USE ${DB};

-- find partitions with wrong paths

select DISTINCT db_name, tbl_name, part_name, regexp_extract(PART_LOCATION, 'hdfs://([^/]+)(.*)', 2) as PART_LOCATION from hms_dump_${ENV} 
WHERE
    instr(regexp_extract(PART_LOCATION, 'hdfs://([^/]+)(.*)', 2), "{") = 1;
