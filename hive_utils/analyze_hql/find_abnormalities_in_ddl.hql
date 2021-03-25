-- find ddl isues and specil details in ddl

USE ${DB};

select distinct
DB_NAME,DB_OWNER,TBL_NAME,TBL_OWNER
from hms_dump_prod
-- where instr(TBL_PARAM_VALUE,'CHALK')=1
where TBL_PARAM_VALUE like '%CHALK%'
limit 5;