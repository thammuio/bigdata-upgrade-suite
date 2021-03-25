--     When the location of the partition isn't based at the root of the table location, many assumptions
--     are no longer valid.
--
--     This script will help understand the impact.

USE ${DB};

WITH compliance AS (
            SELECT
                db_name
              , tbl_name
              , tbl_location
              , part_location
              , CASE WHEN instr(part_location, tbl_location) = 1 THEN "IN" ELSE "OUT" END AS part_compliance
            FROM
                hms_dump_${ENV}
            WHERE
                part_name IS NOT NULL
            )
SELECT DISTINCT
    db_name
  , tbl_name
  , tbl_location
  , part_location
  , part_compliance
FROM
    compliance
WHERE
    compliance.part_compliance = "OUT";