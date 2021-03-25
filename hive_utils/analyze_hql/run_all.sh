NOW=$(date +"%Y%m%d-%H%M")
mkdir -p /data/bigdata_upgrade/output-$NOW
export OUTPUT_DIR=/data/bigdata_upgrade/output-$NOW


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} -f questionable_serde_tables.hql \
> ${OUTPUT_DIR}/questionable_serde_tables.csv


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} --showHeader=false --outputformat=tsv2 -f all_distinct_serdes.hql \
> ${OUTPUT_DIR}/all_distinct_serdes.csv


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} --hivevar SERDE=SerdeName -f table_with_this_serde.hql \
> ${OUTPUT_DIR}/table_with_this_serde.csv


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} -f check_partition_location.hql \
> ${OUTPUT_DIR}/table_partition_locations.csv



${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f external_table_location.hql | \
awk {'print $3'} | sed -r "s/(^.*)/count \1/" | \
hadoopcli -stdin -s | grep -P '        ' | awk '{print $2,$3,$4,$5}' |sed -r "s/\s/\t/g" \
> ${OUTPUT_DIR}/external_table_stats.txt


hdfs dfs -copyFromLocal ${OUTPUT_DIR}/external_table_stats.txt \
${EXTERNAL_WAREHOUSE_DIR}/${TARGET_DB}.db/dir_size_${DUMP_ENV}


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f get_external_table_list.hql > ${OUTPUT_DIR}/external_table_list.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f managed_table_location.hql


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f managed_table_location.hql | \
awk {'print $3'} | sed -r "s/(^.*)/count \1/" | \
hadoopcli -stdin -s | grep -P '        ' | awk '{print $2,$3,$4,$5}' |sed -r "s/\s/\t/g" \
> ${OUTPUT_DIR}/managed_table_stats.txt


hdfs dfs -copyFromLocal ${OUTPUT_DIR}/managed_table_stats.txt \
${EXTERNAL_WAREHOUSE_DIR}/${TARGET_DB}.db/dir_size_${DUMP_ENV}


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f get_managed_table_list.hql > ${OUTPUT_DIR}/managed_table_list.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f get_virtual_view_list.hql \
> ${OUTPUT_DIR}/get_virtual_view_list.csv


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f overlapping_table_locations.hql \
> ${OUTPUT_DIR}/overlapping_table_locations.csv

cat ${OUTPUT_DIR}/overlapping_table_locations.csv | grep MANAGED_TABLE > ${OUTPUT_DIR}/overlapping_table_locations_managed.csv

grep -e "/apps/hive/warehouse" -e "/user/hive/warehouse" ${OUTPUT_DIR}/overlapping_table_locations_managed.csv \
> ${OUTPUT_DIR}/overlapping_table_locations_under_default_managed.csv


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f missing_table_dirs.hql > ${OUTPUT_DIR}/tmp_missing_table_dir.txt

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



hdfs dfs -put ${OUTPUT_DIR}/missing_table_dir.txt ${EXTERNAL_WAREHOUSE_DIR}/${TARGET_DB}.db/missing_dirs_${DUMP_ENV}/

${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f missing_dirs_db_tables.hql > ${OUTPUT_DIR}/missing_dirs_db_tables.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS}  -f manual_transactional_false.hql > ${OUTPUT_DIR}/manual_transactional_false.txt



${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f table_migration_check.hql | \
awk {'print $6'} | sed -r "s/(^.*)(\/apps.*)/lsp -f user,group,permissions_long,path \2/" \
> ${OUTPUT_DIR}/tmp_table_migration_check_permissions.txt

echo exit >> ${OUTPUT_DIR}/tmp_table_migration_check_permissions.txt

hadoopcli -f ${OUTPUT_DIR}/tmp_table_migration_check_permissions.txt > ${OUTPUT_DIR}/migration_check_paths.txt



${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} -f acid_table_conversions.hql \
> ${OUTPUT_DIR}/tobe_acid_tables.csv



${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f acid_table_compaction_check.hql \
>  ${OUTPUT_DIR}/list_current_acid_tables.csv


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f acid_table_compaction_check.hql | \
cut -f 4 | \sed -r "s/(^.*)/lsp -R -F .*delta_.* -t -sp -f path \1/" | \
hadoopcli -stdin -s > ${OUTPUT_DIR}/delta_tbls-parts_paths.txt


hdfs dfs -copyFromLocal -f ${OUTPUT_DIR}/delta_tbls-parts_paths.txt \
${EXTERNAL_WAREHOUSE_DIR}/${TARGET_DB}.db/paths_${DUMP_ENV}/section=managed_deltas/


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f acid_table_compaction_reqs.hql > ${OUTPUT_DIR}/acid_table_compaction_reqs.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
-f acid_table_location_status.hql > ${OUTPUT_DIR}/acid_table_location_status.txt

cat ${OUTPUT_DIR}/acid_table_location_status.txt | grep -i "| YES                | NO             |" \
> ${OUTPUT_DIR}/tables_moved_with_upgrade.txt


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS} -f post_migration_dbs.hql \
> ${OUTPUT_DIR}/post_migration.txt



${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS_2} -f size_of_dbs.hql > ${OUTPUT_DIR}/size_of_dbs.csv


${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
${HIVE_OUTPUT_OPTS_2} -f size_of_tables.hql > ${OUTPUT_DIR}/size_of_tables.csv

${HIVE_ALIAS} --hivevar DB=${TARGET_DB} --hivevar ENV=${DUMP_ENV} \
--showHeader=true --outputformat=tsv2 -f get_hive_stats_count.hql \
>> ${OUTPUT_DIR}/get_hive_stats_count.txt


hadoopcli -f ../hdfs_stats/get_hdfs_stats.txt > ${OUTPUT_DIR}/total_hdfs_stats.txt