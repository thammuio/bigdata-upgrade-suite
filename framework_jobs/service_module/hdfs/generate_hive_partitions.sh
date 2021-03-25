# Generate Hive Partitions

create external table bda_partitions.partiton_tbl_1 (id bigint) partitioned by (part bigint)stored as orc location '/smallfiles/hive_tables/bda_partitions/partiton_tbl_1';


export SPARK_MAJOR_VERSION=2; spark-shell

val numberofFiles=10000
val partitions=1000
val tmpDF=spark.range(numberofFiles).toDF("id").withColumn("part", $"id"% partitions)
spark.sql("set hive.exec.dynamic.partition.mode=nonstrict")
tmpDF.repartition(partitions).write.insertInto("bda_partitions.partiton_tbl_1")




<!-- Note – You might see following error on cluster, ‘cuse cluster have restriction to not write more than 1000 files – 
Caused by: org.apache.hadoop.hive.ql.metadata.HiveException: Number of dynamic partitions created is 10000, which is more than 1000. To solve this try to set hive.exec.max.dynamic.partitions to at least 10000. -->
