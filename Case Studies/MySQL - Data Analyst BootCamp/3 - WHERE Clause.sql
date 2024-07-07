-- WHERE Clause 
-- Arithmetic Operators
SELECT *
FROM employee_salary
WHERE first_name = 'Leslie';

SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM employee_salary
WHERE salary <= 50000;

SELECT *
FROM employee_demographics
WHERE gender <> 'Female';

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01';

-- Logical Operators
SELECT *
FROM employee_demographics
WHERE NOT gender = 'Male' OR birth_date > '1985-01-01';

SELECT *
FROM employee_demographics
WHERE NOT gender = 'Male' AND birth_date > '1985-01-01';

SELECT *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55;

-- LIKE Statement % and _
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a%';

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a___%';

SELECT *
FROM employee_demographics
WHERE birth_date LIKE '1989%';