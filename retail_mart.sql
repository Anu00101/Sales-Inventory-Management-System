use retail_mart;
--- #1 TOTAL SALES BY MONTH ---
select date_format(order_date,'%Y-%m') as sales_month,
sum(total_amount) as total_sales
from orders group by sales_month order by sales_month;

--- #2 TOP 5 POPULAR PRODUCTS ---
select P.Product_name, count(od.product_id) as items_sold
from orderdetails as od join Product as P on 
od.Product_id=P.Product_id group by P.Product_name
order by items_sold desc limit 5 ;

--- #3 CUSTOMER LIFESPAN ---
select CUS.Name, sum(OD.Total_Amount) as Total_exp from orders as
OD join customer as CUS on OD.Customer_id=CUS.Customer_id
group by CUS.Name order by Total_exp desc limit 10;

--- #4 RANGE OF PRODUCTS ---
select concat('Product ranges from $',min(UnitPrice), ' to $'
,max(UnitPrice)) as Range_of_products from orderdetails;

 #OR, PRODUCTS WITH THE HIGHEST AND LOWEST PRICES
 
(select Product_name,Product_price From product order by 
product_price desc limit 5 )union all 
(select Product_name,Product_price from Product order by
Product_price asc limit 5) ;
 
--- #5 SALES PER SUPPLIER ---
SELECT
    S.Supplier_name,
    SUM(OD.Quantity * OD.UnitPrice) AS total_sales
FROM
    OrderDetails AS OD
JOIN
    Product AS P ON OD.Product_id = P.Product_id
JOIN
    Supplier AS S ON P.Supplier_id = S.Supplier_id
GROUP BY
    S.Supplier_name
ORDER BY
    total_sales DESC;
    
--- #6 Average order value ---
select
avg(Total_amount) as avg_order_values
from orders;

--- #7 Inventory levels per product ---
select p.Product_name, (ifnull(sum(i.Quantity_in),0)-
ifnull(sum(i.Quantity_out),0)) as current_stock
from product p left join
inventory i on i.Product_id=p.Product_id
group by p.Product_name
order by current_stock desc;

--- #8 TOTAL SALES PER CITY ---
select c.Address , sum(o.Total_amount) as city_ecp from 
customer c 
join orders o on c.customer_id=o.customer_id 
group by c.Address order by city_ecp desc ;

--- #9 MOST ACTIVE CUSTOMERS IN THE LAST 30 DAYS ---
select c.Name, count(o.Order_id) as no_of_orders
from customer c
join orders o on c.Customer_id=o.Customer_id
where o.Order_date>=curdate() - INTERVAL 30 DAY
group by c.Name order by no_of_orders desc;

--- #10 PRODUCTS NEVER SOLD ---
select p.Product_name from product p left join orderdetails
o  on o.Product_id=p.Product_id where o.Product_id is null;
 