--employees (1000 employees)

WITH numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n <= 1000
)
INSERT INTO employees (
    employee_id,
    employee_code,
    first_name,
    last_name,
    gender,
    date_of_birth,
    hire_date,
    employment_type,
    department_id,
    job_role_id,
    location_id,
    status
)
SELECT
    n AS employee_id,
    CONCAT('EMP', FORMAT(n, '0000')),
    CONCAT('First', n),
    CONCAT('Last', n),
    CASE WHEN n % 2 = 0 THEN 'Male' ELSE 'Female' END,
    DATEADD(YEAR, -25 - (n % 10), GETDATE()),
    DATEADD(DAY, - (n * 2), GETDATE()),
    CASE WHEN n % 5 = 0 THEN 'Contract' ELSE 'Full-time' END,
    (n % 8) + 1,
    (n % 10) + 1,
    (n % 6) + 1,
    'Active'
FROM numbers
OPTION (MAXRECURSION 0);

SELECT * 
FROM Employee_Attrition_Retention_Analysis.dbo.employees


--employee_status_history

--This tracks employee journey over time
--(Probation → Confirmed → Suspended)

-- Logic

--All employees start on Probation

--Most get Confirmed after 3–6 months

--A few get Suspended (disciplinary cases)


INSERT INTO employee_status_history (
    status_id,
    employee_id,
    status,
    status_start_date,
    status_end_date
)
-- 1️ PROBATION STAGE
SELECT
    ROW_NUMBER() OVER (ORDER BY employee_id) AS status_id,
    employee_id,
    'Probation' AS status,
    hire_date AS status_start_date,
    DATEADD(MONTH, 3, hire_date) AS status_end_date
FROM employees;

-- 2️ CONFIRMED STAGE
INSERT INTO employee_status_history (
    status_id,
    employee_id,
    status,
    status_start_date,
    status_end_date
)
SELECT
    10000 + ROW_NUMBER() OVER (ORDER BY employee_id),
    employee_id,
    'Confirmed',
    DATEADD(MONTH, 3, hire_date),
    NULL
FROM employees
WHERE employee_id % 6 <> 0;   -- Most employees get confirmed

-- 3️ SUSPENSION CASES (Few Employees)
INSERT INTO employee_status_history (
    status_id,
    employee_id,
    status,
    status_start_date,
    status_end_date
)
SELECT
    20000 + ROW_NUMBER() OVER (ORDER BY employee_id),
    employee_id,
    'Suspended',
    DATEADD(YEAR, 2, hire_date),
    DATEADD(YEAR, 2, DATEADD(MONTH, 1, hire_date))
FROM employees
WHERE employee_id % 25 = 0;   -- Very few cases

--SELECT *
--FROM Employee_Attrition_Retention_Analysis.dbo.employee_status_history


--2. terminations

--This captures employee exits (attrition)

--Logic

--~20–25% attrition (realistic)

--Mix of:

--Resignation

--Layoff

--Termination

--Exit reasons aligned with African HR reality

INSERT INTO terminations (
    termination_id,
    employee_id,
    termination_date,
    termination_type,
    termination_reason
)
SELECT
    ROW_NUMBER() OVER (ORDER BY employee_id) AS termination_id,
    employee_id,
    DATEADD(MONTH, 6 + (employee_id % 18), hire_date) AS termination_date,
    CASE
        WHEN employee_id % 3 = 0 THEN 'Resignation'
        WHEN employee_id % 5 = 0 THEN 'Layoff'
        ELSE 'Termination'
    END AS termination_type,
    CASE
        WHEN employee_id % 3 = 0 THEN 'Better job opportunity'
        WHEN employee_id % 5 = 0 THEN 'Company restructuring'
        ELSE 'Performance issues'
    END AS termination_reason
FROM employees
WHERE employee_id % 4 = 0;   -- About 25% attrition

SELECT *
FROM Employee_Attrition_Retention_Analysis.dbo.terminations


--3. Update employees table (status alignment)

--Real HR systems update employee status after exit.

UPDATE e
SET status = 'Terminated'
FROM employees e
JOIN terminations t
    ON e.employee_id = t.employee_id;


INSERT INTO departments (department_id, department_name) VALUES
(1, 'Engineering'),
(2, 'Human Resources'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Marketing'),
(6, 'Customer Support'),
(7, 'Operations'),
(8, 'Product Management');

--SELECT *
--FROM departments

---- job_roles (African HR Reality)

INSERT INTO job_roles (job_role_id, job_title, job_level) VALUES
(1, 'Software Engineer', 'Junior'),
(2, 'Software Engineer', 'Mid'),
(3, 'Software Engineer', 'Senior'),
(4, 'HR Officer', 'Mid'),
(5, 'HR Manager', 'Senior'),
(6, 'Accountant', 'Mid'),
(7, 'Sales Executive', 'Junior'),
(8, 'Sales Manager', 'Senior'),
(9, 'Customer Support Agent', 'Junior'),
(10, 'Product Manager', 'Senior');

--SELECT *
--FROM job_roles

