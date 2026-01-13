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

CREATE TABLE employee_status_history(
status_id INT PRIMARY KEY,
employee_id INT,
status VARCHAR(30), -- PROBATION/ CONFIRMED/SUSPENDED
status_start_date DATE,
status_end_date DATE
)

CREATE TABLE terminations(
termination_id INT PRIMARY KEY,
employee_id INT,
termination_date DATE,
termination_type VARCHAR(30), -- RESIGNATION/ LAYOFF/ TERMINATION
termination_reason VARCHAR(100)
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
SELECT *
FROM Employee_Attrition_Retention_Analysis.dbo.employees
