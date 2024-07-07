USE master
GO

CREATE DATABASE Red30Tech
USE Red30Tech

SELECT * 
FROM Red30Tech.dbo.OnlineRetailSales$

SELECT *, (
	SELECT AVG([Order Total])
	FROM 
		[Red30Tech].[dbo].[OnlineRetailSales$]
) AS [Average]
FROM	
	Red30Tech.dbo.OnlineRetailSales$
WHERE [Order Total] > (
	SELECT AVG([Order Total])
	FROM 
		[Red30Tech].[dbo].[OnlineRetailSales$]
)
ORDER BY [Order Total]
---------------------------------------------------------------------------------------------
SELECT * FROM Red30Tech.dbo.SpeakerInfo$

SELECT * FROM Red30Tech.dbo.SessionInfo$

SELECT [Session Name], [Start Date], [End Date], [Room Name]
FROM [Red30Tech].[dbo].[SessionInfo$]
WHERE [Speaker Name] IN 
	(SELECT Name 
	FROM [Red30Tech].[dbo].[SpeakerInfo$]
	WHERE [Organization] = 'Two Trees Olive Oil')

-- OR

SELECT [Session Name], [Start Date], [End Date], [Room Name]
FROM [Red30Tech].[dbo].[SessionInfo$] AS SI
INNER JOIN (SELECT Name 
	FROM [Red30Tech].[dbo].[SpeakerInfo$]
	WHERE [Organization] = 'Two Trees Olive Oil') AS SP
ON SI.[Speaker Name] = SP.[Name]
-----------------------------------------------------------------------------------------
SELECT * FROM [Red30Tech].[dbo].[ConventionAttendees$]
SELECT * FROM [Red30Tech].[dbo].[OnlineRetailSales$]

SELECT [First Name], [Last Name], [State], [Email], [Phone Number]
FROM [Red30Tech].[dbo].[ConventionAttendees$] AS CA
WHERE NOT EXISTS
			(SELECT [CustState] FROM [Red30Tech].[dbo].[OnlineRetailSales$] AS ORS
			WHERE ORS.[CustState] = CA.[State])

-- OR

SELECT [First Name], [Last Name], [State], [Email], [Phone Number]
FROM [Red30Tech].[dbo].[ConventionAttendees$] AS CA
WHERE [State] NOT IN 
			(SELECT [CustState] FROM [Red30Tech].[dbo].[OnlineRetailSales$] AS ORS
			WHERE ORS.[CustState] = CA.[State])
ORDER BY CA.[First name]
-------------------------------------------------------------------------------------------------

SELECT * FROM [Red30Tech].[dbo].[Inventory$]

SELECT [ProdCategory], [ProdName], [ProdNumber], [In Stock]
FROM [Red30Tech].[dbo].[Inventory$]
WHERE [In Stock] < (SELECT AVG([In Stock]) FROM [Red30Tech].[dbo].[Inventory$])
-------------------------------------------------------------------------------------------------

WITH AVGTOTAL (AVG_TOTAL) AS 
						(SELECT AVG([Order Total]) AS AVG_TOTAL
						FROM [Red30Tech].[dbo].[OnlineRetailSales$]) 

SELECT * 
FROM [Red30Tech].[dbo].[OnlineRetailSales$], AVGTOTAL
WHERE [Order Total] >= AVG_TOTAL
ORDER BY [Order Total] ASC
---------------------------------------------------------------------------------------------------

WITH DirectReports AS 
					(SELECT [EmployeeId], [First Name],[Last Name], [Manager]
					FROM [Red30Tech].[dbo].[EmployeeDirectory$]
					WHERE [EmployeeID] = 42
					UNION ALL
					SELECT e.[EmployeeId], e.[First Name], e.[Last Name], e.[Manager]
					FROM [Red30Tech].[dbo].[EmployeeDirectory$] AS e
					INNER JOIN DirectReports AS d ON e.[Manager] = d.[EmployeeID])
SELECT COUNT(*) AS Direct_Reports
FROM DirectReports AS d
WHERE d.[EmployeeID] <> 42
----------------------------------------------------------------------------------------

SELECT * FROM [Red30Tech].[dbo].[Inventory$]

WITH AVGSTOCK (AVG_STOCK) AS (
							SELECT AVG([In Stock]) AS AVG_STOCK
							FROM [Red30Tech].[dbo].[Inventory$])
SELECT [ProdCategory], [ProdName], [ProdNumber], [In Stock],[AVG_STOCK]
FROM [Red30Tech].[dbo].[Inventory$], AVGSTOCK
WHERE [In Stock] < AVG_STOCK
-------------------------------------------------------------------------------------------------

SELECT [CustName], COUNT(DISTINCT[OrderNum]) AS [Order Number]
FROM [Red30Tech].[dbo].[OnlineRetailSales$]
GROUP BY CustName
ORDER BY [Order Number] DESC

SELECT [OrderNum],[OrderDate],[CustName], [ProdName], [Quantity],
ROW_NUMBER() OVER(PARTITION BY [CustName] ORDER BY [OrderDate] DESC) as ROW_NUM
FROM [Red30Tech].[dbo].[OnlineRetailSales$]

WITH ROWNUM AS (
				SELECT [OrderNum],[OrderDate],[CustName], [ProdName], [Quantity],
				ROW_NUMBER() OVER(PARTITION BY [CustName] ORDER BY [OrderDate] DESC) as ROW_NUM
				FROM [Red30Tech].[dbo].[OnlineRetailSales$])

SELECT * FROM ROWNUM WHERE ROW_NUM = 1
-----------------------------------------------------------------------------------------------
SELECT * FROM Red30Tech.dbo.OnlineRetailSales$ ORDER BY CustName

WITH BOEHM AS (
				SELECT [OrderNum],[OrderDate],[CustName],[ProdCategory],[ProdName],[Order Total],
				ROW_NUMBER() OVER(PARTITION BY ProdCategory ORDER BY [Order Total] DESC) AS BoehmPur
				FROM [Red30Tech].[dbo].[OnlineRetailSales$]
				WHERE [CustName] = 'Boehm Inc.')
SELECT [OrderNum],[OrderDate],[CustName],[ProdCategory],[ProdName],[Order Total] 
FROM BOEHM 
WHERE BoehmPur IN (1,2,3)
ORDER BY [ProdCategory],[Order Total] DESC
--------------------------------------------------------------------------------------------------

SELECT [Start Date], [End Date], [Session Name],
LAG([Session Name],1) OVER(ORDER BY [Start Date] ASC) AS PreviousSession,
LAG([Start Date],1) OVER(ORDER BY [Start Date] ASC) AS PreviousSessionStartDate,
LEAD([Session Name],1) OVER(ORDER BY [Start Date] ASC) AS NextSession,
LEAD([Start Date],1) OVER(ORDER BY [Start Date] ASC) AS NextSessionStartDate
FROM [Red30Tech].[dbo].[SessionInfo$]
WHERE [Room Name] = 'Room 102'

------------------------------------------------------------------------------------- 
WITH OrderByDays AS (
					SELECT OrderDate, SUM(Quantity) AS QuantityByDay
					FROM [Red30Tech].[dbo].[OnlineRetailSales$]
					WHERE ProdCategory = 'Drones'
					GROUP BY OrderDate
					)

SELECT OrderDate, QuantityByDay,
LAG([QuantityByDay],1) OVER(ORDER BY OrderDate) as LastQuantity_1,
LAG([QuantityByDay],2) OVER(ORDER BY OrderDate) as LastQuantity_2,
LAG([QuantityByDay],3) OVER(ORDER BY OrderDate) as LastQuantity_3,
LAG([QuantityByDay],4) OVER(ORDER BY OrderDate) as LastQuantity_4,
LAG([QuantityByDay],5) OVER(ORDER BY OrderDate) as LastQuantity_5
FROM OrderByDays

-- OR

SELECT OrderDate, QuantityByDay,
LAG([QuantityByDay],1) OVER(ORDER BY OrderDate) as LastQuantity_1,
LAG([QuantityByDay],2) OVER(ORDER BY OrderDate) as LastQuantity_2,
LAG([QuantityByDay],3) OVER(ORDER BY OrderDate) as LastQuantity_3,
LAG([QuantityByDay],4) OVER(ORDER BY OrderDate) as LastQuantity_4,
LAG([QuantityByDay],5) OVER(ORDER BY OrderDate) as LastQuantity_5
FROM (SELECT OrderDate, SUM(Quantity) AS QuantityByDay
		FROM [Red30Tech].[dbo].[OnlineRetailSales$]
		WHERE ProdCategory = 'Drones'
		GROUP BY OrderDate
		) as LOL
----------------------------------------------------------------------------------------------

SELECT *, 
ROW_NUMBER() OVER(ORDER BY [Last Name]) AS Row_Num,
RANK() OVER(ORDER BY [Last Name]) AS Rank_,
DENSE_RANK() OVER(ORDER BY [Last Name]) AS Dense_Rank_
FROM [Red30Tech].[dbo].[EmployeeDirectory$]

----------------------------------------------------------------------------------
SELECT * FROM [Red30Tech].[dbo].[ConventionAttendees$]
WITH FTCA AS (
				SELECT *,
				RANK() OVER(PARTITION BY [State] ORDER BY [Registration Date] ASC) AS Attendee_Rank,
				DENSE_RANK() OVER(PARTITION BY [State] ORDER BY [Registration Date] ASC) AS Attendee_DRank
				FROM [Red30Tech].[dbo].[ConventionAttendees$]
				)
SELECT *
FROM FTCA 
WHERE Attendee_DRank IN (1,2,3)







































