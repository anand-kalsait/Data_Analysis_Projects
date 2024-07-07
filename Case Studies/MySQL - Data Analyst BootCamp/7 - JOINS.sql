-- JOINS

SELECT * 
FROM employee_demographics;

SELECT * 
FROM employee_salary;

-- INNER JOIN
SELECT * 
FROM employee_demographics AS ed
INNER JOIN 
	employee_salary AS es
	ON ed.employee_id = es.employee_id;

-- OUTER JOINS --
-- LEFT JOIN
SELECT *
FROM employee_demographics AS ed
LEFT JOIN 
	employee_salary AS es
	ON ed.employee_id = es.employee_id;

-- RIGHT JOIN
SELECT *
FROM employee_demographics AS ed
RIGHT JOIN 
	employee_salary AS es
	ON ed.employee_id = es.employee_id;
    
-- FULL JOIN
SELECT *
FROM employee_demographics AS ed
LEFT JOIN 
	employee_salary AS es
	ON ed.employee_id = es.employee_id
UNION
SELECT *
FROM employee_demographics AS ed
RIGHT JOIN 
	employee_salary AS es
	ON ed.employee_id = es.employee_id;
    
-- SELF JOIN
SELECT 
	es1.employee_id, es1.first_name, es1.last_name,
	es2.employee_id, es2.first_name, es2.last_name 
FROM employee_salary AS es1
JOIN 
	employee_salary AS es2
    ON es1.employee_id + 1 = es2.employee_id;
    
-- Joining multiple Tables
SELECT * 
FROM employee_demographics AS ed
INNER JOIN 
	employee_salary AS es
	ON ed.employee_id = es.employee_id
INNER JOIN
	parks_departments AS pd
    ON es.dept_id = pd.department_id;
