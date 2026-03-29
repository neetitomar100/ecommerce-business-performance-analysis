-- Create Product Table
create table Product(
product_ID int,
created_at Date,
product_name varchar(100)
);

-- Insert Product Table
Insert into Product(product_id, created_at,product_name)
values
(1,' 2012-03-19', 'The Original Mr. Fuzzy'),
(2,' 2013-01-06', 'The Forever Love Bear'),
(3,' 2013-12-12', 'The Birthday Sugar Panda'),
(4,' 2014-02-05', 'The Hudson River Mini bear');

-- Run Table
select * from Product;


-- Create order table
create table Ecommerce_orders(
order_id int,
created_at date,
website_session_id int,
user_id int,
primary_product_id int,
items_purchased int,
price_usd float,
cogs_usd float
);

-- Export csv file
COPY Ecommerce_orders
FROM 'C:\Users\Paras.Tomar\Desktop\Data analyst project\Sql Projects\ecommerce_orders.csv'
DELIMITER ','
CSV HEADER;

-- run Ecommerce_orders
select * from Ecommerce_orders;


-- create order Items table
create table order_items(
order_item_id int,
created_at date,
order_id int,
product_id int,
is_primary_item int,
price_usd Decimal(10,2),
cogs_usd Decimal(10,2)
);

copy order_items
from 'C:\Users\Paras.Tomar\Desktop\Data analyst project\Sql Projects\Order items data.csv'
delimiter ','
csv header;

select * from order_items;

-- create order refund item table
create table order_Item_refunds(
order_item_refund_id int,
created_at date,
order_item_id int,
order_id int,
refund_amount_usd float
)

copy order_Item_refunds
from 'C:\Users\Paras.Tomar\Desktop\Data analyst project\Sql Projects\Order item refunds.csv'
delimiter ','
csv header;

select * from order_Item_refunds;

-- Total revenue
select sum(price_usd) as total_revenue
from order_items;

--Total orders
select count(DISTINCT order_id) as Total_orders
from ecommerce_orders;

--Average order value
select avg(price_usd) as Average_Order_value
from ecommerce_orders;

-- Top Selling items
SELECT 
p.product_name,
COUNT(oi.order_item_id) AS total_sold
FROM order_items oi
JOIN product p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

--Profit by product
select
p.product_name,
Round(sum(oi.price_usd - oi.cogs_usd)::numeric,0) as Total_Profit
from order_items oi
join product p
on oi.product_id = p.product_id
group by p.product_name;

-- montly revenue trend
SELECT 
TO_CHAR(created_at, 'Month') AS month,
round(SUM(price_usd)::numeric,0) AS monthly_revenue
FROM order_items
GROUP BY month, DATE_PART('month', created_at)
ORDER BY DATE_PART('month', created_at);

--refund amount by product
SELECT 
p.product_name,
ROUND(SUM(r.refund_amount_usd)::numeric,0) AS total_refund
FROM order_item_refunds r
JOIN order_items oi
ON r.order_item_id = oi.order_item_id
JOIN product p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_refund DESC;


-- Profit Margin by Product
SELECT 
p.product_name,
ROUND(
(SUM(oi.price_usd - oi.cogs_usd) / SUM(oi.price_usd) * 100)::numeric
,2) AS profit_margin
FROM order_items oi
JOIN product p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin DESC;



-- Top 5 revenue by months
SELECT 
TO_CHAR(created_at,'Mon') AS month,
ROUND(SUM(price_usd)::numeric,2) AS revenue
FROM order_items
GROUP BY month, DATE_PART('month',created_at)
ORDER BY revenue DESC
LIMIT 5;

--Refund rate by product
SELECT 
p.product_name,
ROUND(
(SUM(r.refund_amount_usd) / SUM(oi.price_usd) * 100)::numeric
,2) AS refund_rate
FROM order_items oi
JOIN product p
ON oi.product_id = p.product_id
LEFT JOIN order_item_refunds r
ON oi.order_item_id = r.order_item_id
GROUP BY p.product_name
ORDER BY refund_rate DESC;

--Average Profit per order
select 
round(Avg(price_usd - cogs_usd)::numeric,2) AS Avg_Profit_per_order
from order_items;














