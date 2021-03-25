

echo "Loading Data to driver_dangerous_event"

hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator=,  -Dimporttsv.columns="HBASE_ROW_KEY,events:driverId,events:driverName,events:eventTime,events:eventType,events:latitudeColumn,events:longitudeColumn,events:routeId,events:routeName,events:truckId" bda:driver_dangerous_event /tmp/data.csv

echo "Loading Data to books"

hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="|"  -Dimporttsv.columns="HBASE_ROW_KEY,bookids:isbn,bookids:category,bookdetails:publish_date,bookdetails:publisher,bookdetails:price" bda:2cfbooks /tmp/books.csv

