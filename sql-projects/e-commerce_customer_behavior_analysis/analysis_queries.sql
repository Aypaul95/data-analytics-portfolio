--1.Total Revenue per Customer

--Business Question:

--“Which customers are generating the most revenue?”

-- Reason: Helps marketing & sales identify VIP customers for loyalty programs.

-- start of query
-- Total revenue per customer
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS total_orders,             -- How many orders the customer made
    SUM(o.total_amount) AS total_revenue          -- Total money spent by customer
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id     -- Join orders to customers
WHERE
    o.order_status = 'Completed'                  -- Only consider completed orders
GROUP BY
    c.customer_id, c.first_name, c.last_name
ORDER BY
    total_revenue DESC;                            -- Highest revenue first

-- end of query

--2.Repeat vs One-Time Buyers

--Business Question:

--“How many customers are one-time buyers vs repeat buyers?”
-- Reason: Helps retention strategy — who to target for repeat purchases.

-- start of query
-- Classify customers as one-time or repeat buyers

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count,
    CASE
        WHEN COUNT(o.order_id) = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END AS buyer_type
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    o.order_status = 'Completed'
GROUP BY
    c.customer_id, c.first_name, c.last_name
ORDER BY
    order_count DESC;

--end of query

--3.Top Products by Revenue

--Business Question:

--“Which products are generating the most revenue?”

-- Reason: Helps product managers decide which items to promote or restock.

-- start of query
-- Top products by total revenue
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.total_price) AS revenue,
    SUM(oi.quantity) AS total_units_sold
FROM
    order_items oi
JOIN
    products p ON oi.product_id = p.product_id
JOIN
    orders o ON oi.order_id = o.order_id
WHERE
    o.order_status = 'Completed'
GROUP BY
    p.product_id, p.product_name
ORDER BY
    revenue DESC;

-- end of query

--4.RFM Analysis (Recency, Frequency, Monetary)

--Business Question:

--“Which customers are most valuable based on purchase recency, frequency, and monetary value?”
-- Reasons:
--1.Identifies high-value customers

--2.Drives targeted promotions & VIP programs

--start of query
-- RFM metrics per customer
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    MAX(o.order_date) AS last_purchase_date,       -- Recency
    DATEDIFF(DAY, MAX(o.order_date), GETDATE()) AS recency_days,
    COUNT(o.order_id) AS frequency,               -- Frequency
    SUM(o.total_amount) AS monetary_value        -- Monetary
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    o.order_status = 'Completed'
GROUP BY
    c.customer_id, c.first_name, c.last_name
ORDER BY
    monetary_value DESC;

-- end of query

--5. Customer Lifetime Value (CLV)

--Business Question:

--“What is the estimated total revenue each customer will generate over time?”
-- Reason: Crucial for budgeting, retention campaigns, and understanding customer profitability.

-- start of query
-- Simple CLV calculation: sum of completed orders per customer
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    SUM(o.total_amount) AS lifetime_value
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    o.order_status = 'Completed'
GROUP BY
    c.customer_id, c.first_name, c.last_name
ORDER BY
    lifetime_value DESC;

-- end of query

--6.Revenue by Country & Product Category

--Business Question:

--“Which country and category combination generates the most revenue?”
-- Reason: Helps in regional marketing and inventory planning.

-- start of query
-- Revenue per country and product category
SELECT
    c.country,
    p.category,
    SUM(oi.total_price) AS total_revenue
FROM
    order_items oi
JOIN
    orders o ON oi.order_id = o.order_id
JOIN
    customers c ON o.customer_id = c.customer_id
JOIN
    products p ON oi.product_id = p.product_id
WHERE
    o.order_status = 'Completed'
GROUP BY
    c.country, p.category
ORDER BY
    total_revenue DESC;

-- end of query

--7.Payment Method Analysis

--Business Question:

--“Which payment methods are most popular and profitable?”
-- Reasons:
--1.Optimizes payment options

--2.Identifies potential issues with failed payments

--start of query
-- Revenue and usage count per payment method
SELECT
    p.payment_method,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_revenue
FROM
    orders o
JOIN
    payments p ON o.payment_id = p.payment_id
WHERE
    o.order_status = 'Completed'
GROUP BY
    p.payment_method
ORDER BY
    total_revenue DESC;

-- end of query


--8.Products with Most Quantity Sold

--Business Question:

--“Which products are purchased most often by quantity, not just revenue?”
-- Reason:Highlights best-selling products, regardless of price.

-- start of query
-- Products ranked by total quantity sold
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_units_sold
FROM
    order_items oi
JOIN
    products p ON oi.product_id = p.product_id
JOIN
    orders o ON oi.order_id = o.order_id
WHERE
    o.order_status = 'Completed'
GROUP BY
    p.product_id, p.product_name
ORDER BY
    total_units_sold DESC;

--end of query
