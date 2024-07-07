-- WITH Clause CTEs
SELECT  AVG(avg_sal)
FROM (
		SELECT gender, 
		AVG(salary) AS avg_sal, 
		MAX(salary) AS max_sal, 
		MIN(salary) AS min_sal, 
		COUNT(salary) AS count_sal
		FROM employee_demographics AS ed
		INNER JOIN 
			employee_salary AS es 
			ON ed.employee_id = es.employee_id
		GROUP BY gender
		) AS CTE_Example;

WITH CTE_Example (gender, avg_sal, max_sal, min_sal, count_sal) AS (
					SELECT gender, AVG(salary), 
                    MAX(salary), MIN(salary),
                    COUNT(salary)  
					FROM employee_demographics AS ed
					INNER JOIN 
						employee_salary AS es 
						ON ed.employee_id = es.employee_id
					GROUP BY gender				
					)
SELECT  *
FROM CTE_Example;

-- Multiple CTEs
WITH CTE_Example1 AS (
					SELECT employee_id, gender, birth_date 
					FROM employee_demographics
                    WHERE birth_date > '1985-01-01'
					),
	CTE_Example2 AS (
					SELECT employee_id, salary 
                    FROM employee_salary
                    WHERE salary > 50000
					)
SELECT  *
FROM CTE_Example1
INNER JOIN 
	CTE_Example2
    ON CTE_Example1.employee_id = CTE_Example2.employee_id;



