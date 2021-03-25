# Spark submit example in local mode
spark-submit --class org.apache.spark.examples.SparkPi --driver-memory 512m --executor-memory 512m --executor-cores 1 $SPARK_HOME/lib/spark-examples*.jar 10
 
# Spark submit example in client mode
spark-submit --class org.apache.spark.examples.SparkPi --master yarn-client --num-executors 3 --driver-memory 512m --executor-memory 512m --executor-cores 1 $SPARK_HOME/lib/spark-examples*.jar 10
 
# Spark submit example in cluster mode
spark-submit --class org.apache.spark.examples.SparkPi --master yarn-cluster --num-executors 3 --driver-memory 512m --executor-memory 512m --executor-cores 1 $SPARK_HOME/lib/spark-examples*.jar 10