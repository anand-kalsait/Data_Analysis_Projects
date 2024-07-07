-- UNION Statement

-- here DISTINCT is default
SELECT first_name, last_name
FROM employee_demographics
UNION 
SELECT first_name, last_name
FROM employee_salary;

-- here ALL is used to get all records regardless of duplicates
SELECT first_name, last_name
FROM employee_demographics
UNION ALL 
SELECT first_name, last_name
FROM employee_salary
ORDER BY first_name;

SELECT first_name, last_name, 'Old MAn' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION 
SELECT first_name, last_name, 'High Pay' AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;