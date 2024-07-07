-- String Functions
-- LENGTH()
SELECT length('sky');

SELECT first_name, length(first_name), last_name, length(last_name)
FROM employee_demographics
ORDER BY 2;

-- UPPER()
SELECT UPPER(first_name), UPPER(last_name)
FROM employee_demographics;

-- LOWER()
SELECT LOWER(first_name), LOWER(last_name)
FROM employee_demographics;

-- TRIM()
SELECT TRIM('      ALEX  ') AS Trimed_name;
SELECT LENGTH('ALEX');

-- LTRIM()
SELECT LTRIM('      ALEX  ') AS Trimed_name;

-- TRIM()
SELECT RTRIM('      ALEX  ') AS Trimed_name;

-- LEFT() and RIGHT() 
SELECT 
	first_name, LEFT(first_name, 3),
    last_name, RIGHT(last_name, 2)
FROM employee_demographics;

-- SUBSTRING()
SELECT 
	first_name, SUBSTR(first_name,3,2),
	birth_date, SUBSTRING(birth_date, 6,2) AS birth_month
FROM employee_demographics;

-- REPLACE()
SELECT first_name, REPLACE(first_name,'A', 'z') AS Replaced
FROM employee_demographics;

-- LOCATE()
SELECT LOCATE('d','Alexander');

SELECT first_name, LOCATE('An',first_name) AS Located
FROM employee_demographics;

-- CONCATE()
SELECT 
	first_name, last_name, 
	CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;