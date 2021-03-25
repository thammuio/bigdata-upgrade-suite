-- Find a table or partitioin with wrong path
-- here im testing path that has "//""



USE ${DB};

-- find tables with wrong paths
select DISTINCT db_name, tbl_name, regexp_extract(tbl_location, 'hdfs://([^/]+)(.*)', 2) as tbl_location from hms_dump_${ENV} 
WHERE
    instr(regexp_extract(tbl_location, 'hdfs://([^/]+)(.*)', 2), "{") = 1;
