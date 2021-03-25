val targetDB=sys.env("TARGET_DB")
val numberofFiles=10000
// check alloed hive.exec.max.dynamic.partitions for below prop
val min_num_partitions=10000
val max_num_partitions=14900

val tmpDF=spark.range(numberofFiles).toDF("random_id").withColumn("part", ($"random_id"% max_num_partitions)).selectExpr("random_id", "case when part > "+min_num_partitions+" then part else part+"+min_num_partitions+" end as part").selectExpr("random_id", "case when part > "+max_num_partitions+ " then "+max_num_partitions+" else part end as part")

spark.sql("set hive.exec.dynamic.partition.mode=nonstrict")

tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_1")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_2")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_3")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_4")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_5")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_6")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_7")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_8")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_9")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.partiton_tbl_10")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_1")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_2")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_3")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_4")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_5")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_6")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_7")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_8")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_9")
tmpDF.repartition(max_num_partitions-min_num_partitions).write.mode("Append").insertInto("bda_partitions.ext_partiton_tbl_10")