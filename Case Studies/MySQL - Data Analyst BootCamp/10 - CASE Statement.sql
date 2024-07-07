-- CASE Statement

SELECT 
	first_name, last_name, age,
    CASE
		WHEN age <= 30 THEN 'Young'
        WHEN age > 30 AND age < 45 THEN 'Mid' -- BETWEEN can also be used here
        WHEN age >= 45 THEN 'Old'
	END as age_stage
    FROM employee_demographics
    ORDER BY age;
    
-- Pay Increase and Bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- FInance = 10% Bonus
    
SELECT 
		es.first_name, es.last_name, es.salary,
		CASE
			WHEN es.salary < 50000 THEN es.salary*1.05
            WHEN es.salary > 50000 THEN es.salary*1.07
            ELSE es.salary
		END AS new_salary,
        CASE 
			WHEN pd.department_name = 'Finance' THEN es.salary*0.1
            ELSE 0
		END AS Bonus
    FROM employee_salary AS es
    INNER JOIN
		parks_departments AS pd
        ON es.dept_id = pd.department_id;
    