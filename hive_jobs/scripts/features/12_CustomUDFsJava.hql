USE ${DB};

CREATE TABLE stock_returns
(
stock_name VARCHAR(100),
trading_date DATE,
opening_value DECIMAL(10,2),
closing_value DECIMAL(10,2),
company_name string,
my_date_time TIMESTAMP
);

insert into table stock_returns values
('TATA','2015-01-13',24.54,23.67,'Tata Motors Limited','2011-07-21 12:33:11'),
('FORD','2015-01-13',52.54,47.67,'Ford Motor Company','2010-07-21 12:50:11'),
('GM','2015-01-13',100.54,101.67,'General Motors Corporation','2011-07-21 12:55:11'),
('Volksvogen','2015-01-13',67.54,69.67,'Volkswagen Group','2014-07-21 07:55:11'),
('TATA','2015-01-14',26.54,28.67,'Tata Motors Limited','2011-07-21 10:55:11'),
('FORD','2015-01-14',44.54,47.67,'Ford Motor Company','2011-05-21 12:55:11'),
('GM','2015-01-14',99.54,100.67,'General Motors Corporation','2011-01-21 12:55:11'),
('Volksvogen','2015-01-14',66.54,68.67,'Volkswagen Group','2011-07-21 01:55:11'),
('TATA','2015-01-15',23.54,24.67,'Tata Motors Limited','2011-07-21 12:55:11'),
('FORD','2015-01-15',48.54,46.67,'Ford Motor Company','2011-05-21 02:55:11'),
('GM','2015-01-15',98.47,99.67,'General Motors Corporation','2011-07-21 12:55:11'),
('Volksvogen','2015-01-15',69.54,68.67,'Volkswagen Group','2018-07-21 07:55:11'),
('NISSAN','2015-01-15',NULL,NULL,'Nissan Motor Company','2006-09-21 09:55:11');


-- Registering the UDFs
-- add jar ${BASE_DIR}/bigdata-upgrade-helper/hive_jobs/functions/myUDF.jar;
add jar hdfs:///tmp/suri-hive-udf-0.2-SNAPSHOT.jar;

CREATE TEMPORARY FUNCTION custom_nvl AS 'com.suri.platform.hive.udf.GenericUDFNVL';
CREATE TEMPORARY FUNCTION custom_decode AS 'com.suri.platform.hive.udf.GenericUDFDecode';
CREATE TEMPORARY FUNCTION custom_nvl2 AS 'com.suri.platform.hive.udf.GenericUDFNVL2';
CREATE TEMPORARY FUNCTION custom_str_to_date AS 'com.suri.platform.hive.udf.UDFStrToDate';
CREATE TEMPORARY FUNCTION custom_date_format AS 'com.suri.platform.hive.udf.UDFDateFormat';
CREATE TEMPORARY FUNCTION custom_to_char AS 'com.suri.platform.hive.udf.UDFToChar';
CREATE TEMPORARY FUNCTION custom_instr4 AS 'com.suri.platform.hive.udf.GenericUDFInstr';
CREATE TEMPORARY FUNCTION custom_chr AS 'com.suri.platform.hive.udf.UDFChr';
CREATE TEMPORARY FUNCTION custom_last_day AS 'com.suri.platform.hive.udf.UDFLastDay';
CREATE TEMPORARY FUNCTION custom_greatest AS 'com.suri.platform.hive.udf.GenericUDFGreatest';
CREATE TEMPORARY FUNCTION custom_to_number AS 'com.suri.platform.hive.udf.GenericUDFToNumber';
CREATE TEMPORARY FUNCTION custom_trunc AS 'com.suri.platform.hive.udf.GenericUDFTrunc';
CREATE TEMPORARY FUNCTION custom_rank AS 'com.suri.platform.hive.udf.GenericUDFRank';
CREATE TEMPORARY FUNCTION custom_row_number AS 'com.suri.platform.hive.udf.GenericUDFRowNumber';
CREATE TEMPORARY FUNCTION custom_sysdate AS 'com.suri.platform.hive.udf.UDFSysDate';
CREATE TEMPORARY FUNCTION custom_populate AS 'com.suri.platform.hive.udf.GenericUDTFPopulate';
CREATE TEMPORARY FUNCTION custom_dedup AS 'com.suri.platform.hive.udf.GenericUDAFDedup';
CREATE TEMPORARY FUNCTION custom_lnnvl AS 'com.suri.platform.hive.udf.GenericUDFLnnvl';
CREATE TEMPORARY FUNCTION custom_substr AS 'com.suri.platform.hive.udf.UDFSubstrForOracle';

-- DESCRIBE FUNCTION EXTENDED custom_nvl2;
-- SHOW FUNCTIONS;
-- RELOAD;

SELECT stock_name,custom_nvl(closing_value, 'NOT REPORTED') FROM stock_returns;

SELECT stock_name,custom_decode(stock_name, "Volksvogen", "MATCH") FROM stock_returns;

SELECT stock_name,custom_nvl2(closing_value, 'REPORTED', 'NOT REPORTED') FROM stock_returns;

SELECT stock_name,custom_str_to_date(trading_date, 'yyyy-MM-dd') FROM stock_returns;

SELECT stock_name,custom_str_to_date('2011/07/21 12:55:11', 'yyyy/MM/dd HH:mm:ss') FROM stock_returns;

SELECT stock_name,custom_to_char(trading_date,'yyyyMMdd') FROM stock_returns;

SELECT stock_name,custom_date_format(my_date_time,'yyyyMMdd') FRom stock_returns;

SELECT company_name,custom_instr4(company_name, 'vogen') FROM stock_returns;

SELECT stock_name,custom_chr(116) FROM stock_returns;

SELECT stock_name,custom_chr(84) FROM stock_returns;

SELECT stock_name,custom_last_day(my_date_time) FROM stock_returns;

SELECT stock_name,custom_greatest(opening_value, closing_value) FROM stock_returns;

SELECT stock_name,custom_to_number('1210') FROM stock_returns;

SELECT company_name,custom_substr(company_name, 5) FROM stock_returns;

SELECT company_name,custom_substr(company_name, -5) FROM stock_returns;

SELECT company_name,custom_substr(company_name, 5, 1) FROM stock_returns;

SELECT stock_name,custom_trunc('2011-08-02 01:01:01') FROM stock_returns;

SELECT stock_name,custom_sysdate() FROM stock_returns;

SELECT stock_name,custom_sysdate('yyyyMMdd') FROM stock_returns;

SELECT stock_name,custom_sysdate('yyyyMMdd',3) FROM stock_returns;

