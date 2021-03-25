USE ${DB};

-- identify large cogsleyservices_sales with IF
select 
    orderid,
    saleamount,
    if(saleamount > 5000, 1, 0) as LargeSale
from cogsleyservices_sales_all_years
limit 1000;

-- create cogsleyservices_sales size categories
select 
    orderid,
    saleamount,
    case 
        when saleamount > 5000 then 'large'
        when saleamount > 1000 then 'medium'
        else 'small'
    end as SalesSize
from cogsleyservices_sales_all_years
limit 1000;

-- perform what-if analysis by reassigning regions
select 
    case lower(region)
        when 'west' then 'Southwest'
        when 'south' then 'Southwest'
        else region
    end as new_region,
    year(orderdate) as y,
    sum(saleamount) as TotalSales
from cogsleyservices_sales_all_years
group by
    case lower(region)
        when 'west' then 'Southwest'
        when 'south' then 'Southwest'
        else region
    end,
    year(orderdate)
limit 100;
