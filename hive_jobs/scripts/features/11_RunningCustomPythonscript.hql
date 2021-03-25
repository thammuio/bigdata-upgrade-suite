USE ${DB};

-- add file ${BASE_DIR}/bigdata-upgrade-helper/hive_jobs/functions/function.py;
add file hdfs:///tmp/function.py;

SELECT TRANSFORM(firstname,lastname) USING 'python function.py' as isLonger from employees;