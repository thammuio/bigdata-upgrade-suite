
export TARGET_DB=bda_partitions;
export SPARK_MAJOR_VERSION=2;
NOW=$(date +"%Y%m%d-%H%M")
HMS=hdpserveredga0001.hostname.com


nohup \
cat generateDataInsert.scala | spark-shell --conf "spark.hadoop.hive.metastore.uris=thrift://$HMS:9083" \
--master yarn \
--queue myq \
--driver-memory 8g \
--executor-memory 16g --num-executors 10 --executor-cores 3 \
>> generate_hive_data-$NOW.log 2>&1 &

# spark-shell -i file.scala
# :load PATH_TO_FILE

# cat generateDataInsert.scala | sed 's/bda_partitions/new_db_partition/g' | spark-shell --master yarn  
