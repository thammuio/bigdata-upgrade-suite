
CREATE DATABASE IF NOT EXISTS ${DB};

USE ${DB};

-- Create tables


-- managed tables
create table partiton_tbl_1 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/partiton_tbl_1';

create table partiton_tbl_2 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/partiton_tbl_2';

create table partiton_tbl_3 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/partiton_tbl_3';

create table partiton_tbl_4 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/partiton_tbl_4';

create table partiton_tbl_5 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/partiton_tbl_5';

create table partiton_tbl_6 (random_id bigint)
partitioned by (part bigint)
location '${MY_WAREHOUSE_DIR}/partiton_tbl_6';

create table partiton_tbl_7 (random_id bigint)
partitioned by (part bigint)
stored as orc;

create table partiton_tbl_8 (random_id bigint)
partitioned by (part bigint)
;

create table partiton_tbl_9 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MANAGED_WAREHOUSE_DIR}/${DB}.db/partiton_tbl_9';

create table partiton_tbl_10 (random_id bigint)
partitioned by (part bigint)
location '${MANAGED_WAREHOUSE_DIR}/${DB}.db/partiton_tbl_10';


-- external tables
create external table ext_partiton_tbl_1 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/ext_partiton_tbl_1'
TBLPROPERTIES ( 
    "external.table.purge" = "true");

create external table ext_partiton_tbl_2 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/ext_partiton_tbl_2'
TBLPROPERTIES ( 
    "external.table.purge" = "true");

create external table ext_partiton_tbl_3 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/ext_partiton_tbl_3'
TBLPROPERTIES ( 
    "external.table.purge" = "true");

create external table ext_partiton_tbl_4 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/ext_partiton_tbl_4'
TBLPROPERTIES ( 
    "external.table.purge" = "true");

create external table ext_partiton_tbl_5 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${MY_WAREHOUSE_DIR}/ext_partiton_tbl_5'
TBLPROPERTIES ( 
    "external.table.purge" = "true");

create external table ext_partiton_tbl_6 (random_id bigint)
partitioned by (part bigint)
location '${MY_WAREHOUSE_DIR}/ext_partiton_tbl_6'
TBLPROPERTIES ( 
    "external.table.purge" = "true");

create external table ext_partiton_tbl_7 (random_id bigint)
partitioned by (part bigint)
stored as orc
TBLPROPERTIES ( 
    "external.table.purge" = "true");

create external table ext_partiton_tbl_8 (random_id bigint)
partitioned by (part bigint)
TBLPROPERTIES ( 
    "external.table.purge" = "true");

create external table ext_partiton_tbl_9 (random_id bigint)
partitioned by (part bigint)
stored as orc
location '${EXTERNAL_WAREHOUSE_DIR}/${DB}.db/ext_partiton_tbl_9'
TBLPROPERTIES ( 
    "external.table.purge" = "true");

create external table ext_partiton_tbl_10 (random_id bigint)
partitioned by (part bigint)
location '${EXTERNAL_WAREHOUSE_DIR}/${DB}.db/ext_partiton_tbl_10'
TBLPROPERTIES ( 
    "external.table.purge" = "true");


