#!/bin/bash

chmod 777 /data/bigdata_upgrade/bigdata-upgrade-helper/hive_jobs/data/campus_housing.txt

hdfs dfs -rm /tmp/function.py
chmod 777 $BASE_DIR/bigdata-upgrade-helper/hive_jobs/functions/function.py
hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/functions/function.py /tmp/
hdfs dfs -chmod 777 /tmp/function.py
hdfs dfs -ls /tmp/function.py

# Make sure you have UDF .jar built and avilable in that path 
hdfs dfs -put ${BASE_DIR}/bigdata-upgrade-helper/hive_jobs/functions/jar/suri-hive-udf-0.2-SNAPSHOT.jar /tmp/
hdfs dfs -chmod 777 /tmp/suri-hive-udf-0.2-SNAPSHOT.jar
hdfs dfs -ls /tmp/suri-hive-udf-0.2-SNAPSHOT.jar

# Copy Data
hdfs dfs -rm /tmp/campus_housing.txt
hdfs dfs -put ${BASE_DIR}/bigdata-upgrade-helper/hive_jobs/data/campus_housing.txt /tmp/
hdfs dfs -chmod 777 /tmp/campus_housing.txt