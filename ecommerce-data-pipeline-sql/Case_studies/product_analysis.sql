-- 1. Top Products by Revenue
select p.product_name, sum(o.price_usd) as revenue, count(o.order_item_id) AS total_sales
from products p
join order_items o
on p.product_id = o.product_id
group by p.product_name
order by 2 desc;

-- 2. Average Order Value (AOV)
select avg(price) as avg_order_value
from orders;

-- 3. Items per Order
select avg(no_of_items_purchased) AS avg_items_per_order
FROM orders;

-- 4. Monthly Revenue Trend
select extract(year from created_at) as year, extract(month from created_at) as month,
sum(price_usd) as revenue
from order_items
group by 1,2
order by 1,2;