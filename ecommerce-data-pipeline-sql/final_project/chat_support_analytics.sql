/*
=========================================
SQL Project: Chat Support + Monthly Analytics
Author: Sachin Kumar Gupta
Description: Adds chat support tracking to the e-commerce DB.
Includes chat tables, stored procedures, and analytical views.
=========================================
*/

/*
The company is adding chat support to the website. You’ll need to design a database plan to track
which customers and sessions utilize chat, and which chat representatives serve each customer
*/
-- users 
	--- user_id, created_at, first_name, last_name
-- chat representative
	--- rep_id, created_at, first_name, last_name
-- chat sessions
	--- chat_sesson_id, created_at, user_id, rep_id, website_session_id
-- chat_messages
	--- chat_message_id, created_at, chat_session_id, user_id, rep_id, message

/*
Create the tables from your chat support tracking plan in the database, and include relationships to
existing tables where applicable
*/

-- 1. Users Table
create table users(
user_id bigint, 
created_at timestamp,
first_name varchar(50),
last_name varchar(50),
primary key (user_id)
);

-- 2. Chat Rep Table
create table chat_representative(
rep_id bigint, 
created_at timestamp,
first_name varchar(50),
last_name varchar(50),
primary key (rep_id)
);

-- 3. Chat Sessions Table
create table chat_sessions(
chat_session_id bigint, 
created_at timestamp,
user_id bigint,
rep_id bigint,
website_session_id bigint,
primary key (chat_sesson_id)
);

-- 4. Chat Message Table
create table chat_messages(
chat_message_id bigint, 
created_at timestamp,
chat_session_id bigint, 
user_id bigint, 
rep_id bigint, 
messages varchar(200),
primary key (chat_message_id)
);

-- 5. Stored Procedure: Count chats handled by a rep in a period
/*
Using the new tables, create a stored procedure to allow the CEO to pull a count of chats handled by
chat representative for a given time period, with a simple CALL statement which includes two dates
*/

create or replace procedure support_rep_chat(
in support_id bigint, in startdate date, in enddate date, out total_chats bigint
)
language plpgsql
as $$
begin
select count(chat_session_id)
from chat_sessions
where created_at::date between startdate and enddate
and  rep_id = support_id;
end;
$$;

/*
Create two Views for the potential acquiring company; one detailing monthly order volume and revenue,
the other showing monthly website traffic. Then create a new User, with access restricted to these Views
*/
-- 6. Monthly Order Volume & Revenue View
create or replace view monthly_order as(
select extract(year from created_at) as year, extract(month from created_at) as month,
count(order_id) as orders,sum(price_usd) as revenue
from order_items
group by 1,2
order by 1,2
);

select * from monthly_order;

-- 7. Monthly Website Traffic View
create or replace view monthly_website_traffic as(
select extract(year from created_at) as year, extract(month from created_at) as month,
count(website_session_id) as website_traffic
from website_sessions
group by 1,2
order by 1,2
);

select * from monthly_website_traffic;

-- 8. Create restricted user for reporting
CREATE ROLE investor WITH LOGIN PASSWORD 'investor';
GRANT USAGE ON SCHEMA public TO investor;
GRANT SELECT ON monthly_order, monthly_website_traffic TO investor;