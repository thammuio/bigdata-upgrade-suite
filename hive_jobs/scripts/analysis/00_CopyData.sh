#!/bin/bash

# PRE_UPGRADE

if [ "$IS_UPGRADED" = false ] ; then
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/clients.csv $WAREHOUSE_DIR_BEFORE/$TARGET_DB_A.db/cogsleyservices_clients/
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-2009.csv $WAREHOUSE_DIR_BEFORE/$TARGET_DB_A.db/cogsleyservices_sales_all_years/2009
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-2010.csv $WAREHOUSE_DIR_BEFORE/$TARGET_DB_A.db/cogsleyservices_sales_all_years/2010
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-2011.csv $WAREHOUSE_DIR_BEFORE/$TARGET_DB_A.db/cogsleyservices_sales_all_years/2011
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-2012.csv $WAREHOUSE_DIR_BEFORE/$TARGET_DB_A.db/cogsleyservices_sales_all_years/2012
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-US-WithCommas.csv $WAREHOUSE_DIR_BEFORE/$TARGET_DB_A.db/cogsleyservices_sales
fi

if [ "$IS_UPGRADED" = true ] ; then
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/clients.csv $MANAGED_WAREHOUSE_DIR/$TARGET_DB_A.db/cogsleyservices_clients/
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-2009.csv $MANAGED_WAREHOUSE_DIR/$TARGET_DB_A.db/cogsleyservices_sales_all_years/2009
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-2010.csv $MANAGED_WAREHOUSE_DIR/$TARGET_DB_A.db/cogsleyservices_sales_all_years/2010
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-2011.csv $MANAGED_WAREHOUSE_DIR/$TARGET_DB_A.db/cogsleyservices_sales_all_years/2011
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-2012.csv $MANAGED_WAREHOUSE_DIR/$TARGET_DB_A.db/cogsleyservices_sales_all_years/2012
    hdfs dfs -put $BASE_DIR/bigdata-upgrade-helper/hive_jobs/data/cogsleyservices_sales/SalesData-US-WithCommas.csv $MANAGED_WAREHOUSE_DIR/$TARGET_DB_A.db/cogsleyservices_sales
fi