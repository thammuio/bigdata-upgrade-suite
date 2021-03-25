-- Get the List of DBs and Tables for Mising Dirs from missing_table_dirs.hql


USE ${DB};

SELECT DISTINCT
    hms_dump_${ENV}.db_name as db
    , hms_dump_${ENV}.tbl_name as db_table
    , missing_dirs_${ENV}.hdfs_loc AS missing_hdfs_location
FROM
    hms_dump_${ENV}, missing_dirs_${ENV}
WHERE missing_dirs_${ENV}.hdfs_loc = regexp_extract(hms_dump_${ENV}.tbl_location, 'hdfs://([^/]+)(.*)', 2)
;

-- SELECT DISTINCT
--     hms_dump_${ENV}.db_name as db
--     , hms_dump_${ENV}.tbl_name as db_table
--     , missing_dirs_${ENV}.hdfs_loc AS missing_hdfs_location
-- FROM
--     hms_dump_${ENV}, missing_dirs_${ENV}
-- WHERE regexp_extract(hms_dump_${ENV}.tbl_location, 'hdfs://([^/]+)(.*)', 2) = missing_dirs_${ENV}.hdfs_loc
-- ;