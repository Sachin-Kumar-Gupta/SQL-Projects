--1. Overall Conversion Rate
SELECT
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND((COUNT(DISTINCT o.order_id) * 1.0 / COUNT(DISTINCT ws.website_session_id))*100,2) AS conversion_rate_pct
FROM website_sessions ws
LEFT JOIN orders o 
ON ws.website_session_id = o.website_session_id;

-- 2. Conversion Rate by Traffic Source
SELECT utm_source,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    Round((COUNT(DISTINCT o.order_id) * 1.0 / COUNT(DISTINCT ws.website_session_id))*100,2) AS conversion_rate_pct
FROM website_sessions ws
LEFT JOIN orders o 
ON ws.website_session_id = o.website_session_id
GROUP BY utm_source
ORDER BY conversion_rate_pct DESC;

-- 3. Revenue by Channel
select ws.utm_source, sum(o.price_usd) as revenue 
from order_items o
join website_sessions ws
on ws.website_session_id = o.website_session_id
group by ws.utm_source
order by 2 desc;
