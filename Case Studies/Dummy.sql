DROP DATABASE IF EXISTS dummy;

CREATE DATABASE dummy;

USE dummy;

CREATE TABLE student(
	rollno INT PRIMARY KEY, 
	name VARCHAR(50), 
    marks INT NOT NULL, 
    grade VARCHAR(1), 
    city VARCHAR(20)
    );


INSERT INTO student
(rollno, name, marks, grade, city)
VALUES
(101, "anil", 78, "C", "PUNE"),
(102, "pratik", 93, "A", "MUMBAI"),
(103, "anand", 85, "B", "MUMBAI"),
(104, "sharad", 96, "A", "DELHI"),
(105, "shruti", 12, "F", "DELHI"),
(106, "prashant", 82, "B", "PUNE");


SELECT name, marks FROM student;
SELECT * FROM student;
SELECT DISTINCT city FROM student;

/*Where clause*/
SELECT * FROM student WHERE marks > 80;
SELECT * FROM student WHERE city = "MUMBAI";
SELECT * FROM student WHERE marks > 80 AND city = "MUMBAI"; 
SELECT * FROM student WHERE marks+10 > 100;
SELECT * FROM student WHERE marks > 80 OR city = "MUMBAI"; 
SELECT * FROM student WHERE marks BETWEEN 80 AND 90; 
SELECT * FROM student WHERE city IN ("PUNE","MUMBAI","RAJKOT"); 
SELECT * FROM student WHERE city NOT IN ("PUNE","MUMBAI","RAJKOT"); 

/*Limit clause*/
SELECT * FROM student WHERE marks > 50 LIMIT 2; 

/*Order by clause*/
SELECT * from student ORDER BY marks DESC LIMIT 3;
SELECT * from student WHERE city = "Pune" ORDER BY marks DESC  ;

/*Aggregate Functions*/
SELECT COUNT(rollno) FROM student;
SELECT MAX(marks) FROM student;
SELECT MIN(marks) FROM student;
SELECT AVG(marks) FROM student;
SELECT SUM(marks) FROM student; 

/*Group by clause*/
SELECT city, COUNT(rollno) 
FROM student 
GROUP BY city;

SELECT city, AVG(marks) 
FROM student 
GROUP BY city 
ORDER BY AVG(marks) ;

SELECT grade, count(rollno)
FROM student
GROUP BY grade
ORDER BY grade;

/*Having clause*/
SELECT city, COUNT(rollno)
FROM student
WHERE grade = "A"
GROUP BY city 
HAVING MAX(marks)>90
ORDER BY city DESC;

SET SQL_SAFE_UPDATES = 0;

UPDATE student
SET marks = 82, grade = "B"
WHERE marks BETWEEN 80 AND 90;

UPDATE student
SET grade = "O"
WHERE grade = "A";

DELETE FROM student
WHERE marks < 80;

ALTER TABLE student
ADD COLUMN age INT NOT NULL DEFAULT 19;

ALTER TABLE student
DROP COLUMN age;

ALTER TABLE student
CHANGE COLUMN full_name name VARCHAR(50);

ALTER TABLE student
MODIFY COLUMN age VARCHAR(2);

ALTER TABLE student
CHANGE COLUMN stud full_name VARCHAR(50);

ALTER TABLE student 
DROP COLUMN grade;

TRUNCATE TABLE student;

SELECT * FROM student; 

/*Subquery: GEt the names of all student who scored more than class average.*/
SELECT name, marks
FROM student
WHERE marks >
(SELECT AVG(marks)
FROM student);

/*Subquery: Find the names of all student with even roll numbers.*/
SELECT *
FROM student 
WHERE rollno IN 
(SELECT rollno 
FROM student 
WHERE rollno % 2 = 0);

/*Subquery: Find the max marks from the students of Delhi.*/
SELECT MAX(marks)
FROM (SELECT * FROM student WHERE city = "DELHI") AS temp;

/*Creating virtual tables from the original tables*/
CREATE VIEW v1 AS
SELEct rollno, name, marks FROM student;

SELECT * FROM v1;
