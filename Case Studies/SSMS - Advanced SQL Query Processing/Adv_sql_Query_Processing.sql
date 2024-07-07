SELECT * 
FROM Staff;

SELECT *
FROM Staff
Inner JOIN 
Staff_Roles
ON 1=1;


SELECT *
FROM Animals AS A 
LEFT JOIN Adoptions AS AD
ON AD.Name = A.Name AND AD.Species = A.Species;

SELECT *
FROM 
	Animals AS A
	LEFT JOIN 
		Adoptions AS AD
		INNER JOIN 
		Persons AS P
		ON P.Email = AD.Adopter_Email
	ON AD.Name = A.Name AND AD.Species = A.Species;




SELECT A.Name, A.Species, A.Breed, A.Primary_Color, V.Vaccination_Time, V.Vaccine, P.First_Name, P.Last_Name, SA.Role
FROM
	Animals AS A
	LEFT JOIN 
		Vaccinations AS V
		INNER JOIN 
			Staff_Assignments AS SA
			INNER JOIN 
			Persons AS P
			ON P.Email = SA.Email
		ON V.Email = P.Email
	ON A.Name = V.Name AND A.Species = V.Species
ORDER BY A.Name, A.Species, A.Breed, V.Vaccination_Time;

SELECT * 
FROM Animals 
WHERE Species = 'Dog' AND Breed <> 'Bullmastiff';

SELECT * 
FROM Animals 
WHERE Breed <> 'Bullmastiff' OR Breed IS NULL;

SELECT Breed, Species , COUNT(*) AS No_Animals
FROM Animals 
GROUP BY Species, Breed ;


SELECT YEAR(CURRENT_TIMESTAMP) - YEAR(Birth_Date) As Age,
	COUNT(*) AS No_Persons
FROM Persons
GROUP BY YEAR(Birth_Date);


SELECT Species, Name, COUNT(*) AS No_Vaccines
FROM Vaccinations
GROUP BY Species, Name
ORDER BY Species, No_Vaccines;

SELECT Adopter_Email,
	COUNT(*) AS No_Adoption
FROM Adoptions
WHERE Adopter_Email NOT LIKE '%@gmail.com'
GROUP BY Adopter_Email
HAVING COUNT(*) > 1
ORDER BY No_Adoption DESC;

SELECT * FROM Vaccinations;
SELECT * FROM Animals;


SELECT A.Name, A.Species, A.Primary_Color, A.Breed, COUNT(V.Vaccine) AS No_Vaccine
FROM Animals AS A
LEFT JOIN 
Vaccinations AS V
ON A.Name = V.Name AND A.Species = V.Species
WHERE A.Species <> 'Rabbit' AND (V.Vaccine <> 'Rabies' OR V.Vaccine IS NULL)
GROUP BY A.Species, A.Name, A.Primary_Color, A.Breed
HAVING MAX(V.Vaccination_Time) < '2019-10-01' OR MAX(V.Vaccination_Time) IS NULL
ORDER BY A.Species, A.Name;

SELECT * FROM Animals 
ORDER BY Name DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

SELECT *, (SELECT MAX(Adoption_Fee) FROM Adoptions) AS Max_fee,
	(((SELECT MAX(Adoption_Fee) FROM Adoptions) 
	- Adoption_Fee)*100)
	/(SELECT MAX(Adoption_Fee) FROM Adoptions) AS Discount_Percent

FROM Adoptions;

SELECT *,(
			SELECT MAX(Adoption_Fee)
			FROM Adoptions AS A2
			WHERE A2.Species = A1.Species
			) AS Max_Fee_Per_Species
FROM Adoptions AS A1;

SELECT COUNT(*)
FROM Persons;

SELECT *
FROM Adoptions;

SELECT DISTINCT P.*
FROM Persons AS P
INNER JOIN 
Adoptions AS A
ON P.Email = A.Adopter_Email;
------------------------OR-----------------------------
SELECT *
FROM Persons
WHERE Email IN (SELECT Adopter_Email FROM Adoptions);

SELECT *
FROM Persons AS P
WHERE EXISTS (
				SELECT NULL  -- BEST PRACTICE
				FROM Adoptions AS A
				WHERE A.Adopter_Email = P.Email
				);


SELECT Name, Species
FROM Animals AS A
WHERE NOT EXISTS (
					SELECT NULL
					FROM Adoptions AS AD
					WHERE A.Name = AD.Name AND A.Species = AD.Species
					);

SELECT DISTINCT A.Species, A.Breed
FROM Animals AS A
		LEFT JOIN 
		Adoptions AS AD
		ON A.Name = AD.Name AND A.Species = AD.Species 
WHERE AD.Name IS NUll;

SELECT Name, Species
FROM Animals
EXCEPT
SELECT Name, Species 
FROM Adoptions;

SELECT Species, Breed
FROM Animals
EXCEPT
SELECT A.Species, A.Breed
FROM Animals AS A
	INNER JOIN 
	Adoptions AS AD
	ON A.Name = AD.Name AND A.Species = AD.Species;


SELECT A1.Adopter_Email, A1.Adoption_Date,
		A1.Name AS Name1, A1.Species AS Species1,
		A2.Name AS Name2, A2.Species AS species2
FROM Adoptions AS A1
	INNER JOIN 
	Adoptions AS A2
	ON A1.Adopter_Email = A2.Adopter_Email
		AND 
		A1.Adoption_Date = A2.Adoption_Date
		AND 
		(	(A1.Name = A2.Name AND A1.Species > A2.Species)
		OR
			(A1.Name > A2.Name AND A1.Species = A2.Species)
		OR (A1.Name > A2.Name AND A1.Species <> A2.Species))
ORDER BY A1.Adopter_Email, A1.Adoption_Date;

