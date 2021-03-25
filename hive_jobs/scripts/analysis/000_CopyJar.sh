# Make sure you have UDF .jar built and avilable in that path for SerDe 
chmod 777 ${BASE_DIR}/bigdata-upgrade-helper/hive_jobs/functions/jar/csv-serde-1.1.2.jar
hdfs dfs -put ${BASE_DIR}/bigdata-upgrade-helper/hive_jobs/functions/jar/csv-serde-1.1.2.jar /tmp/
hdfs dfs -chmod 777 /tmp/csv-serde-1.1.2.jar
hdfs dfs -ls /tmp/csv-serde-1.1.2.jar