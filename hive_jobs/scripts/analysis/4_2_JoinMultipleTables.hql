USE ${DB};


-- ANSI SQL method using exists
select *
from cogsleyservices_sales_all_years s
where exists(
    select *
    from cogsleyservices_vip_clients v
    where s.companyname = v.name);

-- get info about vip clients only
select 
    s.companyname,
    s.productcategory,
    count(distinct s.orderid) OrderCount,
    sum(s.saleamount) as TotalSales
from cogsleyservices_sales_all_years s
left semi join cogsleyservices_vip_clients v on (s.companyname = v.name) 
group by
    s.companyname,
    s.productcategory;
