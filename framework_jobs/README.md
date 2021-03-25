# Hadoop (HDFS, YARN), HBase/Phoenix, Spark2 Jobs

## Hadoop (HDFS, YARN)

## HBase/Phoenix

Copy Data
```
sh hbase_phoenix/0_copy_data.sh
```

### HBase

### Phoenix



./psql.py <your_zookeeper_quorum> hbase_phoenix/phoenix_us_population.sql data/us_population.csv hbase_phoenix/phoenix_us_population_queries.sql



## Spark2

## Hive

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar MANAGED_WAREHOUSE_DIR=${MANAGED_WAREHOUSE_DIR} --hivevar MY_WAREHOUSE_DIR=${MY_WAREHOUSE_DIR} -f service_module/hive/partitions/create_db_tables.hql
```

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar MANAGED_WAREHOUSE_DIR=${MANAGED_WAREHOUSE_DIR} --hivevar MY_WAREHOUSE_DIR=${MY_WAREHOUSE_DIR} -f service_module/hive/partitions/cleanup.hql
```