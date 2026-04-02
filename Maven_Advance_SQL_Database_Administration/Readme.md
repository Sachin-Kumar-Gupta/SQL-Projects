# Maven Bear Builders – SQL Portfolio Projects

## Project Overview

This repository contains **two SQL projects** demonstrating database design, automation, and analytics for an e-commerce company, Maven Bear Builders.

- **Project 1: Core E-Commerce Database**
- **Project 2: Chat Support & Final Analytics**

The projects include tables, relationships, triggers, stored procedures, and analytical views. They are designed to showcase best practices in SQL, PL/pgSQL, and database modeling for professional portfolios.

---

## File Structure & Suggested Names

| File Name | Description |
|-----------|-------------|
| `01_ecommerce_schema.sql` | Core e-commerce database: orders, order_items, products, refunds, sessions, pageviews, triggers, and stored procedures for order aggregation. |
| `02_chat_support_analytics.sql` | Final project: chat support database, chat messages and sessions, stored procedures for reporting chat metrics, analytical views for monthly orders and website traffic. |
| `README.md` | Documentation for both projects, explaining the project context, objectives, tables, procedures, views, and usage examples. |

---

## Project 1 – Core E-Commerce Database

### Features

- **Tables**: `order_items`, `orders`, `products`, `order_item_refunds`, `website_sessions`, `website_pageviews`  
- **Triggers**: Automatically update aggregated `orders` table when new order items are inserted.  
- **Stored Procedures**: Compute total orders and revenue for a given date range.  
- **Data Integrity**: Primary keys and foreign keys ensure referential integrity.  
- **Analytics Ready**: Ready for reporting and dashboards.  

### Example Queries

-- Total orders and revenue
CALL order_performance('2013-11-01', '2013-12-31', NULL, NULL);

-- Check current orders
SELECT * FROM orders;

## Project 2 – Chat Support & Final Analytics
## Situation

Maven Bear Builders is adding chat support on the website. Additionally, potential acquirers require due diligence reports on orders, website traffic, and support interactions.

### Features
- **Tables**: users, chat_representative, chat_sessions, chat_messages
- **Stored Procedures**: Count chats handled by a representative in a date range.
- **Views**:
monthly_order: Monthly orders and revenue.
monthly_website_traffic: Monthly website session counts.
Integration: Foreign keys link chats with users, reps, and website sessions for complete traceability.

# Example Queries :

-- Chats handled by a rep

CALL support_rep_chat(1, '2023-01-01', '2023-01-31', NULL);

-- Monthly analytics

SELECT * FROM monthly_order;

SELECT * FROM monthly_website_traffic;

# Technologies Used
**PostgreSQL**
1. PL/pgSQL for triggers and stored procedures
2. SQL for queries, views, and aggregations
3. Future Enhancements
4. Row-level security for reporting users.
5. Chat response times and performance metrics.
6. Integration with BI tools (Tableau, Power BI) for visualization.
7. Advanced analytics combining orders, sessions, and chat interactions.

**Author:**  **Sachin Kumar Gupta**


**Portfolio:** sachin-kumar-gupta.github.io
