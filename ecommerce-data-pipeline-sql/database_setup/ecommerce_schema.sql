/* 
=========================================
SQL Project: E-commerce Analytics Database
Author: Sachin Kumar Gupta
Description: This script creates order, product, refund, session, and pageview tables, 
populates sample data, sets up triggers, views, and stored procedures for analytics.
=========================================
*/

-- 1. Create order_items table
Create table order_items(
order_item_id bigint, 
created_at timestamp,
order_id bigint,
price_usd float,
cogs_usd float,
website_session_id bigint
);

-- Test row count
select count(*) as total_records from order_items;

-- 2. Creating refund data table
Create table order_item_refunds(
order_item_refund_id bigint, 
created_at timestamp,
order_item_id bigint,
order_id bigint,
refund_amount_usd float
);

-- Test row count
select * from order_item_refunds;

-- Deleting rows
delete from order_item_refunds
where order_item_id in ('131','132','145','151','153');

-- 3. Creating Product table
create table products(
product_id bigint,
created_at timestamp,
product_name varchar(50),
primary key (product_id)
);

insert into products values
(1,'2012-03-09 09:00:00','The Original Mr. Fuzzy'),
(2,'2013-01-06 13:00:00','TheForever Love Bear');

select * from products

-- 4. ading produc_id column to order_items table
alter table order_items
add product_id bigint;

-- 5. Updating product_id colum,no of order_items table
-- Set all product_id to 1 for existing records
update order_items
set product_id = 1
where order_id > 0;

select count(*) from order_items;

-- 6. Add foreign key to order_items
ALTER TABLE order_items
ADD CONSTRAINT order_items_product_id_fkey
FOREIGN KEY (product_id)
REFERENCES products(product_id);

-- 7. Update the structure of the order_items table. 
--Adding a binary column to the order_items table named as is_primary_item.
alter table order_items
add is_primary_item int;

--8. Updating all previous records in the order_items table, setting is_primary_item = 1 for all records.
update order_items
set is_primary_item = 1
where order_item_id >0;

--9. Adding two new products to the products table.
insert into products values
(3,'2013-12-12 09:00:00','The Birthday Sugar Panda'),
(4,'2014-02-05 10:00:00','The Hudson River Mini Bear');

/*
10. create a table to capture order_id, a created_at timestamp, website_session_id, 
primary product_id, # ofitems purchased, price and cogs in USD
*/
create table orders(
order_id bigint, 
created_at timestamp, 
website_session_id bigint, 
primary_product_id bigint, 
no_of_items_purchased bigint, 
price float,
cogs float
);

-- 11. Populate orders from order_items(back-populate the order table)
insert into orders
select 
order_id, min(created_at) as created_at, min(website_session_id) as website_session_id,
sum(case when is_primary_item = 1 then product_id else null end) as primary_product_id,
count(order_item_id) as no_of_items_purchased,
sum(price_usd) as price,
sum(cogs_usd) as cogs
from order_items
group by 1
order by 1;

select * from orders

-- 12. Trigger to auto-update orders table
CREATE OR REPLACE FUNCTION update_orders_after_insert()
RETURNS trigger AS $$
DECLARE
    created_at timestamp;
    website_session_id bigint;
    primary_product_id bigint;
    no_of_items_purchased bigint;
    price float;
    cogs float;
BEGIN
    -- Aggregate only for the affected order_id
    SELECT 
        MIN(oi.created_at),
        MIN(oi.website_session_id),
        MIN(CASE WHEN oi.is_primary_item = 1 THEN oi.product_id ELSE NULL END),
        COUNT(oi.order_item_id),
        SUM(oi.price_usd),
        SUM(oi.cogs_usd)
    INTO
        created_at,
        website_session_id,
        primary_product_id,
        no_of_items_purchased,
        price,
        cogs
    FROM order_items oi
    WHERE oi.order_id = NEW.order_id;

    -- Upsert into orders table
    INSERT INTO orders (
        order_id,
        created_at,
        website_session_id,
        primary_product_id,
        no_of_items_purchased,
        price,
        cogs
    ) VALUES (
        NEW.order_id,
        created_at,
        website_session_id,
        primary_product_id,
        no_of_items_purchased,
        price,
        cogs
    )
    ON CONFLICT (order_id)  --primary key order_id
    DO UPDATE SET
        created_at = EXCLUDED.created_at,
        website_session_id = EXCLUDED.website_session_id,
        primary_product_id = EXCLUDED.primary_product_id,
        no_of_items_purchased = EXCLUDED.no_of_items_purchased,
        price = EXCLUDED.price,
        cogs = EXCLUDED.cogs;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_new_order
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_orders_after_insert();

select count(*) from orders
select max(order_id) as max_order_id from order_items

-- 13. Create website_sessions table
create table website_sessions(
website_session_id bigint,
created_at timestamp,
user_id bigint,
is_repeat_session int,
utm_source varchar(50),
utm_campaign varchar(50),
utm_content varchar(50),
device_type varchar(50),
http_referer varchar(100),
Primary key (website_session_id));

-- 14. Create a view summarizing performance for January and February
create view monthly_session as(
select count(website_session_id) as number_of_session,
extract(year from created_at) as year, extract(month from created_at) as month, utm_source, utm_campaign
from website_sessions
group by 2,3,4,5
);

select * from monthly_session;

/*
15. Creating Storage Procedure to specify a startDate and endDate and 
see total orders and revenue during that period?
*/
create or replace procedure order_performance(
in startdate Date, in enddate Date, out total_orders bigint, out revenue numeric)
LANGUAGE plpgsql
AS $$
begin
select count(order_id) as total_orders,sum(price) as revenue
into total_orders, revenue
from orders
where date(created_at) between startdate and enddate;
end;
$$;

call order_performance('2013-11-01','2013-12-31',null,null)

--16. Creating Website Pageview table
create table website_pageviews(
website_pageview_id Bigint,
created_at timestamp,
website_session_id bigint,
pageview_url varchar(50),
primary key (website_pageview_id)
);

select count(*) as total_records from website_pageviews;
