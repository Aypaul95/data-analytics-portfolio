--Stores customer profile information

CREATE TABLE customers(
customer_id INT PRIMARY KEY,
signup_date DATE,
country VARCHAR(50),
industry VARCHAR(50),
acquisition_channel VARCHAR(50),
customer_type VARCHAR(20),
age_group VARCHAR(20),
)

---- Tracks billing and plan history

CREATE TABLE subcriptions(
subscription_id INT PRIMARY KEY,
customer_id INT,
plan_name VARCHAR(50),
plan_price DECIMAL(10,2),
billing_cycle VARCHAR(20), -- Monthly/Annual
subscription_start DATE,
subscription_end DATE,
status VARCHAR(20),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
)

---- Tracks product usage behavior

CREATE TABLE usage(
usage_id INT PRIMARY KEY,
customer_id INT,
usage_date DATE,
session_count INT,     -- Number of logins
avg_session_duration_min DECIMAL(5,2), -- Avg session length
feature_clicks INT,
data_consumed_mb DECIMAL(5,2),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
)

---- Track churn events

CREATE TABLE churn(
churn_id INT PRIMARY KEY,
customer_id INT,
churn_date DATE,
churn_reason VARCHAR(100), -- Price, Support, Competition
churn_type VARCHAR(20),    -- Voluntary/Involuntary
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
)
