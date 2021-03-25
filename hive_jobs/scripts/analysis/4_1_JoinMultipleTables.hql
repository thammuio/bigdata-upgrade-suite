USE ${DB};

-- checkout client data
select count(*)
from cogsleyservices_clients;

-- how many rows do we have?
-- 35,749
select count(1)
from cogsleyservices_sales_all_years;

-- inner join from sales
-- 35,749
select count(1)
from cogsleyservices_sales_all_years s
join cogsleyservices_clients c on s.companyname = c.name;

-- Add details about cogsleyservices_clients for a more comprehensive answer
select 
    c.marketcaplabel, 
    c.marketcapamount,
    c.name, 
    c.ipoyear, 
    c.symbol,
    count(distinct s.orderid) OrderCount,
    sum(s.saleamount) as TotalSales
from cogsleyservices_sales_all_years s
join cogsleyservices_clients c on s.companyname = c.name
group by
    c.marketcaplabel, 
    c.marketcapamount,
    c.name, 
    c.ipoyear,
    c.symbol
order by
    c.marketcapamount desc;
