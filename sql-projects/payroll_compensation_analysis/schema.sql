CREATE TABLE employees(
employee_id INT PRIMARY KEY,
employee_code VARCHAR(20),
first_name VARCHAR(50),
last_name VARCHAR(50),
gender VARCHAR(10),
date_of_birth DATE,
hire_date DATE,
employment_type VARCHAR(20),
department_id INT,
job_role_id INT,
location_id INT,
status VARCHAR(20)
)

CREATE TABLE departments(
department_id INT PRIMARY KEY,
department_name VARCHAR(100)
)

CREATE TABLE job_roles(
job_role_id INT PRIMARY KEY,
job_title VARCHAR(100),
job_level VARCHAR(20)
)

CREATE TABLE locations(
location_id INT PRIMARY KEY,
country VARCHAR(50),
state VARCHAR(50),
city VARCHAR(50)
)

CREATE TABLE payroll(
payroll_id INT PRIMARY KEY,
employee_id INT,
pay_period_start DATE,
pay_period_end DATE,
base_salary DECIMAL(12,2),
overtime_pay DECIMAL(12,2),
bonuses DECIMAL(12,2),
deductions DECIMAL(12,2),
net_pay DECIMAL(12,2),
payment_date DATE,
payment_status VARCHAR(20)
)
