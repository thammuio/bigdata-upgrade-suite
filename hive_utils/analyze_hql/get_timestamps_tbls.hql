USE ${DB};

SELECT DISTINCT
    tbl_type
  , db_name
  , tbl_name
  , from_unixtime(cast(tbl_create_time as int))
FROM
    hms_dump_${ENV}
WHERE
      db_name != 'sys'
  AND db_name != 'information_schema';
