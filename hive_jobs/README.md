# End-to-End Hive : HQL, Partitioning, Bucketing, UDFs, Windowing, Optimization, Map Joins, Indexes, etc
--------------

## Create Database
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/0_CreateDB.hql \
> $OUTPUT_DIR/0_CreateDB_F-$NOW.txt
```

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR}
```

```
use ${DB};

show tables;

!quit
```

## Copy Data, Scriots, UDFs, and other Files

```
sh features/0_1_CopyDataFiles.sh
```

## Run Create Table, Insert
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/1_RunInitialCreateInsert.hql \
> $OUTPUT_DIR/1_RunInitialCreateInsert-$NOW.txt
```

## Create Managed Table
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/2_CreateManagedTable.hql \
> $OUTPUT_DIR/2_CreateManagedTable-$NOW.txt
```

## Create External Table
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/3_CreateExternalTable.hql \
> $OUTPUT_DIR/3_CreateExternalTable-$NOW.txt
```

## Run Drop Table, Create, Insert
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/4_RunDropCreateInsert.hql \
> $OUTPUT_DIR/4_RunDropCreateInsert-$NOW.txt
```

## Collection DataTpes
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/5_CollectionDataTypes.hql \
> $OUTPUT_DIR/5_CollectionDataTypes-$NOW.txt
```

## Hive BuiltIn Functions
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/6_HiveBuiltInFunctions.hql \
> $OUTPUT_DIR/6_HiveBuiltInFunctions-$NOW.txt
```

## Partitioning
<!-- This also Tests Renaming a Table -->
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/7_Partitioning.hql \
> $OUTPUT_DIR/7_Partitioning-$NOW.txt
```

## Bucketing
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/8_Bucketing.hql \
> $OUTPUT_DIR/8_Bucketing-$NOW.txt
```

## Multi-Table Insert
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/9_MultiTableInsert.hql \
> $OUTPUT_DIR/9_MultiTableInsert-$NOW.txt
```

## Windowing Functions
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/10_Windowing.hql \
> $OUTPUT_DIR/10_Windowing-$NOW.txt
```

## Running Custom Python script

*This might not work as there is a restriction on Hive and is expected*
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/11_RunningCustomPythonscript.hql \
> $OUTPUT_DIR/11_RunningCustomPythonscript-$NOW.txt
```

## Custom UDFs in Java

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/12_CustomUDFsJava.hql \
> $OUTPUT_DIR/12_CustomUDFsJava-$NOW.txt
```


## Run Select on all Tables
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/13_AllSelectStatements.hql \
> $OUTPUT_DIR/13_AllSelectStatements-$NOW.txt
```


## Cleanup
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f features/00_Cleanup.hql \
> $OUTPUT_DIR/00_Cleanup_F-$NOW.txt
```

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_F} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR}
```

```
use ${DB};

show tables;
```

# Hive Analysis: Aggregation, Filtering, Joins, Functions, etc
----------------

## Create Database
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/0_CreateDB.hql \
> $OUTPUT_DIR/0_CreateDB_A-$NOW.txt
```

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR}
```

```
use ${DB};

show tables;

!quit
```

## DDL

<!--
Not Needed as we are using org.apache.hadoop.hive.serde2.OpenCSVSerde
```
sh analysis/000_CopyJar.sh
```
-->

Ceating Tables in Hive,  Partitioning Tables

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/0_CreateTables.hql \
> $OUTPUT_DIR/0_CreateTables-$NOW.txt
```

# Load Data in to Tables

```
sh analysis/00_CopyData.sh
```

## Retrieving Data

Restrieving data with SELECT

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/1_1_Retreive_Data.hql \
> $OUTPUT_DIR/1_1_Retreive_Data-$NOW.txt
```

## Aggregating Data

Simple Aggregations
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/2_1_Aggregating_Data.hql \
> $OUTPUT_DIR/2_1_Aggregating_Data-$NOW.txt
```

Grouping Sets
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/2_2_Aggregating_Data.hql \
> $OUTPUT_DIR/2_2_Aggregating_Data-$NOW.txt
```

Using CUBE and ROLLUP
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/2_3_Aggregating_Data.hql \
> $OUTPUT_DIR/2_3_Aggregating_Data-$NOW.txt
```


## Filtering Reults

Simple filter with WHERE
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/3_1_Filtering_Results.hql \
> $OUTPUT_DIR/3_1_Filtering_Results-$NOW.txt
```

Filtering aggregates with HAVING
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/3_2_Filtering_Results.hql \
> $OUTPUT_DIR/3_2_Filtering_Results-$NOW.txt
```

## Joining Tables 

Comibining tables with JOIN
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/4_1_JoinMultipleTables.hql \
> $OUTPUT_DIR/4_1_JoinMultipleTables-$NOW.txt

```

Use SEMI JOIN
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/4_2_JoinMultipleTables.hql \
> $OUTPUT_DIR/4_2_JoinMultipleTables-$NOW.txt
```

Joining multiple tables together
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/4_3_JoinMultipleTables.hql \
> $OUTPUT_DIR/4_3_JoinMultipleTables-$NOW.txt

```

## Manipulating Data

Data Manipulating Functions
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/1_1_Retreive_Data.hql \
> $OUTPUT_DIR/1_1_Retreive_Data-$NOW.txt
```

String Functions
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/5_1_ManipulatingData.hql \
> $OUTPUT_DIR/5_1_ManipulatingData-$NOW.txt
```

Math Functions
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/5_2_ManipulatingData.hql \
> $OUTPUT_DIR/5_2_ManipulatingData-$NOW.txt
```

Date Functions
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/5_3_ManipulatingData.hql \
> $OUTPUT_DIR/5_3_ManipulatingData-$NOW.txt
```

Conditonal Functions
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/5_4_ManipulatingData.hql \
> $OUTPUT_DIR/5_4_ManipulatingData-$NOW.txt
```

## Cleanup
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR} -f analysis/00_Cleanup.hql \
> $OUTPUT_DIR/00_Cleanup_A-$NOW.txt
```

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB_A} ${HIVE_OUTPUT_OPTS} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} --hivevar BASE_DIR=${BASE_DIR}
```

```
use ${DB};

show tables;
```

# APPENDIX

## Set Environment variables for these process - before running sql
Export Variables from [vaiables](variables/set_variables_env) before running these jobs.

```
source $PWD/hive_jobs/variables/set_variables_env
```

## Hive UDFs
[Hive UDFs Detailed Documentation](functions/suri-hive-udf/README.md)

## Extract Code Snippets from README.md
sed -n '/```/,/```/p' README.md