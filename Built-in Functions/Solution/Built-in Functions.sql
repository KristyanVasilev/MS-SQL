USE SoftUni
--Problem 1. Find Names of All Employees by First Name
SELECT FirstName, LastName FROM Employees
	WHERE LEFT(FirstName, 2) = 'Sa'

--Problem 2. Find Names of All employees by Last Name 
SELECT FirstName, LastName FROM Employees  -- Solution with wild cards
	WHERE LastName LIKE '%ei%'

--Problem 3. Find First Names of All Employees
SELECT FirstName FROM Employees
	WHERE DepartmentID IN(3, 10) AND YEAR(HireDate) BETWEEN 1995 AND 2005

--Problem 4. Find All Employees Except Engineers
SELECT FirstName, LastName FROM Employees
	WHERE CHARINDEX('engineer', JobTitle) = 0

--Problem 5. Find Towns with Name Length
  SELECT [Name] FROM Towns
   WHERE LEN([Name]) IN(5, 6)
ORDER BY [Name]

--Problem 6. Find Towns Starting With
   SELECT *
     FROM Towns
    WHERE LEFT([Name], 1) IN('M', 'K', 'B', 'E')
 ORDER BY [Name]

--Problem 7.	 Find Towns Not Starting With
  SELECT * 
    FROM Towns
   WHERE LEFT([Name], 1) LIKE '[^RBD]'
ORDER BY [Name]

--Problem 8. Create View Employees Hired After 2000 Year
CREATE VIEW V_EmployeesHiredAfter2000 AS
	 SELECT FirstName, LastName		
	   FROM Employees
      WHERE YEAR(HireDate) > 2000

--Problem 9. Length of Last Name
SELECT FirstName, LastName		
  FROM Employees
 WHERE LEN(LastName) = 5

--Problem 10. Rank Employees by Salary
  SELECT EmployeeID ,FirstName, LastName, Salary,	 
	     DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
    FROM Employees
   WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--Problem 11. Find All Employees with Rank 2 *
  SELECT *
	FROM (
		   SELECT EmployeeID ,FirstName, LastName, Salary,	 
				  DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
			 FROM Employees
			WHERE Salary BETWEEN 10000 AND 50000
		 ) 
	  AS RankingTable
   WHERE [Rank] = 2
ORDER BY Salary DESC

USE [Geography]
--Problem 12. Countries Holding ?A? 3 or More Times
  SELECT CountryName, IsoCode 
    FROM Countries
   WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode

--Problem 13. Mix of Peak and River Names
   SELECT p.PeakName, r.RiverName,
	      LOWER(CONCAT(LEFT(p.PeakName, LEN(p.PeakName) -1), r.RiverName))
	             AS Mix
     FROM  Peaks AS p,
	      Rivers AS r
    WHERE LOWER(RIGHT(p.PeakName, 1)) = LOWER(LEFT(r.RiverName, 1))
 ORDER BY Mix

USE Diablo
--Problem 14. Games from 2011 and 2012 year
  SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
    FROM Games
   WHERE YEAR([Start]) IN(2011, 2012)
ORDER BY [Start], [NAME]

--Problem 15. User Email Providers
  SELECT Username, RIGHT(Email, LEN(Email) - CHARINDEX('@', Email)) AS [Email Provider]
    FROM Users
ORDER BY [Email Provider], Username

--Problem 16. Get Users with IPAdress Like Pattern
  SELECT Username, IpAddress 
    FROM Users
   WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--Problem 17. Show All Games with Duration and Part of the Day
SELECT 
	[Name] AS [Game],
	CASE
		WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
		ELSE 'Evening'
	END 
	       AS [Part of the Day],
	CASE
		WHEN [Duration] <= 3 THEN 'Extra Short'
		WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
		WHEN [Duration] > 6 THEN'Long'
		ELSE 'Extra Long'
	END 
	       AS [Duration]
FROM [Games] AS g
ORDER BY Game, Duration, [Part of the Day]