--1. Monthly Payroll Cost Analysis

--Business Question:

--How much does the company spend on payroll every month?

--What You’re Showing

--How to work with dates

--How to aggregate money

--Real payroll reporting logic

-- Start query

-- We want to group salaries by month
-- SQL Server does NOT have DATETRUNC like Postgres
-- So we use YEAR() and MONTH()

SELECT
    YEAR(pay_period_start) AS pay_year,     -- Extract year from date
    MONTH(pay_period_start) AS pay_month,   -- Extract month from date
    SUM(net_pay) AS total_payroll_cost      -- Total salary paid
FROM payroll
WHERE payment_status = 'Paid'               -- Only successful payments
GROUP BY
    YEAR(pay_period_start),
    MONTH(pay_period_start)
ORDER BY
    pay_year,
    pay_month;

-- End of query


--2. Payroll Cost by Department

--Business Question:

--Which departments cost the most to maintain?

--What You’re Showing

--Multi-table JOINs

--Cost breakdown logic

--Business prioritization

-- Start of query

-- Join payroll with employees and departments
-- This lets us connect salary data to departments

SELECT
    d.department_name,
    SUM(p.net_pay) AS department_payroll
FROM payroll p
JOIN employees e
    ON p.employee_id = e.employee_id      -- Link payroll to employee
JOIN departments d
    ON e.department_id = d.department_id  -- Link employee to department
WHERE p.payment_status = 'Paid'
GROUP BY d.department_name
ORDER BY department_payroll DESC;          -- Highest cost first

-- End of query


--3. Average Salary by Job Role

--Business Question:

--How much does each role earn on average?

--What You’re Showing

--Salary benchmarking

--Role-based compensation analysis

-- Start of query

-- Average salary analysis by role
-- Very common HR analytics query

SELECT
    j.job_title,
    AVG(p.base_salary) AS avg_base_salary
FROM payroll p
JOIN employees e
    ON p.employee_id = e.employee_id
JOIN job_roles j
    ON e.job_role_id = j.job_role_id
WHERE p.payment_status = 'Paid'
GROUP BY j.job_title
ORDER BY avg_base_salary DESC;

-- End of query


--4. Gender Pay Gap Analysis

--Business Question:

--Are male and female employees paid fairly?

--What You’re Showing

--Equity analysis

--HR compliance awareness

--In Power BI, this becomes a bar chart or KPI card.

-- Start of query

-- Gender pay comparison
-- This is very important for HR compliance

SELECT
    e.gender,
    AVG(p.base_salary) AS avg_salary
FROM payroll p
JOIN employees e
    ON p.employee_id = e.employee_id
WHERE p.payment_status = 'Paid'
GROUP BY e.gender;

--  End of query


--5. Salary Equity Using Window Functions

--Business Question:

--How does an employee’s salary compare to others in the same department?

--What You’re Showing

--Advanced SQL skill

--Salary fairness logic

--High-value HR analytics

-- Start of query

-- Window functions let us compare rows without collapsing data
-- AVG() OVER() calculates department average salary

SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    p.base_salary,
    AVG(p.base_salary) OVER (
        PARTITION BY d.department_name
    ) AS department_avg_salary,
    p.base_salary -
    AVG(p.base_salary) OVER (
        PARTITION BY d.department_name
    ) AS salary_difference
FROM payroll p
JOIN employees e
    ON p.employee_id = e.employee_id
JOIN departments d
    ON e.department_id = d.department_id
WHERE p.payment_status = 'Paid';

-- End of query


--6. Overtime Cost Analysis

--Business Question:

--Which departments rely heavily on overtime?

--What You’re Showing

--Cost control analysis

--Workforce efficiency insights

-- start of query
-- Overtime is extra cost to the company
-- We analyze overtime by department

SELECT
    d.department_name,
    SUM(p.overtime_pay) AS total_overtime_cost
FROM payroll p
JOIN employees e
    ON p.employee_id = e.employee_id
JOIN departments d
    ON e.department_id = d.department_id
WHERE p.overtime_pay > 0
GROUP BY d.department_name
ORDER BY total_overtime_cost DESC;

-- End of query

--7. Detect Payroll Issues (Data Quality Check)

--Business Question:

--Are there payroll errors or delays?

--What You’re Showing

--Attention to data quality

--Operational problem-solving

-- start of query

-- Identify problematic payroll records
-- Very realistic HR startup scenario

SELECT
    payroll_id,
    employee_id,
    net_pay,
    payment_status,
    payment_date
FROM payroll
WHERE
    net_pay <= 0                    -- Invalid salary
    OR payment_status <> 'Paid'     -- Pending or failed payment
    OR payment_date IS NULL;        -- Missing payment date

    -- End of query


--8. Contract vs Full-Time Salary Comparison

--Business Question:

--Do contract staff cost more than full-time employees?

--What You’re Showing

--Workforce cost strategy

--Strategic HR insights

-- start of query

-- Compare salary by employment type

SELECT
    e.employment_type,
    AVG(p.net_pay) AS avg_net_pay
FROM payroll p
JOIN employees e
    ON p.employee_id = e.employee_id
WHERE p.payment_status = 'Paid'
GROUP BY e.employment_type;

-- End of query
