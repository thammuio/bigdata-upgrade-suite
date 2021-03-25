NOW=$(date +"%Y%m%d-%H%M")
mkdir -p /data/bigdata_upgrade/hive_jobs_output/$NOW
export OUTPUT_DIR=/data/bigdata_upgrade/hive_jobs_output/$NOW



${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/0_CreateDB.hql \
> $OUTPUT_DIR/0_CreateDB_F-$NOW.txt



sh features/0_1_CopyDataFiles.sh


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/1_RunInitialCreateInsert.hql \
> $OUTPUT_DIR/1_RunInitialCreateInsert-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/2_CreateManagedTable.hql \
> $OUTPUT_DIR/2_CreateManagedTable-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/3_CreateExternalTable.hql \
> $OUTPUT_DIR/3_CreateExternalTable-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/4_RunDropCreateInsert.hql \
> $OUTPUT_DIR/4_RunDropCreateInsert-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/5_CollectionDataTypes.hql \
> $OUTPUT_DIR/5_CollectionDataTypes-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/6_HiveBuiltInFunctions.hql \
> $OUTPUT_DIR/6_HiveBuiltInFunctions-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/7_Partitioning.hql \
> $OUTPUT_DIR/7_Partitioning-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/8_Bucketing.hql \
> $OUTPUT_DIR/8_Bucketing-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/9_MultiTableInsert.hql \
> $OUTPUT_DIR/9_MultiTableInsert-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/10_Windowing.hql \
> $OUTPUT_DIR/10_Windowing-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/11_RunningCustomPythonscript.hql \
> $OUTPUT_DIR/11_RunningCustomPythonscript-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/12_CustomUDFsJava.hql \
> $OUTPUT_DIR/12_CustomUDFsJava-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/13_AllSelectStatements.hql \
> $OUTPUT_DIR/13_AllSelectStatements-$NOW.txt




${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/0_CreateDB.hql \
> $OUTPUT_DIR/0_CreateDB_A-$NOW.txt



sh analysis/000_CopyJar.sh


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/0_CreateTables.hql \
> $OUTPUT_DIR/0_CreateTables-$NOW.txt


sh analysis/00_CopyData.sh


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/1_1_Retreive_Data.hql \
> $OUTPUT_DIR/1_1_Retreive_Data-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/2_1_Aggregating_Data.hql \
> $OUTPUT_DIR/2_1_Aggregating_Data-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/2_2_Aggregating_Data.hql \
> $OUTPUT_DIR/2_2_Aggregating_Data-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/2_3_Aggregating_Data.hql \
> $OUTPUT_DIR/2_3_Aggregating_Data-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/3_1_Filtering_Results.hql \
> $OUTPUT_DIR/3_1_Filtering_Results-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/3_2_Filtering_Results.hql \
> $OUTPUT_DIR/3_2_Filtering_Results-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/4_1_JoinMultipleTables.hql \
> $OUTPUT_DIR/4_1_JoinMultipleTables-$NOW.txt



${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/4_2_JoinMultipleTables.hql \
> $OUTPUT_DIR/4_2_JoinMultipleTables-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/4_3_JoinMultipleTables.hql \
> $OUTPUT_DIR/4_3_JoinMultipleTables-$NOW.txt



${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/1_1_Retreive_Data.hql \
> $OUTPUT_DIR/1_1_Retreive_Data-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/5_1_ManipulatingData.hql \
> $OUTPUT_DIR/5_1_ManipulatingData-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/5_2_ManipulatingData.hql \
> $OUTPUT_DIR/5_2_ManipulatingData-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/5_3_ManipulatingData.hql \
> $OUTPUT_DIR/5_3_ManipulatingData-$NOW.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/5_4_ManipulatingData.hql \
> $OUTPUT_DIR/5_4_ManipulatingData-$NOW.txt
