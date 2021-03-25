

scan 'bulkload:2cfbooks', {LIMIT => 10}

hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="|"  -Dimporttsv.columns="HBASE_ROW_KEY,bookids:isbn,bookids:category,bookdetails:publish_date,bookdetails:publisher,bookdetails:price" bulkload:2cfbooks /data/one/books/books

create 'bulkload:2cfbooksnew','bookids','bookdetails'

scan 'bulkload:2cfbooksnew', {LIMIT => 10}

hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="|"  -Dimporttsv.columns="HBASE_ROW_KEY,bookids:isbn,bookids:category,bookdetails:publish_date,bookdetails:publisher,bookdetails:price" bulkload:2cfbooksnew /data/one/books/books



create '2cfbookstest2','bookids','bookdetails'
HBASE_ROW_KEY,bookids:isbn,bookids:category,bookdetails:publish_date,bookdetails:publisher,bookdetails:price

create table "2cfbookstest2" ("row" VARCHAR primary key,"bookids"."id" VARCHAR,"bookids"."isbn2" VARCHAR,
"bookids"."category" VARCHAR,"bookdetails"."publish_date" VARCHAR,"bookdetails"."publisher" VARCHAR,
"bookdetails"."price" VARCHAR);

create table "2cfbookstest2" ("row" VARCHAR primary key,"bookids"."id" VARCHAR(255),"bookids"."isbn2" VARCHAR(255),
"bookids"."category" VARCHAR(255),"bookdetails"."publish_date" VARCHAR(255),"bookdetails"."publisher" VARCHAR(255),
"bookdetails"."price" VARCHAR(255));

UPSERT INTO "2cfbookstest2" values('104','15969756','5-16191-127-2','ANTIQUES-COLLECTIBLES','1982-11-10','Wiley','179.99');
UPSERT INTO "2cfbookstest2" values('105','15969756','5-16191-127-2','ANTIQUES-COLLECTIBLES','1982-11-10','Wiley','179.99');
UPSERT INTO "2cfbookstest2" values('106','15969756','5-16191-127-2','ANTIQUES-COLLECTIBLES','1982-11-10','Wiley','179.99');
UPSERT INTO "2cfbookstest2" values('107','15969756','5-16191-127-2','ANTIQUES-COLLECTIBLES','1982-11-10','Wiley','179.99');
UPSERT INTO "2cfbookstest2" values('108','15969756','5-16191-127-2','ANTIQUES-COLLECTIBLES','1982-11-10','Wiley','179.99');