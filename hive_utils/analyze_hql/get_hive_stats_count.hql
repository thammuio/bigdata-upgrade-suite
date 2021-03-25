USE ${DB};


-- insert Hive Stats into hive_stats_count_${ENV}
INSERT INTO
  hive_stats_count_${ENV} (total_dbs,total_tables,total_managed_tables,total_managed_tables_appshive,total_managed_tables_userhive,total_external_tables,total_virtual_views)
SELECT
v1.total_dbs,v2.total_tables,v3.total_managed_tables,v4.total_managed_tables_appshive,v5.total_managed_tables_userhive,v6.total_external_tables,v7.total_virtual_views
FROM
-- get count of all databases
  (select count (DISTINCT db_name) as total_dbs from hms_dump_${ENV}) AS v1
CROSS JOIN
-- get count of all tables
  (select count (DISTINCT TBL_NAME) as TOTAL_TABLES from hms_dump_${ENV}) AS v2
CROSS JOIN
-- get count of all MANAGED tables
  (select count (DISTINCT TBL_NAME) as TOTAL_MANAGED_TABLES from hms_dump_${ENV} 
WHERE
      tbl_type = "MANAGED_TABLE"
  AND db_name != 'sys'
  AND db_name != 'information_schema') AS v3
CROSS JOIN
-- get count of all MANAGED tables with location in default warehouse (/apps/hive/warehouse)
  (select count (DISTINCT TBL_NAME) as TOTAL_MANAGED_TABLES_APPSHIVE from hms_dump_${ENV} 
WHERE
      tbl_type = "MANAGED_TABLE"
  AND db_name != 'sys'
  AND db_name != 'information_schema'
  AND instr(regexp_extract(tbl_location, 'hdfs://([^/]+)(.*)', 2), '/apps/hive/warehouse') = 1) AS v4
CROSS JOIN
-- get count of all MANAGED tables with location in default warehouse (/user/hive/warehouse) - CDH
  (select count (DISTINCT TBL_NAME) as TOTAL_MANAGED_TABLES_USERHIVE from hms_dump_${ENV} 
WHERE
      tbl_type = "MANAGED_TABLE"
  AND db_name != 'sys'
  AND db_name != 'information_schema'
  AND instr(regexp_extract(tbl_location, 'hdfs://([^/]+)(.*)', 2), '/user/hive/warehouse') = 1) AS v5
CROSS JOIN
-- get count of all EXTERNAL tables
  (select count (DISTINCT TBL_NAME) as TOTAL_EXTERNAL_TABLES from hms_dump_${ENV} 
WHERE
      tbl_type = "EXTERNAL_TABLE"
  AND db_name != 'sys'
  AND db_name != 'information_schema') AS v6
CROSS JOIN
-- get count of all VIRTUAL_VIEWS tables
  (select count (DISTINCT TBL_NAME) as TOTAL_VIRTUAL_VIEWS from hms_dump_${ENV} 
WHERE
      tbl_type = "VIRTUAL_VIEW"
      AND db_name != 'sys'
      AND db_name != 'information_schema') AS v7
;

-- print stats
select * from hive_stats_count_${ENV};