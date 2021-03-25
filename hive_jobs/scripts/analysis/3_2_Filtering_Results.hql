USE ${DB};

-- start by finding all the product cogsleyservices_sales for 2009
select 
    productcategory,
    productsubcategory,
    productkey,
    sum(saleamount) as TotalSales
from cogsleyservices_sales_all_years
where
    Yr=2009
group by 
    productcategory, 
    productsubcategory, 
    productkey
limit 1000;


--show only products with over 100K in cogsleyservices_sales_all_years
select 
    productcategory,
    productsubcategory,
    productkey,
    sum(saleamount) as TotalSales
from cogsleyservices_sales_all_years
where
    Yr=2009
group by 
    productcategory, 
    productsubcategory, 
    productkey
having
    sum(saleamount) > 100000
limit 1000;
