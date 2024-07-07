-- SubQueries
-- In WHERE Clause
SELECT * 
FROM employee_demographics
WHERE employee_id IN (
						SELECT employee_id
						FROM employee_salary
						WHERE dept_id = 1
);

-- In SELECT Clause
SELECT 
	first_name, salary, 
    (SELECT AVG(salary) FROM employee_salary) AS avg_salary,
	ABS(salary - (SELECT AVG(salary) FROM employee_salary)) AS diff_sal_avg_sal,
    CASE
		WHEN salary - (SELECT AVG(salary) FROM employee_salary) < 0 THEN 'Less Than Avg'
        WHEN salary - (SELECT AVG(salary) FROM employee_salary) > 0 Then 'More Than Avg'
	END AS Verdict
FROM employee_salary;

-- In FROM Clause
SELECT gender, AVG(age), MIN(age), MAX(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT AVG(max_age)
FROM (
	SELECT 
		gender, 
        AVG(age) AS avg_age,
        MIN(age) AS min_age, 
        MAX(age) AS max_age, 
        COUNT(age) AS count_age
	FROM employee_demographics
	GROUP BY gender
) AS LOL;