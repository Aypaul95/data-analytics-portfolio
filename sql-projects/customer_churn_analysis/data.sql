---- insert Values into cutomers table
WITH numbers AS (
    SELECT TOP (1000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO customers
SELECT
    n AS customer_id,
    DATEADD(DAY, -n * 3, GETDATE()) AS signup_date,
    CASE
        WHEN n <= 400 THEN 'Nigeria'
        WHEN n <= 700 THEN 'United States'
        ELSE 'United Kingdom'
    END AS country,
    CASE
        WHEN n % 3 = 0 THEN 'Fintech'
        WHEN n % 3 = 1 THEN 'E-commerce'
        ELSE 'Education'
    END AS industry,
    CASE
        WHEN n <= 300 THEN 'Paid Ads'
        WHEN n <= 600 THEN 'Referral'
        ELSE 'Organic'
    END AS acquisition_channel,
    CASE
        WHEN n % 2 = 0 THEN 'Business'
        ELSE 'Individual'
    END AS customer_type,
    CASE
        WHEN n <= 250 THEN '18-25'
        WHEN n <= 500 THEN '26-35'
        WHEN n <= 750 THEN '36-45'
        ELSE '46+'
    END AS age_group
FROM numbers;

SELECT *
FROM customer_churn_analysis.dbo.customers

---- Insert values into subscriptions table

INSERT INTO subscriptions
SELECT
    customer_id AS subscription_id,
    customer_id,
    CASE
        WHEN customer_id <= 300 THEN 'Free'
        WHEN customer_id <= 650 THEN 'Basic'
        ELSE 'Pro'
    END AS plan_name,
    CASE
        WHEN customer_id <= 300 THEN 0
        WHEN customer_id <= 650 THEN 29.99
        ELSE 99.99
    END AS plan_price,
    CASE
        WHEN customer_id % 2 = 0 THEN 'Monthly'
        ELSE 'Annual'
    END AS billing_cycle,
    signup_date,
    NULL,
    'Active'
FROM customers;

SELECT *
FROM customer_churn_analysis.dbo.subscriptions

---- Insert values into usage table

WITH usage_numbers AS (
    SELECT TOP (5000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO usage
SELECT
    n AS usage_id,
    ((n - 1) % (SELECT COUNT(*) FROM customers)) + 1 AS customer_id,
    DATEADD(DAY, - (n % 365), GETDATE()) AS usage_date,
    CASE
        WHEN ((n - 1) % (SELECT COUNT(*) FROM customers)) + 1 <= 300 THEN 1 + (n % 3)
        WHEN ((n - 1) % (SELECT COUNT(*) FROM customers)) + 1 <= 650 THEN 5 + (n % 6)
        ELSE 20 + (n % 15)
    END AS session_count,
    CASE
        WHEN ((n - 1) % (SELECT COUNT(*) FROM customers)) + 1 <= 300 THEN 2.5
        WHEN ((n - 1) % (SELECT COUNT(*) FROM customers)) + 1 <= 650 THEN 12.5
        ELSE 45.0
    END AS avg_session_duration_min,
    CASE
        WHEN ((n - 1) % (SELECT COUNT(*) FROM customers)) + 1 <= 300 THEN 5
        WHEN ((n - 1) % (SELECT COUNT(*) FROM customers)) + 1 <= 650 THEN 30
        ELSE 120
    END AS feature_clicks,
    CASE
        WHEN ((n - 1) % (SELECT COUNT(*) FROM customers)) + 1 <= 300 THEN 50
        WHEN ((n - 1) % (SELECT COUNT(*) FROM customers)) + 1 <= 650 THEN 500
        ELSE 2500
    END AS data_consumed_mb
FROM usage_numbers;

SELECT *
FROM customer_churn_analysis.dbo.usage

-- Insert values into churn table

INSERT INTO churn
SELECT
    customer_id AS churn_id,
    customer_id,
    DATEADD(DAY, -customer_id, GETDATE()) AS churn_date,
    CASE
        WHEN customer_id <= 300 THEN 'Poor Engagement'
        WHEN customer_id <= 650 THEN 'Pricing'
        ELSE 'Moved to Competitor'
    END AS churn_reason,
    CASE
        WHEN customer_id % 4 = 0 THEN 'Involuntary'
        ELSE 'Voluntary'
    END AS churn_type
FROM customers
WHERE customer_id <= 420; -- 42% churn rate (realistic + visible)

SELECT *
FROM customer_churn_analysis.dbo.churn
