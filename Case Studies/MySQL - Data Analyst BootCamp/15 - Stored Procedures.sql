-- Stored Procedures

SELECT * 
FROM employee_salary
WHERE salary >= 50000;

CREATE PROCEDURE sal_mt_50k()
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

CALL sal_mt_50k();

-- Changing the DELIMITER to include all Queries in the PROCEDURE
DELIMITER $$
CREATE PROCEDURE weired_salaries()
BEGIN
	SELECT * 
	FROM employee_salary
	WHERE salary >= 50000
	ORDER BY salary;
	SELECT * 
	FROM employee_salary
	WHERE salary < 50000
	ORDER BY salary DESC;
END $$
DELIMITER ;

CALL weired_salaries();

-- PROCEDURE with Parameter
DELIMITER $$
CREATE PROCEDURE salaries(p_employee_id INT)
BEGIN
	SELECT salary
	FROM employee_salary
    WHERE employee_id = p_employee_id;
END $$
DELIMITER ;

CALL salaries(1);