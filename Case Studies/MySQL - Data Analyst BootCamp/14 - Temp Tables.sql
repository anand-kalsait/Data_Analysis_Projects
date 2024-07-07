-- Temp Table
DROP TABLE IF EXISTS temp_table;
CREATE TEMPORARY TABLE temp_table(
first_name VARCHAR(50),
last_name VARCHAR(50),
Fav_game VARCHAR(100)
);

SELECT * FROM temp_table;

INSERT INTO temp_table
VALUES
('Alex','Mercer','Prototype'),
('Kratos','Loli','God of War'),
('Riche','Rich','Watch Dogs'),
('John','Wick','Babayaga');

SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k(
SELECT *
FROM employee_salary
WHERE salary >= 50000
ORDER BY salary
);

SELECT *
FROM salary_over_50k;