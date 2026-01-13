--1.Total Employees & Active Workforce

--Business Question:

--How many employees do we currently have, and how many are active?

--What this shows

--Basic aggregation

--Workforce size tracking

--HR reporting foundation

-- Start of query

-- Count total employees in the company
SELECT
    COUNT(*) AS total_employees
FROM employees;

-- Count only employees that are still active
SELECT
    COUNT(*) AS active_employees
FROM employees
WHERE status = 'Active';

-- End of query


--2. Attrition Rate Calculation

--Business Question:

--What percentage of employees have left the company?

--Explanation (Beginner Friendly)

--LEFT JOIN keeps all employees

--Employees without termination will show NULL

--HR uses this KPI monthly and yearly

-- Start of query

-- Attrition Rate = (Number of employees who left / Total employees) * 100

SELECT
    COUNT(t.employee_id) * 100.0 / COUNT(e.employee_id) AS attrition_rate_percentage
FROM employees e
LEFT JOIN terminations t
    ON e.employee_id = t.employee_id;

-- End of query

--3. Attrition by Department

--Business Question:

--Which departments are losing the most employees?

--What this shows

--High-risk departments

--Where HR should intervene

-- Start of query

-- Count number of exits per department

SELECT
    d.department_name,
    COUNT(t.employee_id) AS employees_left
FROM terminations t
JOIN employees e
    ON t.employee_id = e.employee_id
JOIN departments d
    ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY employees_left DESC;

-- End of query

--4. Average Tenure Before Exit

--Business Question:

--How long do employees stay before leaving?

--Explanation

--DATEDIFF calculates time difference

--Shows retention health

--Used by HR leadership

-- Start of query

-- Calculate how many months employees stayed before exiting

SELECT
    AVG(DATEDIFF(MONTH, e.hire_date, t.termination_date)) AS avg_tenure_months
FROM terminations t
JOIN employees e
    ON t.employee_id = e.employee_id;

-- End of query

--5. Early Attrition (First 6 Months)

--Business Question:

--Are new hires leaving too quickly?

--Why this matters

--Indicates bad hiring or onboarding

--Very expensive problem for companies

-- Start of query

-- Employees who left within 6 months of joining

SELECT
    COUNT(*) AS early_attrition_count
FROM terminations t
JOIN employees e
    ON t.employee_id = e.employee_id
WHERE DATEDIFF(MONTH, e.hire_date, t.termination_date) <= 6;

--End of query

--6. Attrition by Job Role

--Business Question:

--Which roles are hardest to retain?

--What this shows

--Talent scarcity

--Hiring & compensation signals

-- start of query

-- Count attrition by job role

SELECT
    j.job_title,
    COUNT(t.employee_id) AS employees_left
FROM terminations t
JOIN employees e
    ON t.employee_id = e.employee_id
JOIN job_roles j
    ON e.job_role_id = j.job_role_id
GROUP BY j.job_title
ORDER BY employees_left DESC;

-- End of query

--7. Voluntary vs Involuntary Attrition

--Business Question:

--Are employees resigning or being terminated?

-- Start of query

-- Compare resignation vs termination vs layoffs

SELECT
    termination_type,
    COUNT(*) AS exit_count
FROM terminations
GROUP BY termination_type;

-- End of query

--8.Employee Lifecycle Funnel

--Business Question:

--How many employees move from probation to confirmation?

--What this enables

--Funnel analysis

--Conversion from probation → confirmed

--Management dashboards

-- Start of query
-- Count employees by lifecycle status

SELECT
    status,
    COUNT(DISTINCT employee_id) AS employee_count
FROM employee_status_history
GROUP BY status;

-- End of query

--9. Time Spent on Probation

--Business Question:

--How long do employees remain on probation?

--Why this matters

--Compliance

--HR policy enforcement

-- Start of query

-- Calculate average probation duration in months

SELECT
    AVG(DATEDIFF(
        MONTH,
        status_start_date,
        status_end_date
    )) AS avg_probation_duration_months
FROM employee_status_history
WHERE status = 'Probation';

-- End of query

--10.Retention Cohort Analysis (Hire Year)

--Business Question:

--Which hiring years had the highest churn?

--What this shows

--Long-term retention trends

--Strategic hiring insights

-- start of query

-- Group attrition by hire year

SELECT
    YEAR(e.hire_date) AS hire_year,
    COUNT(t.employee_id) AS employees_left
FROM employees e
LEFT JOIN terminations t
    ON e.employee_id = t.employee_id
GROUP BY YEAR(e.hire_date)
ORDER BY hire_year;

-- End of query

