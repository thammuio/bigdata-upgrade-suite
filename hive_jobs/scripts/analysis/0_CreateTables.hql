USE ${DB};

-- Not Needed as we are using org.apache.hadoop.hive.serde2.OpenCSVSerde
-- add jar hdfs:///tmp/csv-serde-1.1.2.jar;

-- Create Client Table
create table cogsleyservices_clients(
Name string,
Symbol string,
LastSale double,
MarketCapLabel string,
MarketCapAmount bigint,
IPOyear int,
Sector string,
industry string,
SummaryQuote string
)
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
stored as textfile;


-- Create Sales All Years Table
create table cogsleyservices_sales_all_years (
    RowID smallint,
    OrderID int,
    OrderDate date,
    OrderMonthYear date,
    Quantity int,
    Quote float,
    DiscountPct float,
    Rate float,
    SaleAmount float,
    CustomerName string,
    CompanyName string,
    Sector string,
    Industry string,
    City string,
    ZipCode string,
    State string,
    Region string,
    ProjectCompleteDate date,
    DaystoComplete int,
    ProductKey string,
    ProductCategory string,
    ProductSubCategory string,
    Consultant string,
    Manager string,
    HourlyWage float,
    RowCount int,
    WageMargin float
)
partitioned by (yr int) 
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
stored as textfile;


-- add the partitions
alter table cogsleyservices_sales_all_years
add partition (yr=2009)
location '2009/';

alter table cogsleyservices_sales_all_years
add partition (yr=2010)
location '2010/';

alter table cogsleyservices_sales_all_years
add partition (yr=2011)
location '2011/';

alter table cogsleyservices_sales_all_years
add partition (yr=2012)
location '2012/';


-- Create Sales Table
create table cogsleyservices_sales (
    RowID smallint,
    OrderID int,
    OrderDate date,
    OrderMonthYear date,
    Quantity int,
    Quote float,
    DiscountPct float,
    Rate float,
    SaleAmount float,
    CustomerName string,
    CompanyName string,
    Sector string,
    Industry string,
    City string,
    ZipCode string,
    State string,
    Region string,
    ProjectCompleteDate date,
    DaystoComplete int,
    ProductKey string,
    ProductCategory string,
    ProductSubCategory string,
    Consultant string,
    Manager string,
    HourlyWage float,
    RowCount int,
    WageMargin float
)
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
stored as textfile;

-- Create VIP Clients
drop table cogsleyservices_vip_clients;
-- create new vip table
create table if not exists cogsleyservices_vip_clients(name string);
-- load some data
insert into cogsleyservices_vip_clients values
    ('Apple Inc.'), 
    ('Google Inc.'), 
    ('Facebook, Inc.'), 
    ('Amazon.com, Inc.'),
    ('QUALCOMM Incorporated'),
    ('America Movil, S.A.B. de C.V.'),
    ('Starbucks Corporation'),
    ('Costco Wholesale Corporation'),
    ('DIRECTV'),
    ('Adobe Systems Incorporated'),
    ('Netflix, Inc.');


-- adding CSV SERDE to a table
-- ALTER TABLE <table-name> SET SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde';


