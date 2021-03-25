USE ${DB};

CREATE External TABLE Campus_Housing_external(StudentID INT, 
DormitoryName VARCHAR(50), AptNumber INT) 
location '${EXTERNAL_WAREHOUSE_DIR}/${DB}.db/campus_housing_external';


-- load data local inpath '${BASE_DIR}/bigdata-upgrade-helper/hive_jobs/data/campus_housing.txt'
-- overwrite into table Campus_Housing_external;

load data inpath '/tmp/campus_housing.txt'
overwrite into table Campus_Housing_external;


alter table Campus_Housing_external
set SERDEPROPERTIES ('field.delim'=',');

select * from Campus_Housing_external;