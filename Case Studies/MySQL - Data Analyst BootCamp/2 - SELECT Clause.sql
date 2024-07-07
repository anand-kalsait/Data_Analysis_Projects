-- SELECT Statement for all columns/attributes
SELECT * 
FROM employee_demographics;

-- SELECT Statement for specific columns/attributes
SELECT 
	first_name,
    last_name,
    birth_date
FROM employee_demographics;

-- DISTINCT in SELECT 
SELECT DISTINCT first_name, gender
FROM employee_demographics;

