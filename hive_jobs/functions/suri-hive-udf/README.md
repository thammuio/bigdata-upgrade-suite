# Hive UDFs

## About
Hive UDFs is a collection of user defined functions for Hive.

## License
[Apache License Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

## Quickstart - Build UDF with Maven
<!-- Setup MAven -->
wget http://www-eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar xzf apache-maven-3.3.9-bin.tar.gz
ln -s apache-maven-3.3.9 maven
export M2_HOME=$HOME/maven
export PATH=${M2_HOME}/bin::${PATH}
mvn -version 

cd suri-hive-udf
mvn clean package

## Install and Configurations

### Registering the UDFs
    hive> add jar /tmp/suri-hive-udf-[VERSION].jar;
    hive> CREATE TEMPORARY FUNCTION custom_nvl AS 'com.suri.platform.hive.udf.GenericUDFNVL';
    hive> CREATE TEMPORARY FUNCTION custom_decode AS 'com.suri.platform.hive.udf.GenericUDFDecode';
    hive> CREATE TEMPORARY FUNCTION custom_nvl2 AS 'com.suri.platform.hive.udf.GenericUDFNVL2';
    hive> CREATE TEMPORARY FUNCTION custom_str_to_date AS 'com.suri.platform.hive.udf.UDFStrToDate';
    hive> CREATE TEMPORARY FUNCTION custom_date_format AS 'com.suri.platform.hive.udf.UDFDateFormat';
    hive> CREATE TEMPORARY FUNCTION custom_to_char AS 'com.suri.platform.hive.udf.UDFToChar';
    hive> CREATE TEMPORARY FUNCTION custom_instr4 AS 'com.suri.platform.hive.udf.GenericUDFInstr';
    hive> CREATE TEMPORARY FUNCTION custom_chr AS 'com.suri.platform.hive.udf.UDFChr';
    hive> CREATE TEMPORARY FUNCTION custom_last_day AS 'com.suri.platform.hive.udf.UDFLastDay';
    hive> CREATE TEMPORARY FUNCTION custom_greatest AS 'com.suri.platform.hive.udf.GenericUDFGreatest';
    hive> CREATE TEMPORARY FUNCTION custom_to_number AS 'com.suri.platform.hive.udf.GenericUDFToNumber';
    hive> CREATE TEMPORARY FUNCTION custom_trunc AS 'com.suri.platform.hive.udf.GenericUDFTrunc';
    hive> CREATE TEMPORARY FUNCTION custom_rank AS 'com.suri.platform.hive.udf.GenericUDFRank';
    hive> CREATE TEMPORARY FUNCTION custom_row_number AS 'com.suri.platform.hive.udf.GenericUDFRowNumber';
    hive> CREATE TEMPORARY FUNCTION custom_sysdate AS 'com.suri.platform.hive.udf.UDFSysDate';
    hive> CREATE TEMPORARY FUNCTION custom_populate AS 'com.suri.platform.hive.udf.GenericUDTFPopulate';
    hive> CREATE TEMPORARY FUNCTION custom_dedup AS 'com.suri.platform.hive.udf.GenericUDAFDedup';
    hive> CREATE TEMPORARY FUNCTION custom_lnnvl AS 'com.suri.platform.hive.udf.GenericUDFLnnvl';
    hive> CREATE TEMPORARY FUNCTION custom_substr AS 'com.suri.platform.hive.udf.UDFSubstrForOracle';


## Usage of Hive UDFs
### nvl
    hive> DESCRIBE FUNCTION EXTENDED custom_nvl;   
    OK
    nvl(expr1, expr2) - Returns expr2 if expr1 is null
    
    Example:
     > SELECT custom_nvl(dep, 'Not Applicable') FROM src;
     'Not Applicable' if dep is null
     
### decode
    hive> DESCRIBE FUNCTION EXTENDED custom_decode;
    OK
    decode(value1, value2, value3, .... defaultValue) - Returns value3 if value1=value2 otherwise defaultValue
    
    Example:
     > SELECT custom_decode(dep, 0, "ACCOUNT", 1, "HR", "NO-DEP") FROM src LIMIT 1;
     'ACCOUNT' if dep=0

### nvl2
    hive> DESCRIBE FUNCTION EXTENDED custom_nvl2;
    OK
    nvl2(string1, value_if_not_null, value_if_null) - Returns value_if_not_null if string1 is not null, otherwise value_if_null
    
    Example:
     > SELECT custom_nvl2(supplier_city, 'Completed', 'n/a') FROM src;
     'n/a' if supplier_city is null

### str_to_date
    hive> DESCRIBE FUNCTION EXTENDED custom_str_to_date;
    OK
    str_to_date(dateText,pattern) - Convert time string with given pattern to time string with 'yyyy-MM-dd HH:mm:ss' pattern
    
    Example:
    > SELECT custom_str_to_date('2011/05/01','yyyy/MM/dd') FROM src LIMIT 1;
    2011-05-01 00:00:00
    > SELECT custom_str_to_date('2011/07/21 12:55:11'.'yyyy/MM/dd HH:mm:ss') FROM src LIMIT 1;
    2011-07-21 12:55:11
    
### to_char
    hive> DESCRIBE FUNCTION EXTENDED custom_to_char;
    OK
    to_char(date, pattern)  converts a string with yyyy-MM-dd HH:mm:ss pattern to a string with given pattern.
    to_char(datetime, pattern)  converts a string with yyyy-MM-dd pattern to a string with given pattern.
    to_char(number [,format]) converts a number to a string
    
    Example:
     > SELECT custom_to_char('2011-05-11 10:00:12'.'yyyyMMdd') FROM src LIMIT 1;
    20110511

### date_format
    hive> DESCRIBE FUNCTION EXTENDED custom_date_format;
    OK
    date_format(dateText,pattern) - Return time string with given pattern. 
    Convert time string with 'yyyy-MM-dd HH:mm:ss' pattern to time string with given pattern.
     (see [http://java.sun.com/j2se/1.4.2/docs/api/java/text/SimpleDateFormat.html])
    
    Example:
     > SELECT custom_date_format ('2011-05-11 12:05:11','yyyyMMdd') FRom src LIMIT 1;
    20110511
            
### instr4
    hive> DESCRIBE FUNCTION EXTENDED custom_instr4;
    OK
    instr4(string, substring, [start_position, [nth_appearance]]) - Returns the index of the first occurance of substr in str
    
    Example:
      > SELECT custom_instr4('Facebook', 'boo') FROM src LIMIT 1;
      5

### chr
    hive> DESCRIBE FUNCTION EXTENDED custom_chr;   
    OK
    chr(number_code) - Returns returns the character based on the NUMBER code.
    
    Example:
      > SELECT custom_chr(116) FROM src LIMIT 1;
      t
      > SELECT custom_chr(84) FROM src LIMIT 1;
      T

### last_day
    hive> DESCRIBE FUNCTION EXTENDED custom_last_day;
    OK
    last_day(dateString) -  returns the last day of the month based on a date string with yyyy-MM-dd HH:mm:ss pattern.

    Example:
    > SELECT custom_last_day('2003-03-15 01:22:33') FROM src LIMIT 1;
    2003-03-31 00:00:00


### greatest
    hive> DESCRIBE FUNCTION EXTENDED custom_greatest;
    OK
    greatest(value1, value2, value3, ....) - Returns the greatest value in the list.
    
    Example:
    > SELECT custom_greatest(2, 5, 12, 3) FROM src;
    12

### to_number
    hive> DESCRIBE FUNCTION EXTENDED custom_to_number; 
    OK
    to_number(value, format_mask) - Returns the number converted from string.
    
    Example:
     > SELECT custom_to_number('1210') FROM src;
     1210

### substr
    hive> DESCRIBE FUNCTION EXTENDED custom_substr;   
    OK
    substr(str, pos[, len]) - returns the substring of str that starts at pos and is of length len orsubstr(bin, pos[, len]) - returns the slice of byte array that starts at pos and is of length len
    Synonyms: substring
    pos is a 1-based index. If pos<0 the starting position is determined by counting backwards from the end of str.
    
    Example:
       > SELECT custom_substr('Facebook', 5) FROM src LIMIT 1;
      'book'
      > SELECT custom_substr('Facebook', -5) FROM src LIMIT 1;
      'ebook'
      > SELECT custom_substr('Facebook', 5, 1) FROM src LIMIT 1;
      'b'

### trunc
    hive> DESCRIBE FUNCTION EXTENDED custom_trunc;      
    OK
    trunc(date, [format_mask]) - Returns a date in string truncated to a specific unit of measure.
    
    Example:
     > SELECT custom_trunc('2011-08-02 01:01:01') FROM src ;
     returns '2011-08-02 00:00:00' 

### sysdate
    hive> DESCRIBE FUNCTION EXTENDED custom_sysdate;
    OK
    sysdate() - Returns the current date and time as a value in 'yyyy-MM-dd HH:mm:ss' formatsysdate(dateFormat) - Returns the current date and time as a value in given formatsysdate(dateFormat, num_days) - Returns the date that is num_days after current date in given date format
    
    Example:
      > SELECT custom_sysdate() FROM src LIMIT 1;
      2011-06-13 13:47:36  
      > SELECT custom_sysdate('yyyyMMdd') FROM src LIMIT 1;
      20110613  
      > SELECT custom_sysdate('yyyyMMdd',1) FROM src LIMIT 1;
      20110614

### populate

### dedup

### lnnvl
    hive> DESCRIBE FUNCTION EXTENDED custom_lnnvl;
    OK
    lnnvl(condition) - Evalutates a condition when one of the operands may contains a NULL value.
    
    Example:
    FALSE if condition is true   return false