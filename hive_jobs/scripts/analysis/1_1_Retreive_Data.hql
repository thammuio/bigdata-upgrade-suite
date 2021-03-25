USE ${DB};

-- /* structure
-- SELECT <columns>
-- FROM <table>
-- JOIN <other tables>
-- WHERE <filter condition>
-- GROUP BY <grouping>
-- HAVING <aggregate filter>
-- ORDER BY <column list>
-- LIMIT <number of rows>
-- */


-- the most basic select
select * -- all columns from table
from cogsleyservices_sales --table to pull from
limit 100; --only return the top 100 rows
    
-- out of order
from cogsleyservices_sales
select *
limit 100;

-- aliasing tables and picking columns
select 
    s.orderdate,   
    s.saleamount,
    s.rowid
from 
    cogsleyservices_sales s
limit 100;

-- aliasing columns
select 
    s.orderdate as OrderDate,   
    s.saleamount as Sales,
    s.rowid as RowNum
from 
    cogsleyservices_sales s
limit 100;


-- the most basic select
select * -- all columns from table
from cogsleyservices_clients --table to pull from
limit 100; --only return the top 100 rows

-- the most basic select
select * -- all columns from table
from cogsleyservices_vip_clients; --table to pull from