--1: TOTAL CUSTOMERS
--Business Question

--How many customers do we currently have?

-- This query counts the total number of unique customers
-- It is used to show Total Customers in Power BI (Card visual)

-- Start of query

SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM customers;

-- End of query

--2: TOTAL CHURNED CUSTOMERS
--Business Question

--How many customers have churned?

-- This query counts customers who have a churn record
-- Each row in the churn table represents a churn event

-- start of query

SELECT 
    COUNT(DISTINCT customer_id) AS churned_customers
FROM churn;

-- end of query

--3.OVERALL CHURN RATE
--Business Question

--What percentage of customers left?

-- Step 1: Count total customers
-- Step 2: Count churned customers
-- Step 3: Divide churned by total and convert to percentage

-- start of query

SELECT
    (COUNT(DISTINCT ch.customer_id) * 100.0)
    /
    COUNT(DISTINCT c.customer_id) AS churn_rate_percentage
FROM customers c
LEFT JOIN churn ch
    ON c.customer_id = ch.customer_id;

-- end of query

--4: MONTHLY CHURN TREND
--Business Question

--Is churn increasing or decreasing over time?

-- DATEPART extracts the year and month from churn_date
-- This allows us to track churn month by month

-- start of query

SELECT
    YEAR(churn_date) AS churn_year,
    MONTH(churn_date) AS churn_month,
    COUNT(DISTINCT customer_id) AS churned_customers
FROM churn
GROUP BY 
    YEAR(churn_date),
    MONTH(churn_date)
ORDER BY 
    churn_year,
    churn_month;

-- end of query

--5.CHURN BY SUBSCRIPTION PLAN
--Business Question

--Which plan has the highest churn?

-- Join churn with subscriptions to know
-- which plan each churned customer was on

-- start of query

SELECT
    s.plan_name,
    COUNT(DISTINCT c.customer_id) AS churned_customers
FROM churn c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
GROUP BY s.plan_name
ORDER BY churned_customers DESC;

--end of query

--6 CUSTOMER COHORT (SIGNUP MONTH)
--Business Question

--When did customers originally join?

-- This query groups customers by the month they signed up
-- Used for cohort analysis

-- start of query

SELECT
    YEAR(signup_date) AS signup_year,
    MONTH(signup_date) AS signup_month,
    COUNT(customer_id) AS customers_signed_up
FROM customers
GROUP BY
    YEAR(signup_date),
    MONTH(signup_date)
ORDER BY
    signup_year,
    signup_month;

--end of query

--7.RETENTION COHORT MATRIX
--Business Question

--How long do customers stay active after signup?
 
 -- Step 1: Assign each customer to a cohort (signup month)
-- Step 2: Track their activity month
-- Step 3: Count active customers per cohort

-- start of query

WITH customer_cohort AS (
    SELECT
        customer_id,
        DATEFROMPARTS(YEAR(signup_date), MONTH(signup_date), 1) AS cohort_month
    FROM customers
),
usage_activity AS (
    SELECT
        customer_id,
        DATEFROMPARTS(YEAR(usage_date), MONTH(usage_date), 1) AS activity_month
    FROM usage
)
SELECT
    c.cohort_month,
    u.activity_month,
    COUNT(DISTINCT u.customer_id) AS active_customers
FROM customer_cohort c
JOIN usage_activity u
    ON c.customer_id = u.customer_id
GROUP BY
    c.cohort_month,
    u.activity_month
ORDER BY
    c.cohort_month,
    u.activity_month;

-- end of query

--8. AVERAGE USAGE BEFORE CHURN
--Business Question

--Do customers reduce usage before churning?

-- This query calculates average usage for churned customers
-- Low values usually indicate disengagement before churn

-- start of query

SELECT
    u.customer_id,
    AVG(u.session_count) AS avg_sessions,
    AVG(u.avg_session_duration_min) AS avg_session_duration
FROM usage u
JOIN churn c
    ON u.customer_id = c.customer_id
GROUP BY u.customer_id;

-- end of query

--9: USAGE SEGMENT VS CHURN
--Business Question

--Which usage group churns the most?

-- Step 1: Calculate average sessions per customer
-- Step 2: Group customers into usage categories

--start of query

WITH avg_usage AS (
    SELECT
        customer_id,
        AVG(session_count) AS avg_sessions
    FROM usage
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN avg_sessions < 5 THEN 'Low Usage'
        WHEN avg_sessions BETWEEN 5 AND 15 THEN 'Medium Usage'
        ELSE 'High Usage'
    END AS usage_segment,
    COUNT(*) AS churned_customers
FROM avg_usage a
JOIN churn c
    ON a.customer_id = c.customer_id
GROUP BY
    CASE
        WHEN avg_sessions < 5 THEN 'Low Usage'
        WHEN avg_sessions BETWEEN 5 AND 15 THEN 'Medium Usage'
        ELSE 'High Usage'
    END;

-- end of query

--10 TOP CHURN REASONS
--Business Question

--Why are customers leaving?

-- This query shows the most common churn reasons
-- Helps product and support teams take action

-- start of query

SELECT
    churn_reason,
    COUNT(*) AS churn_count
FROM churn
GROUP BY churn_reason
ORDER BY churn_count DESC;

-- end of query
