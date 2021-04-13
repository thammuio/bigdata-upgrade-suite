# Hive Utils - Upgrade Planning
---


Upgrading from Hive 1/2 to Hive 3 requires several metastore AND data changes to be successful.

This process and the associated scripts are meant to be used as a 'pre-upgrade' planning toolkit to make the upgrade smoother.

These scripts don't make any direct changes to hive, rather they are intended to educate and inform you of areas that need attention.  After which, it is up to you to make the adjustments manually.

We'll use a combination of Hive SQL and an interactive HDFS client [Hadoop CLI](https://github.com/dstreev/hadoop-cli) to combine information from an extract of the Metastore DB and the contents of HDFS.

Credits to [hdp3_upgrade_utils](https://github.com/dstreev/hdp3_upgrade_utils) which we used as our base.

## NOTE

1. If you do not have ACID Enabled in HDP / CDH cluster - We don't need to do anything for ACID or Table Compactions.
2. Only the managed tables will be migrated to /warehouse/tablespace/managed/hive from previous /apps/hive/warehouse

## WARNINGS

1. Some of the processes covered here will examine the contents of HDFS via the Namenode.  The results could spike RPC Queues on clusters that aren't optimized.  I suggest monitoring NN RPC pressure when running large amounts of data through the Hadoop Cli.
 
## Don't skip ME!!

1. Before the upgrade starts, make a snapshot of all your affect Hive Managed table locations.  The upgrade will convert and move things.  This is a last resort fallback process to get to your raw 'before' upgrade data.
    - Take this snapshot AFTER the 'MAJOR' compactions have completed.

## Workflow

![](workflow\high_level_workflow.png)

## Calling Hive Via Beeline

We use Hive throughout this process.  The process has been validated against Hive3, using Beeline against LLAP.  To use against LLAP in HDP 2.6, you'll need to build a 'beeline' wrapper to connect automatically.  The output of 'beeline' will be a little different then the output of 'hive cli'.  So I recommend using 'beeline' in HDP 2.6 for this process since the pipeline has particular dependencies.

---

# The Initial Process

## Setup Hadoop CLI
An interactive/scripted 'hdfs' client that can be scripted to reduce the time it takes to cycle through 'hdfs' commands.

```
wget https://github.com/dstreev/hadoop-cli/releases/download/2.2.1.3-SNAPSHOT/hadoop.cli-2.2.1.3-SNAPSHOT-dist.tar.gz
tar -xvf hadoop.cli-2.2.1.3-SNAPSHOT-dist.tar.gz
cd hadoop-cli/
chmod +x hadoopcli JCECheck setup.sh
export JAVA_HOME=/usr/jdk64/latest
export PATH=$PATH:$JAVA_HOME/bin
<!-- export JAVA_HOME=/usr/java/jdk1.8.0_161
export PATH=$PATH:$JAVA_HOME/bin -->
./setup.sh
cd 
hadoopcli
```

```
export JAVA_HOME=/usr/jdk64/latest
export PATH=$PATH:$JAVA_HOME/bin
hadoopcli
```


## Set Environment variables for these process - before running sql

```
source $PWD/hive_utils/variables/set_variables_env
```
### Hive - Beeline

- HDP 3 - `export HIVE_ALIAS="beeline -u \"jdbc:hive2://nceunhpqata0001.hostname.com:2181,nceunhpqata0002.hostname.com:2181,nceunhpqata0006.hostname.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2\"  --hiveconf tez.queue.name=a_adhoc"
`
- HDP 2.6 - `export HIVE_ALIAS="beeline -u \"jdbc:hive2://nceunhpqata0001.hostname.com:2181,nceunhpqata0002.hostname.com:2181,nceunhpqata0006.hostname.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2\"  --hiveconf tez.queue.name=a_adhoc"
`
NOTE: I attempted `beeline` in 2.6.5, but ran into variable passing issues with hivevar.

### Variables used in the scripts

Set the following environment variable to assist with these scripts

Use a 'new' database to avoid issues with location overrides.

The 'DUMP_ENV' var is intended to be something like: 'qat', 'dev', 'uat', 'dr', 'prod'.  This way you can run several tests and discoveries in a lower environment by extracting data from upper environments.

```
export TARGET_DB=<target_db>
export DUMP_ENV=<dump_env>
export OUTPUT_DIR=<base_output_dir>
export EXTERNAL_WAREHOUSE_DIR=<ext_wh_dir>
# Set this when using beeline
export HIVE_OUTPUT_OPTS="--showHeader=false --outputformat=tsv2"
# Set this when using hive
export HIVE_OUTPUT_OPTS=
# Support direct connection to Namenode via /etc/hadoop/conf configs
export HC="hadoopcli"
# Support webhdfs connection to oi

# For Example:
export TARGET_DB=mycompany
export DUMP_ENV=dev
export EXTERNAL_WAREHOUSE_DIR=/apps/hive/warehouse
export OUTPUT_DIR=/tmp

```

## Collect the Metadata

### Method 1


```
export LD_LIBRARY_PATH=/apps/oracle/product/12.1.0.2/client:$LD_LIBRARY_PATH
export PATH=$PATH:/apps/oracle/product/12.1.0.2/client
export ORACLE_HOME=/apps/oracle/product/12.1.0.2/client
```

Run below in orcale_client shell and copy the '\002' delimited output data to $EXTERNAL_WAREHOUSE_DIR/$TARGET_DB.db/hms_dump_$ENV dir

SELECT D.NAME as DB_NAME , D.DB_LOCATION_URI as DB_DEFAULT_LOC , D.OWNER_NAME as DB_OWNER , T.TBL_ID as TBL_ID , T.TBL_NAME as TBL_NAME , T.OWNER as TBL_OWNER , T.TBL_TYPE as TBL_TYPE , S.INPUT_FORMAT as TBL_INPUT_FORMAT , S.OUTPUT_FORMAT as TBL_OUTPUT_FORMAT , S.LOCATION as TBL_LOCATION , S.NUM_BUCKETS as TBL_NUM_BUCKETS , SER.SLIB as TBL_SERDE_SLIB , PARAMS.PARAM_KEY as TBL_PARAM_KEY , PARAMS.PARAM_VALUE as TBL_PARAM_VALUE , P.PART_ID as PART_ID , P.PART_NAME as PART_NAME , PS.INPUT_FORMAT as PART_INPUT_FORMAT , PS.OUTPUT_FORMAT as PART_OUTPUT_FORMAT, PS.LOCATION as PART_LOCATION , PS.NUM_BUCKETS as PART_NUM_BUCKETS , PSER.SLIB as PART_SERDE_SLIB FROM dbs D INNER JOIN tbls T ON D.DB_ID = T.DB_ID LEFT OUTER JOIN sds S ON T.SD_ID = S.SD_ID LEFT OUTER JOIN serdes SER ON S.SERDE_ID = SER.SERDE_ID LEFT OUTER JOIN table_params PARAMS ON T.TBL_ID = PARAMS.TBL_ID LEFT OUTER JOIN partitions P ON T.TBL_ID = P.TBL_ID LEFT OUTER JOIN sds PS ON P.SD_ID = PS.SD_ID LEFT OUTER JOIN serdes PSER ON PS.SERDE_ID = PSER.SERDE_ID WHERE (1 = 1)


### Method 2

Run below in SQLDeveloper and copy the '\002' delimited output data to $EXTERNAL_WAREHOUSE_DIR/$TARGET_DB.db/hms_dump_$ENV dir

SELECT D.NAME as DB_NAME , D.DB_LOCATION_URI as DB_DEFAULT_LOC , D.OWNER_NAME as DB_OWNER , T.TBL_ID as TBL_ID , T.TBL_NAME as TBL_NAME , T.OWNER as TBL_OWNER , T.TBL_TYPE as TBL_TYPE , S.INPUT_FORMAT as TBL_INPUT_FORMAT , S.OUTPUT_FORMAT as TBL_OUTPUT_FORMAT , S.LOCATION as TBL_LOCATION , S.NUM_BUCKETS as TBL_NUM_BUCKETS , SER.SLIB as TBL_SERDE_SLIB , PARAMS.PARAM_KEY as TBL_PARAM_KEY , PARAMS.PARAM_VALUE as TBL_PARAM_VALUE , P.PART_ID as PART_ID , P.PART_NAME as PART_NAME , PS.INPUT_FORMAT as PART_INPUT_FORMAT , PS.OUTPUT_FORMAT as PART_OUTPUT_FORMAT, PS.LOCATION as PART_LOCATION , PS.NUM_BUCKETS as PART_NUM_BUCKETS , PSER.SLIB as PART_SERDE_SLIB FROM dbs D INNER JOIN tbls T ON D.DB_ID = T.DB_ID LEFT OUTER JOIN sds S ON T.SD_ID = S.SD_ID LEFT OUTER JOIN serdes SER ON S.SERDE_ID = SER.SERDE_ID LEFT OUTER JOIN table_params PARAMS ON T.TBL_ID = PARAMS.TBL_ID LEFT OUTER JOIN partitions P ON T.TBL_ID = P.TBL_ID LEFT OUTER JOIN sds PS ON P.SD_ID = PS.SD_ID LEFT OUTER JOIN serdes PSER ON PS.SERDE_ID = PSER.SERDE_ID WHERE (1 = 1)


#### Method 3
Run the [sqoop dump utility](./sqoop_hms/hms_sqoop_dump.sh) to extract a dataset from the Metastore Database.  Sqoop will drop the dataset on HDFS.

> NOTE: If you have defined 'lower_case_table_names' in my.cnf for MySql/MariaDB, add the --lower option to the call to select the correct extract sql for 'Sqoop'.

```
./hms_sqoop_dump.sh --target-hdfs-dir \
${EXTERNAL_WAREHOUSE_DIR}/${TARGET_DB}.db/hms_dump_${DUMP_ENV} \
--jdbc-db-url jdbc:mysql://<host:port>/<db_name> \
--jdbc-user <user> --jdbc-password <password> --oracle
```

The 'target-hdfs-dir' is where you'll define the 'external' table for this dataset.  The location should coincide with the standard external dataset location.


## Build Supporting Tables
Run the [Hive HMS Schema Creation Script](./analyze_hql/hms_dump_create.hql) to create the external table onto of the location you placed the sqoop extract.

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
--hivevar EXTERNAL_WAREHOUSE_DIR=${EXTERNAL_WAREHOUSE_DIR} -f hms_dump_create.hql
```

Validate the dataset is visible via 'beeline'.

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV}
```

In Beeline:

```
use ${DB};

select * from hms_dump_${ENV} limit 10;
```

---

# Start Researching
Review each of the following scripts. Each script contains a description of it's function.

## Tables with Questionable Serdes

[SQL](./analyze_hql/questionable_serde_tables.hql)

Old serde's in the system will prevent the post-migration scripts from completing. Find those missing serde's and either ensure they're available to Hive OR drop the old tables.

This process relies on a list of standard Serde's we've built up in the database.  Check the table `known_serdes_${ENV}`. If you want to add to the table, use a hive insert command.  This table is populated when we create the tables for this effort in [CREATE](./analyze_hql/hms_dump_create.hql).  If you find we've missed a 'serde', please log a github issue and I'll adjust the create script to include it for future checks.

```
use ${DB};

INSERT INTO TABLE
    known_serdes_${ENV} (SERDE_NAME)
VALUES ("your-custom-serde-class");
```

Find Questionable Tables with:

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} -f questionable_serde_tables.hql \
> ${OUTPUT_DIR}/questionable_serde_tables.csv
```

Find All Distinct Serde's used in the system:
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} --showHeader=false --outputformat=tsv2 -f all_distinct_serdes.hql \
> ${OUTPUT_DIR}/all_distinct_serdes.csv
```

Find Tables with specific serde's:
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} --hivevar SERDE=SerdeName -f table_with_this_serde.hql \
> ${OUTPUT_DIR}/table_with_this_serde.csv
```

## Are you following Best Practices?

### Check Partition Location

[SQL](./analyze_hql/check_partition_location.hql)

Many assumptions are made about partition locations.  When these location aren't standard, it may have an effect on other migration processes and calculations. This script will help identify that impact.
        
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} -f check_partition_location.hql \
> ${OUTPUT_DIR}/table_partition_locations.csv
```
                
### Non-Managed/External Table Locations

[SQL](./analyze_hql/external_table_location.hql)

Determine the overall size/count of the tables locations
        
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f external_table_location.hql
```

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f external_table_location.hql | \
awk {'print $3'} | sed -r "s/(^.*)/count \1/" | \
hadoopcli -stdin -s | grep -P '        ' | awk '{print $2,$3,$4,$5}' |sed -r "s/\s/\t/g" \
> ${OUTPUT_DIR}/external_table_stats.txt
```

Copy the above file to HDFS

```
hdfs dfs -copyFromLocal ${OUTPUT_DIR}/external_table_stats.txt \
${EXTERNAL_WAREHOUSE_DIR}/${TARGET_DB}.db/dir_size_${DUMP_ENV}
```

Get External Table List
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f get_external_table_list.hql > ${OUTPUT_DIR}/external_table_list.txt
```

### Managed Table Locations

[SQL](./analyze_hql/managed_table_location.hql)

Determine the overall size/count of the tables locations
    
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f managed_table_location.hql
```
    
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f managed_table_location.hql | \
awk {'print $3'} | sed -r "s/(^.*)/count \1/" | \
hadoopcli -stdin -s | grep -P '        ' | awk '{print $2,$3,$4,$5}' |sed -r "s/\s/\t/g" \
> ${OUTPUT_DIR}/managed_table_stats.txt
```

Copy the above file to HDFS

```
hdfs dfs -copyFromLocal ${OUTPUT_DIR}/managed_table_stats.txt \
${EXTERNAL_WAREHOUSE_DIR}/${TARGET_DB}.db/dir_size_${DUMP_ENV}
```


Get Managed Table List
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f get_managed_table_list.hql > ${OUTPUT_DIR}/managed_table_list.txt
```

Get Virtual View List
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f get_virtual_view_list.hql \
> ${OUTPUT_DIR}/get_virtual_view_list.csv
```

Get Timestamp of Table Creation
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f get_timestamps_tbls.hql \
> ${OUTPUT_DIR}/get_timestamps_tbls.csv
```

### Overlapping Table Locations

Tables sharing the same HDFS location can cause a lot of problems if one or (both/all) are managed. The conversions could move the datasets and leave the remaining tables in a strange state.

[Overlapping Table Locations](./analyze_hql/overlapping_table_locations.hql)

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f overlapping_table_locations.hql \
> ${OUTPUT_DIR}/overlapping_table_locations.csv

cat ${OUTPUT_DIR}/overlapping_table_locations.csv | grep MANAGED_TABLE > ${OUTPUT_DIR}/overlapping_table_locations_managed.csv

grep -e "/apps/hive/warehouse" -e "/user/hive/warehouse" ${OUTPUT_DIR}/overlapping_table_locations_managed.csv > ${OUTPUT_DIR}/overlapping_table_locations_under_default_managed.csv
```

If you find entries in this output AND one of the tables is 'Managed', you should split that locations and/or manage these overlapping locations before the migration process.

One solution would be to ensure the tables sharing the location are 'External' tables.

If all the offending tables pointed in each line of the output are 'External' already, you should be ok.      
      
        
## Missing HDFS Directories Check

[SQL](./analyze_hql/missing_table_dirs.hql)

The beeline output can be captured and pushed into the 'HadoopCli' for processing.  The following command will generate a script that can also be run with '-f' option in 'HadoopCli' to create the missing directories.
 
Even though we push this through hadoopcli for the hdfs test function, this will take some time to run.  If you want to see the progress, open another window session and tail the 'hcli_mkdir.txt' file.
 
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} -f missing_table_dirs.hql
```

Build a script to 'Create' the missing directories.  

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f missing_table_dirs.hql > ${OUTPUT_DIR}/tmp_missing_table_dir.txt
```

<!-- 
echo exit >> ${OUTPUT_DIR}/tmp_missing_table_dir.txt

hadoopcli -f ${OUTPUT_DIR}/tmp_missing_table_dir.txt 2> ${OUTPUT_DIR}/missing_paths_tmp.txt

cat ${OUTPUT_DIR}/missing_paths_tmp.txt | grep Command | awk {'print $6'} > ${OUTPUT_DIR}/missing_table_dir.txt

cat ${OUTPUT_DIR}/missing_table_dir.txt | awk {'print "mkdir -p "$1'} > ${OUTPUT_DIR}/hcli_mkdir.txt
-->


Above 4 cmmands are taking longer when there are 9M tests needs to be done for dir - lets split
```
mkdir ${OUTPUT_DIR}/tmp_missing_table_dirs
split -l 500000 ${OUTPUT_DIR}/tmp_missing_table_dir.txt ${OUTPUT_DIR}/tmp_missing_table_dirs/tmp_missing_table_dir.txt.
for i in `ls ${OUTPUT_DIR}/tmp_missing_table_dirs`;do echo exit >> ${OUTPUT_DIR}/tmp_missing_table_dirs/$i;done

mkdir ${OUTPUT_DIR}/missing_paths_tmp

for i in `ls ${OUTPUT_DIR}/tmp_missing_table_dirs`;do \
echo "nohup hadoopcli -f ${OUTPUT_DIR}/tmp_missing_table_dirs/$i 2> ${OUTPUT_DIR}/missing_paths_tmp/$i &" >> ${OUTPUT_DIR}/missing_paths_tmp.sh;done

sh ${OUTPUT_DIR}/missing_paths_tmp.sh

echo "### Testing hadoopcli ###"; while [ `ps -aef | grep -i hadoopcli | wc -l` -gt 1 ] ; do echo -ne ".";sleep 5;done;echo "### Done hadoopcli Testing ###"

cat ${OUTPUT_DIR}/missing_paths_tmp/* | grep Command | awk {'print $6'} > ${OUTPUT_DIR}/missing_table_dir.txt

cat ${OUTPUT_DIR}/missing_table_dir.txt | awk {'print "mkdir -p "$1'} > ${OUTPUT_DIR}/hcli_mkdir.txt
```


Get DB, Table Name for Missing Dir
```
hdfs dfs -put ${OUTPUT_DIR}/missing_table_dir.txt ${EXTERNAL_WAREHOUSE_DIR}/${TARGET_DB}.db/missing_dirs_${DUMP_ENV}/

${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f missing_dirs_db_tables.hql > ${OUTPUT_DIR}/missing_dirs_db_tables.txt
```

Create Missing HDFS Dir Locations:
```
hadoopcli -f ${OUTPUT_DIR}/hcli_mkdir.txt
```
<!-- 

```old
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS}  -f missing_table_dirs.hql | \
hadoopcli -stdin -s 2>&1 >/dev/null | cut -f 4 | \
sed 's/^/mkdir -p /g' > ${OUTPUT_DIR}/hcli_mkdir.txt
```

Review the output file 'hcli_mkdir.txt', edit if necessary and process through 'hadoopcli'.

```
hadoopcli -f hcli_mkdir.txt
``` -->


### Find Wrong paths in Hive Table Definition

cat ${OUTPUT_DIR}/hcli_mkdir.txt | egrep "//data"

sed -i 's/\/\//\//g' ${OUTPUT_DIR}/hcli_mkdir.txt

hadoopcli -f ${OUTPUT_DIR}/hcli_mkdir.txt


#### Failed paths with special chars
<!-- hadoopcli -f ${OUTPUT_DIR}/hcli_mkdir.txt | grep -i "-mkdir" -->

${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} ${HIVE_OUTPUT_OPTS} -f find_wrong_paths_in_tables.hql > $OUTPUT_DIR/wrong_paths_tables.csv

cat $OUTPUT_DIR/wrong_paths_tables.csv | awk {'print "alter table "$1"."$2" " SET LOCATION "$4"replaceme'} > $OUTPUT_DIR/alter_wrong_paths_tables.hql

${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} ${HIVE_OUTPUT_OPTS} -f find_wrong_paths_in_partitions.hql > $OUTPUT_DIR/wrong_paths_partitions.csv

cat $OUTPUT_DIR/wrong_paths_partitions.csv | awk {'print "alter table "$1"."$2" PARTITION" "("$3")" " SET LOCATION "$4"replaceme"'} > $OUTPUT_DIR/alter_wrong_paths_partitions.hql


<!-- once hql is made replace as below
"replaceme" -> "';"
"//" -> "'hdfs://sdatalakeprod/" 
-->

<!-- alter table xdl_dev_lz_arterra.ar_aging_baddebt_hist2020 PARTITION(podium_delivery_date='20191212204811') SET LOCATION 'hdfs://sdatalakedev/data/xdl/dev/LAND/PODM_DATA/XDL_DEV_LZ_ARTERRA/AR_AGING_BADDEBT_HIST2020/20191212204811/good';
alter table xdl_dev_lz_arterra.ar_aging_baddebt_hist2020 PARTITION(podium_delivery_date='20191213000000') SET LOCATION 'hdfs://sdatalakedev/data/xdl/dev/LAND/PODM_DATA/XDL_DEV_LZ_ARTERRA/AR_AGING_BADDEBT_HIST2020/20191213000000/good'; -->


## Remove transactional=false from Table Properties

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS}  -f manual_transactional_false.hql > ${OUTPUT_DIR}/manual_transactional_false.txt
```

In CDH 5.x it is possible to create tables with having the property transactional=false set. While this is a no-op setting, if any of your Hive tables explicitly set this, the upgrade process fails.

You must remove 'transactional'='false' from any tables you want to upgrade from CDH 5.x to CDP. 

Alter the table as follows:
```
ALTER TABLE my_table UNSET TBLPROPERTIES ('transactional'); 
```

# What might be moving in the Post-Migration Script

The post migration process runs a hive process call 'HiveStrictManagedMigration'.  This process will scan the databases and tables in the Metastore and determine what needs to be converted and moved to adhere to the new standards in Hive 3. 
            
### Table Migration Check

[SQL](./analyze_hql/table_migration_check.hql)

This will produce a list of tables and directories that need their ownership checked. If they are owned by 'hive', these 'managed' tables will be migrated to the new warehouse directory for Hive3.

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
-f table_migration_check.hql
```


```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f table_migration_check.hql | \
awk {'print $6'} | sed -r "s/(^.*)(\/apps.*)/lsp -f user,group,permissions_long,path \2/" \ 
> ${OUTPUT_DIR}/tmp_table_migration_check_permissions.txt

echo exit >> ${OUTPUT_DIR}/tmp_table_migration_check_permissions.txt

hadoopcli -f ${OUTPUT_DIR}/tmp_table_migration_check_permissions.txt > ${OUTPUT_DIR}/migration_check_paths.txt
```

<!-- ```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f table_migration_check.hql | \
cut -f 1,2,5,6 | sed -r "s/(^.*)(\/apps.*)/lsp -c \"\1\" -f user,group,permissions_long,path \2/" | \
hadoopcli -stdin -s > ${OUTPUT_DIR}/migration_check.txt
``` -->
    
### Acid Table Conversions

[SQL](./analyze_hql/acid_table_conversions.hql)

This script provides a bit more detail then [Table Migration Check](./analyze_hql/table_migration_check.hql), which only looks for tables in the standard location.

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} -f acid_table_conversions.hql \
> ${OUTPUT_DIR}/tobe_acid_tables.csv
```
    
### Conversion Table Directories - Bad Files that will prevent ACID conversion

[SQL](./analyze_hql/table_dirs_for_conversion.hql)

Locate Files that will prevent tables from Converting to ACID.

The 'alter' statements used to create a transactional table require a specific file pattern for existing files.  Files that don't match this, will cause issues with the upgrade.

#### Acceptable Filename Patterns

__Known__

- ([0-9]+_[0-9]+)|([0-9]+_[0-9]\_copy\_[0-9]+)
        
Get a list of table directories to check and run that through the 'Hadoop Cli' below to locate the odd files.

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} -f table_dirs_for_conversion.hql
```

Using the directories from the [Table Directories for Conversion](./analyze_hql/table_dirs_for_conversion.hql) script, we'll check each directory for possible offending file that may get in the way of converting them to an ACID table.

The 'hadoopcli' function 'lsp' does an 'inverted' pattern search for all files that do NOT match the 'GOOD_PATTERN' declared below.

NOTE: The inverted search functionality for 'lsp' in 'HadoopCli' is supported in version 2.0.14-SNAPSHOT and above.
    
```
export GOOD_PATTERN="([0-9]+_[0-9]+)|([0-9]+_[0-9]_copy_[0-9]+)"
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f table_dirs_for_conversion.hql | \
sed -r "s/(^.*)/lsp -R -F ${GOOD_PATTERN} -i \
-Fe file -v -f parent,file \1/" | hadoopcli -stdin -s >> ${OUTPUT_DIR}/bad_file_patterns.txt      
```

Figure out which pattern to use through testing with 'lsp' in [Hadoop Cli](https://github.com/dstreev/hadoop-cli)

> `lsp -R -F .*.c000 <path>` will recurse the path looking for files with a 'c000' extension.

Traditionally 'managed non-acid' or 'external' tables CAN NOT be converted to ACID tables as long as there are files present that have 'bad' filenames, as shown above.

To fix these filename in bulk, use Hive SQL to rewrite the table/parition files AND ensure whatever process that's writing the ill-formed filename, stops!

```sql
INSERT OVERWRITE TABLE mytable PARTITION (partcol1[=val1], partcol2[=val2] ...) SELECT * FROM mytable [WHERE partcol1 = val1 [ AND partcol2=val2 ]];
```

Now the table is ready to be converted to ACID.

## Converting a table to ACID

When you find a table that's "managed non-acid" in Hive 1/2 or "external" in Hive 3 and want to convert it to an 'ACID' table in Hive 3, use the following to DDL:

```sql
ALTER TABLE mytable SET TBLPROPERTIES ('EXTERNAL'='FALSE','transactional'='true');
-- Then run a Major Compaction to force the ACID table rewrite.
ALTER TABLE mytable [PARTITION (partition_key = 'partition_value' [, ...])]
  COMPACT 'MAJOR'[AND WAIT]
  [WITH OVERWRITE TBLPROPERTIES ("property"="value" [, ...])];
```
        
## Managed / ACID Table Compactions

In Hive 3, ALL managed tables are ACID tables.  Managed tables in Hive 1/2 that are ACID/Transactional need to be compacted BEFORE converting to Hive 3.  This is because the 'delta' file formats used in ACIDv1 (Hive 1/2) is NOT compatible with Hive 3 ACIDv2.

The current Pre-Upgrade tool (as of June 2019) runs as a linear process.  So if you have a LOT of tables and partitions, the process could take a very long time.  And since the process scans the Metastore, even if you have a small number of "Managed-ACID" tables, it will take a long time to process them.

So, this process is designed to allow you to skip that step.  How?  Well, we need to collect a bunch of data from the metastore dump retrieved above and compare that with the actual filesystem to determine exactly which tables NEED to be compacted.

>NOTE: These tables need to go through a 'MAJOR' compaction and consolidate away all of the 'delta' transactions BEFORE upgrading.  'delta' datasets in a table that are NOT compacted away BEFORE the upgrade will NOT be readable AFTER the upgrade.

### Acid Table Compaction Check

[SQL](./analyze_hql/acid_table_compaction_check.hql)

Build a list of ACID tables/partitions that we need to scan for delta's.  If they have delta's, they MUST be COMPACT 'MAJOR' before upgrading.

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f acid_table_compaction_check.hql \
>  ${OUTPUT_DIR}/list_current_acid_tables.csv
```
    
Now process the same query and feed it through the HadoopCli to inspect HDFS. This process will scan each of the listed directories and search for _delta_ ACID contents.  The resulting output will contain all the folders that have such entries.  These are the directories of tables/partitions that need to be 'MAJOR' COMPACTed.
    
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f acid_table_compaction_check.hql | \
cut -f 4 | \sed -r "s/(^.*)/lsp -R -F .*delta_.* -t -sp -f path \1/" | \
hadoopcli -stdin -s > ${OUTPUT_DIR}/delta_tbls-parts_paths.txt
```
    
Copy those results to HDFS, into an HDFS directory create in the [Setup SQL Script](./analyze_hql/hms_dump_create.hql) for the 'paths_${ENV}' table in the 'section=managed_deltas' partition.
    
```
hdfs dfs -copyFromLocal -f ${OUTPUT_DIR}/delta_tbls-parts_paths.txt \
${EXTERNAL_WAREHOUSE_DIR}/${TARGET_DB}.db/paths_${DUMP_ENV}/section=managed_deltas/
```
    
### Acid Table Compaction Required

[SQL](./analyze_hql/acid_table_compaction_reqs.hql)

Using the scan from above, we join it back to the ACID table listing and generate a COMPACT script that we can run against the cluster.
     
```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f acid_table_compaction_reqs.hql > ${OUTPUT_DIR}/acid_table_compaction_reqs.txt 
```

This produced 'compact_major.hql' file may be large, containing 1000's of compact actions depending on how many ACID tables you have in your environment.

To handle the load of running these compactions, you will need to tune the compactor appropriately for the load.

The tuning process will depend on how many yarn resources you have to spare in the environment. The compactor can be tuned to run these jobs in a specific queue so you can isolate the workload.  Increasing the number of threads used by the compactor will control how many compaction jobs run at a time.  The size of the queue will determine the overall volume of work the process can handle.

I recommend splitting the output script above into 1000-2000 line scripts that you can launch and monitor, before continuing on to the next.

TODO: Details on Tuning the Hive Compactor.

Once completed, I would run the whole process again to check for any missed tables.  When the list is emtpy, you've covered them all.


## WIP - Pre Upgrade Tool Run via the Upgrade

During the cluster upgrade, Ambari will run a process called the "PreUpgrade" Tool as described in the [Ambari Major Upgrade - Preparing Hive for Upgrade](https://docs.hortonworks.com/HDPDocuments/Ambari-2.7.5.0/bk_ambari-upgrade-major/content/prepare_hive_for_upgrade.html).  All the work we've done to this point was designed to replace that process through a more targeted inspection.

By running the above `compact_major.hql` before the upgrade, we can avoid running this pre-upgrade process driven by Ambari. We'll need to hack at Ambari (before you start the HDP upgrade) to turn this script off.

### Target Script on Ambari-Server

TODO: Describe how to disable during upgrade process.

/var/lib/ambari-server/resources/common-services/HIVE/0.12.0.2.0/package/scripts/pre-upgrade.py 
    
## Post Upgrade / BEFORE Using Hive 3

### Acid Table Locations

[SQL](./analyze_hql/acid_table_location_status.hql)

Only **managed** tables in standard locations will be "moved" by the post-migration process. Use this to understand that impact.

This script will identify all **managed** tables and indication if they **may** move, based on being in a **"Standard"** location.

It will also indicate whether the table is **currently** transactional or **not**.

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
-f acid_table_location_status.hql  > ${OUTPUT_DIR}/acid_table_location_status.txt 
```

```
cat ${OUTPUT_DIR}/acid_table_location_status.txt | grep -i "| YES                | NO             |" \
> ${OUTPUT_DIR}/tables_moved_with_upgrade.txt
```

For LARGE Hive Installations, build an alter Migration Script

The Migration Script MUST run against EVERY DB that contains tables the are 'managed'. These migration scripts MUST be completed BEFORE users are allowed back on the cluster.  This process is intended to allow the 'parallel' running of the core 'HiveStrictManagedMigration' process when upgrade to Hive 3. Default processing through Ambari of this script is NOT threaded and therefore can take a very long time in environments with a lot of metadata.

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f post_migration_dbs.hql \
> ${OUTPUT_DIR}/post_migration.txt
```

Build a script to call the post migration script 'HiveStrictManagedMigration' process for each of the databases independently listed in the above output.


Note: There is a 'dryrun' option for this script.  I suggest running that on a single, smaller DB to evaluate that everything is configured correctly before launching against the entire stack.

Review and run [Post Migration Hive Strict Managed Migration Launcher](./post_migration.sh) to run a migration process for each database, independently.  

TODO: Figure out how to log calls to tables, which is DEBUG. Use this to estimate table processing times.

>Watch the volume!!! If you have many database, I recommend carving this process up to run a maximum of 10 databases at a time!! 

### Modify Upgrade Process to Skip/Shortcut migration script.

WARNING: By doing this, you are taking on the **responsibility** of running this process against ALL appropriate databases and tables.

On the Ambari Server, find: `/var/lib/ambari-server/resources/stacks/HDP/3.0/services/HIVE/package/scripts/post_upgrade.py`
- Make a safe copy of the `/var/lib/ambari-server/resources/stacks/HDP/3.0` directory.
- Edit: `/var/lib/ambari-server/resources/stacks/HDP/3.0/services/HIVE/package/scripts/post_upgrade.py`
- Comment out line: `  HivePostUpgrade().execute()`
- Add Line below that: `  print ('Manual Override, run strictmanagedmigration process separately.)`
- Save file.

#### Reference Call

```
{hive_script} --config /etc/hive/conf --service  strictmanagedmigration --hiveconf hive.strict.managed.tables=true  -m automatic  --modifyManagedTables --oldWarehouseRoot /apps/hive/warehouse"
```

#### Reference For HiveStrict Command

```
hive --service strictmanagedmigration --help

usage: org.apache.hadoop.hive.ql.util.HiveStrictManagedMigration
 -d,--dbRegex <arg>                         Regular expression to match
                                            database names on which this
                                            tool will be run
    --dryRun                                Show what migration actions
                                            would be taken without
                                            actually running commands
 -h,--help                                  print help message
    --hiveconf <property=value>             Use value for given property
 -m,--migrationOption <arg>                 Table migration option
                                            (automatic|external|managed|va
                                            lidate|none)
    --modifyManagedTables                   This setting enables the
                                            shouldModifyManagedTableLocati
                                            on,
                                            shouldModifyManagedTableOwner,
                                            shouldModifyManagedTablePermis
                                            sions options
    --oldWarehouseRoot <arg>                Location of the previous
                                            warehouse root
    --shouldModifyManagedTableLocation      Whether managed tables should
                                            have their data moved from the
                                            old warehouse path to the
                                            current warehouse path
    --shouldModifyManagedTableOwner         Whether managed tables should
                                            have their directory owners
                                            changed to the hive user
    --shouldModifyManagedTablePermissions   Whether managed tables should
                                            have their directory
                                            permissions changed to conform
                                            to strict managed tables mode
 -t,--tableRegex <arg>                      Regular expression to match
                                            table names on which this tool
                                            will be run

```

By shortcutting Ambari's version of this process, we need to build a list of **Db's** and Tables that need to run through the post migration process.  When know, we run the process manually, targeting only those areas that are important (hive tables that "NEED" to be reviewed), instead of processing the whole system, one at a time.  

With the data collected from 'External/Managed Table Locations', we can run the following and get table and db sizes.

TODO: Build script with DB contents and run.

NOTE: This section depends on the output from [Non-Managed Table Locations](#non-managed-table-locations) and [Managed Table Locations](#managed-table-locations)

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS_2} -f size_of_dbs.hql > ${OUTPUT_DIR}/size_of_dbs.csv
```

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS_2} -f size_of_tables.hql > ${OUTPUT_DIR}/size_of_tables.csv
```

The output will be a list of databases with the following:
- db_name
- tbl_count
- folder_count
- file_count
- total_size

```
${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
--showHeader=true --outputformat=tsv2 -f get_hive_stats_count.hql \
>> ${OUTPUT_DIR}/get_hive_stats_count.txt
```

### Get HDFS Stats
hadoopcli -f ../hdfs_stats/get_hdfs_stats.txt > ${OUTPUT_DIR}/total_hdfs_stats.txt

### Some Quereis we ran Manually on Oracle

select * from SDS WHERE LOCATION like '%hdpserver%';

select DB_ID from DBS where name='cpm'; 

select * from TBLS where DB_ID=486;

select * from SDS WHERE LOCATION not like '%sdatalakeprod%';

select * from DBS where db_id='335';

select * from TBLS where sd_id='10088161';

-- special chars
select * from SDS WHERE LOCATION like '%[%,.!?;;]%'; 

select * from partitions where sd_id='24295182' or sd_id='38421238';

select * from TBLS where tbl_id='151311' or tbl_id='151311';

select * from DBS where db_id='191';

-- get empty dbs
SELECT DB_ID, NAME, DB_LOCATION_URI,owner_name,owner_type
FROM   DBS 
WHERE  DB_ID NOT IN (SELECT DB_ID FROM TBLS);

-- worng paths
select * from SDS WHERE LOCATION like 'hdfs://sdatalakeprod//' and LOCATION like 'har://hdfs-sdatalakeprod//';

select * from SDS WHERE LOCATION not like 'hdfs://sdatalakeprod%' and LOCATION not like 'har://hdfs-sdatalakeprod%';

--- DELETE HAR FILES

select LOCATION from SDS WHERE LOCATION like 'har://hdfs-sdatalakeprod%';

select * from partitions where sd_id='7651640';

select * from TBLS where tbl_id='85602';

select * from DBS where db_id='501';

select distinct DBS.Name, TBLS.tbl_name from DBS left join TBLS on dbs.db_id=tbls.db_id left join partitions on tbls.tbl_id=partitions.tbl_id left join 
sds on sds.sd_id=partitions.sd_id where sds.location like 'har://hdfs-sdatalakeprod%';

select distinct DBS.Name, TBLS.tbl_name, partitions.part_name, sds.LOCATION  from DBS left join TBLS on dbs.db_id=tbls.db_id left join partitions on tbls.tbl_id=partitions.tbl_id left join 
sds on sds.sd_id=partitions.sd_id where sds.location like 'har://hdfs-sdatalakeprod%';

# Hadoop CLI

An interactive/scripted 'hdfs' client that can be scripted to reduce the time it takes to cycle through 'hdfs' commands.  

[Hadoop CLI Project/Sources Github](https://github.com/dstreev/hadoop-cli)

Fetch the latest Binary Distro [here](https://github.com/dstreev/hadoop-cli/releases) . Unpack the hadoop.cli-x.x.x-SNAPSHOT-x.x.tar.gz and run (as root) the setup from the extracted folder. Detailed directions [here](https://github.com/dstreev/hadoop-cli).

`./setup.sh`

Launch the application without parameters will pickup your default configs, just like `hdfs` or `hadoop` command line applications.

`hadoopcli`

## Usage Scenario

### STDIN Processing

The Hadoop Cli can process `stdin`.  So it can be part of a bash pipeline.  In this case, we run a query in beeline, output the results and create another file with our target commands.

```
hive -c llap --hivevar DB=citizens --hivevar ENV=qa \
--showHeader=false --outputformat=tsv2  -f test.hql | \
hadoopcli -stdin 2>&1 >/dev/null | cut -f 4 | \
sed 's/^/mkdir -p /g' > hcli_mkdir.txt
```

### File Based Script

Test a list of directories against 'hdfs' to see if they exist.  See above 'Missing HDFS Directories Check'.

Create a text file (test.txt) and add some commands.  The last line should 'exit' followed by an empty line.
```
test -e /user/ted
test -e /user/chuck
test -e /apps/hive/warehouse/my_db.db/some_random_tbl
exit

```
Then run the 'hadoopcli' with the text file as an init script.

`hadoopcli -f test.txt 2> missing.txt`

This will pipe all 'errors' to 'missing.txt'.  The 'test' command throws an error when the directory doesn't exist.


# Extract Code Snippets from README.md
sed -n '/```/,/```/p' README.md
