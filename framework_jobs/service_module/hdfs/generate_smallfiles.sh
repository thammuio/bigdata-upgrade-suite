# Generate Small Files

## Open spark-shell - HDP - SDL - change user name in tmp dir accordingly
export SPARK_MAJOR_VERSION=2

spark-shell --num-executors 100 --master yarn --queue a_adhoc --driver-memory 8g --executor-memory 10g --conf "spark.driver.extraJavaOptions=-Djava.io.tmpdir=/home/p2709241/tmp" --conf "spark.executor.extraJavaOptions=-Djava.io.tmpdir=/home/p2709241/tmp" --conf "spark.driver.maxResultSize=4g"

## Open spark-shell - CDH - SMDH
spark2-shell --num-executors 100 --master yarn --queue mob --driver-memory 8g --executor-memory 10g --conf "spark.driver.extraJavaOptions=-Djava.io.tmpdir=/home/p2709241/tmp" --conf "spark.executor.extraJavaOptions=-Djava.io.tmpdir=/home/p2709241/tmp" --conf "spark.driver.maxResultSize=4g"


### Execute this in Spark shell to generate small files - 200 times * 1 Million files in each run

val count=1000000
val tmpDF=spark.range(count).toDF("id")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_1")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_2")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_3")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_4")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_5")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_6")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_7")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_8")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_9")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_10")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_11")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_12")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_13")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_14")

tmpDF.repartition(count).write.save("/smallfiles/dataset_1M_15")

.
.
.

tmpDF.repartition(count).write.save(""/smallfiles/dataset_1M_199")

tmpDF.repartition(count).write.save(""/smallfiles/dataset_1M_200")


:quit / ctrl + D

