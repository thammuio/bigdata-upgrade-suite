USE ${DB};

SELECT DISTINCT
    db_name
  , tbl_name
  , tbl_type
FROM
    hms_dump_${ENV}
WHERE
      tbl_type = "MANAGED_TABLE"
  AND db_name != 'sys'
  AND db_name != 'information_schema';