# Teragen

# 40000000/1000/1000 = 4GB
# sh /data/bigdata_upgrade/teragen_Upgrade.sh 400000
NOW=$(date +"%Y%m%d-%H%M")
mkdir -p /data/bigdata_upgrade/benchmarks-teragen-$NOW
export OUTPUT_DIR=/data/bigdata_upgrade/benchmarks-teragen-$NOW

hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples.jar teragen -Dmapreduce.job.queuename=myq -Dmapred.map.tasks=200 $1 /benchmarks/teragen_$1 >> $OUTPUT_DIR/teragen_$1 2>&1
hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples.jar terasort -Dmapreduce.job.queuename=myq -Dmapred.reduce.tasks=100 /benchmarks/teragen_$1 /benchmarks/terasort_$1 >> $OUTPUT_DIR/terasort_$1 2>&1
hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples.jar teravalidate -Dmapreduce.job.queuename=myq -Dmapred.reduce.tasks=50 /benchmarks/terasort_$1 /benchmarks/teravalidate_$1 >> $OUTPUT_DIR/validate_$1 2>&1


hdfs dfs -rm -r -skipTrash /benchmarks/terasort_$1
hdfs dfs -rm -r -skipTrash /benchmarks/teragen_$1
hdfs dfs -rm -r -skipTrash /benchmarks/teravalidate_$1

# TestDFSIO
# sh testDFSIO_Upgrade.sh 3 1000 benchmarks
NOW=$(date +"%Y%m%d-%H%M")
mkdir -p /data/bigdata_upgrade/benchmarks-$NOW
export OUTPUT_DIR=/data/bigdata_upgrade/benchmarks-$NOW
## HDFS Benchmarking with TestDFSIO
#Write Test
hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient-tests.jar TestDFSIO -Dmapreduce.job.queuename=myq -Dmapred.output.compress=false -write -nrFiles $1 -size $2 >> $OUTPUT_DIR/write_$1_files_$2_MB 2>&1 

#Read Test
hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient-tests.jar TestDFSIO -Dmapreduce.job.queuename=myq -Dmapred.output.compress=false -read -nrFiles $1 -size $2 >> $OUTPUT_DIR/read_$1_files_$2_MB 2>&1 

#Cleanup
hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient-tests.jar TestDFSIO -Dmapreduce.job.queuename=myq -Dmapred.output.compress=false -clean >> $OUTPUT_DIR/cleanup_$1_file_$2_MB 2>&1