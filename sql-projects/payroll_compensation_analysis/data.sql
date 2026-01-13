--departments (Realistic HR Departments)

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

-- job_roles (African HR Reality)

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

--locations (Nigeria + Africa)

INSERT INTO locations (location_id, country, state, city) VALUES
(1, 'Nigeria', 'Lagos', 'Ikeja'),
(2, 'Nigeria', 'Abuja', 'Garki'),
(3, 'Nigeria', 'Oyo', 'Ibadan'),
(4, 'Ghana', 'Greater Accra', 'Accra'),
(5, 'Kenya', 'Nairobi County', 'Nairobi'),
(6, 'South Africa', 'Gauteng', 'Johannesburg');

--SELECT *
--FROM locations

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

--SELECT * 
--FROM employees

-- payroll (10000 payroll records)

WITH numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n <= 10000
)
INSERT INTO payroll (
    payroll_id,
    employee_id,
    pay_period_start,
    pay_period_end,
    base_salary,
    overtime_pay,
    bonuses,
    deductions,
    net_pay,
    payment_date,
    payment_status
)
SELECT
    n AS payroll_id,
    ((n - 1) % 1000) + 1 AS employee_id,
    DATEADD(MONTH, - (n % 12), DATEFROMPARTS(2024, 12, 1)),
    EOMONTH(DATEADD(MONTH, - (n % 12), DATEFROMPARTS(2024, 12, 1))),
    base_salary,
    overtime_pay,
    bonus,
    deduction,
    (base_salary + overtime_pay + bonus - deduction) AS net_pay,
    DATEADD(DAY, 2, EOMONTH(DATEADD(MONTH, - (n % 12), GETDATE()))),
    CASE WHEN n % 20 = 0 THEN 'Pending' ELSE 'Paid' END
FROM (
    SELECT
        n,
        -- Base salary depends on role level
        CASE
            WHEN n % 10 IN (1,2) THEN 180000
            WHEN n % 10 IN (3,4) THEN 250000
            WHEN n % 10 IN (5,6) THEN 400000
            ELSE 600000
        END AS base_salary,
        CASE WHEN n % 3 = 0 THEN 25000 ELSE 0 END AS overtime_pay,
        CASE WHEN n % 6 = 0 THEN 50000 ELSE 0 END AS bonus,
        CASE WHEN n % 8 = 0 THEN 15000 ELSE 5000 END AS deduction
    FROM numbers
) x
OPTION (MAXRECURSION 0);

--SELECT *
--FROM payroll

