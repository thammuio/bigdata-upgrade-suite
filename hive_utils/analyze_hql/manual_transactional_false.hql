-- Remove transactional=false from Table Properties
-- In CDH 5.x it is possible to create tables with having the property transactional=false set. While this is a no-op setting, if any of your Hive tables explicitly set this, the upgrade process fails.

-- You must remove 'transactional'='false' from any tables you want to upgrade from CDH 5.x to CDP. 

-- Alter the table as follows:
-- ALTER TABLE my_table UNSET TBLPROPERTIES ('transactional'); 

USE ${DB};

SELECT DISTINCT
    DB_NAME
    , TBL_NAME
    , PART_NAME
    , CASE
        WHEN PART_NAME IS NULL
            THEN regexp_extract(tbl_location, 'hdfs://([^/]+)(.*)', 2)
        WHEN PART_NAME IS NOT NULL
            THEN regexp_extract(part_location, 'hdfs://([^/]+)(.*)', 2)
    END AS LOCATION
FROM
    HMS_DUMP_${ENV}
WHERE
        TBL_PARAM_KEY = 'transactional'
    AND TBL_PARAM_VALUE = 'false'
;

