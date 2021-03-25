CREATE DATABASE IF NOT EXISTS ${DB};

USE ${DB};

drop table ext_partiton_tbl_1;
drop table ext_partiton_tbl_2;
drop table ext_partiton_tbl_3;
drop table ext_partiton_tbl_4;
drop table ext_partiton_tbl_5;
drop table ext_partiton_tbl_6;
drop table ext_partiton_tbl_7;
drop table ext_partiton_tbl_8;
drop table ext_partiton_tbl_9;
drop table ext_partiton_tbl_10;

drop table partiton_tbl_1;
drop table partiton_tbl_2;
drop table partiton_tbl_3;
drop table partiton_tbl_4;
drop table partiton_tbl_5;
drop table partiton_tbl_6;
drop table partiton_tbl_7;
drop table partiton_tbl_8;
drop table partiton_tbl_9;
drop table partiton_tbl_10;

DROP DATABASE ${DB};