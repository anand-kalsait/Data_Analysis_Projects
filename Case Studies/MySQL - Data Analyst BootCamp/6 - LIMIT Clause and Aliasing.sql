-- LIMIT Clause 

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 1 OFFSET 2;

-- Aliasing with AS
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;