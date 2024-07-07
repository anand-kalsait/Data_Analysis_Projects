-- Window Function

SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics AS ed
INNER JOIN 
	employee_salary AS es
    ON ed.employee_id = es.employee_id
GROUP BY gender;

-- AVG()
SELECT 
	ed.first_name, ed.last_name, ed.gender,
	AVG(salary) OVER(PARTITION BY gender) AS avg_salary
FROM employee_demographics AS ed
INNER JOIN 
	employee_salary AS es
    ON ed.employee_id = es.employee_id;

-- SUM()    
SELECT 
	ed.first_name, ed.last_name, ed.gender, es.salary,
	SUM(salary) OVER(PARTITION BY gender ORDER BY ed.employee_id) AS rolling_total
FROM employee_demographics AS ed
INNER JOIN 
	employee_salary AS es
    ON ed.employee_id = es.employee_id;
    
-- ROW_NUMBER()
SELECT 
	ed.employee_id, ed.first_name, ed.last_name, ed.gender, es.salary,
    ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_number1,
    RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank1,
    DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank1
FROM employee_demographics AS ed
INNER JOIN 
	employee_salary AS es
    ON ed.employee_id = es.employee_id;