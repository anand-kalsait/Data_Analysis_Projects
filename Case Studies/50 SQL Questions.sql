USE db_sql_tutorial;

SELECT * 
FROM customers;

SELECT *
FROM orders;

SELECT first_name, country
FROM customers;

SELECT DISTINCT country
FROM customers;

SELECT *
FROM customers
ORDER BY score ASC;

SELECT *
FROM customers
ORDER BY score DESC;

SELECT *
FROM customers
ORDER BY country ASC, score DESC; 

SELECT *
FROM customers
WHERE country = "Germany";

SELECT * 
FROM customers
WHERE score >500;

SELECT * 
FROM customers
WHERE score < 500;

SELECT * 
FROM customers
WHERE score <= 500;

SELECT *
FROM customers
WHERE score >= 500;

SELECT *
FROM customers
WHERE country != "Germany";

SELECT *
FROM customers
WHERE country = 'Germany' AND score < 500;

SELECT *
FROM customers
WHERE country = "Germany" OR score < 500;

SELECT * 
FROM customers
WHERE NOT score < 400;

SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500;

SELECT * 
FROM customers
WHERE customer_id IN (1,2,5);

SELECT *
FROM customers
WHERE first_name LIKE "M%";

SELECT *
FROM customers
WHERE first_name LIKE "%n";

SELECT *
FROM customers
WHERE first_name LIKE "%r%";

SELECT * 
FROM customers
WHERE first_name LIKE "__r%";

SELECT 
	c.customer_id, c.first_name, 
	o.order_id, o.quantity
FROM customers AS c
INNER JOIN orders as o
ON c.customer_id = o.customer_id;

SELECT 
	c.customer_id, c.first_name,
	o.order_id, o.quantity
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id;

SELECT
	c.customer_id, c.first_name,
    o.order_id, o.quantity
FROM customers AS c
RIGHT JOIN orders AS o
ON c.customer_id = o.customer_id;


SELECT 
	c.customer_id, c.first_name,
    o.order_id, o.quantity
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
UNION
SELECT 
	c.customer_id, c.first_name,
	o.order_id, o.quantity
FROM customers AS c
RIGHT JOIN orders AS o
ON c.customer_id = o.customer_id;

SELECT first_name, last_name, country
FROM customers
UNION ALL /*ALL will give duplicates*/
SELECT first_name, last_name, emp_country
FROM employees;

SELECT first_name, last_name, country
FROM customers
UNION  /*not including ALL will give unique*/
SELECT first_name, last_name, emp_country
FROM employees;

SELECT COUNT(customer_id) AS total_customers
FROM customers;

SELECT SUM(quantity) AS total_quantity
FROM orders;

SELECT AVG(quantity) AS avg_quantity
FROM orders;

SELECT AVG(score) AS avg_score
FROM customers;

SELECT MAX(score) AS max_score
FROM customers;

SELECT CONCAT(first_name," ", last_name) as full_name
FROM customers;

SELECT UPPER(first_name) AS uc_first_name
FROM customers;

SELECT 
	last_name,
	TRIM(last_name) AS clean_last_name, /*TRIM is used to trim white spaces*/
    LENGTH(last_name) AS len_last_name,
    LENGTH(TRIM(last_name)) AS len_last_name
FROM customers;

SELECT 
	TRIM(last_name) AS clean_last_name,
    SUBSTRING(TRIM(last_name), 2, 3) AS sub_last_name
FROM customers;

SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country;

SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers ASC;

SELECT country, MAX(score) AS highest_score
FROM customers
GROUP BY country;

SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country
HAVING total_customers > 1;

SELECT * 
FROM orders
WHERE customer_id IN 
(
	SELECT customer_id 
	FROM customers
	WHERE score > 500
);

SELECT *
FROM orders AS o
WHERE EXISTS 
(	
	SELECT 1 
    FROM customers AS c 
    WHERE c.customer_id = o.customer_id AND score > 500
);

DESCRIBE customers;
INSERT INTO customers
VALUES
(DEFAULT, "Anna", "Nixon", "UK",NULL);

SELECT * FROM customers;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM customers
WHERE customer_id IN (9,10); 

INSERT INTO customers
(first_name, last_name)
VALUES('Max', 'Lang');

UPDATE customers
SET country = 'Germany'
WHERE customer_id = 10;

UPDATE customers
SET country = 'USA',score = 100
WHERE customer_id = 9;

CREATE TABLE persons
(
	person_id INT PRIMARY KEY,
    person_name VARCHAR(20) NOT NULL,
    birth_date DATE,
    phone_no VARCHAR(15) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS persons;

DESCRIBE persons;
SELECT * FROM persons;

ALTER TABLE persons
ADD COLUMN email VARCHAR(25) NOT NULL UNIQUE;