Use SoftUni

--1. Employee Address
  SELECT TOP(5) e.EmployeeID, e.JobTitle, a.AddressID, a.AddressText
    FROM Employees e 
    JOIN Addresses a ON e.AddressID = a.AddressID
ORDER BY a.AddressID ASC

--2. Addresses with Towns
  SELECT TOP(50) e.FirstName, e.LastName, t.Name, a.AddressText
    FROM Employees e 
    JOIN Addresses a ON e.AddressID = a.AddressID
    JOIN Towns t ON t.TownID = a.TownID
ORDER BY e.FirstName ASC, e.LastName

--3. Sales Employee
  SELECT e.EmployeeID, e.FirstName, e.LastName, d.Name AS [DepartmentName]
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
   WHERE d.Name = 'Sales' 
ORDER BY e.EmployeeID ASC

--4. Employee Departments
  SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.Name AS [DepartmentName]
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
   WHERE e.Salary > 15000
ORDER BY d.DepartmentID ASC

--5. Employees Without Project
   SELECT TOP(3) e.EmployeeID, e.FirstName
     FROM Employees e
LEFT JOIN EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
    WHERE ep.ProjectID IS NULL
 ORDER BY e.EmployeeID ASC

--6. Employees Hired After
  SELECT e.FirstName, e.LastName, e.HireDate, d.Name AS [DepartmentName]
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
   WHERE e.HireDate > '1999-12-31' AND d.Name IN ('Sales', 'Finance')
ORDER BY e.HireDate ASC

--7. Employees with Project
   SELECT TOP(5) e.EmployeeID, e.FirstName, p.Name AS [ProjectName]
     FROM Employees e
     JOIN EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
     JOIN Projects p ON ep.ProjectID = p.ProjectID
    WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
 ORDER BY e.EmployeeID ASC

--8. Employee 24
SELECT TOP(5) e.EmployeeID, e.FirstName,
	   CASE 
		   WHEN DATEPART(YEAR, p.StartDate) >= 2005 THEN NULL
		   ELSE p.Name
	   END AS [ProjectName]
  FROM Employees e
  JOIN EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
  JOIN Projects p ON ep.ProjectID = p.ProjectID
 WHERE e.EmployeeID = 24

--9. Employee Manager
SELECT e.EmployeeID, e.FirstName, em.EmployeeID, em.FirstName AS [ManagerName]
  FROM Employees e 
  JOIN Employees em ON em.EmployeeID = e.ManagerID
 WHERE e.ManagerID IN (3, 7)

--10. Employee Summary
  SELECT TOP(50) e.EmployeeID,
	     CONCAT_WS(' ', e.FirstName, e.LastName) AS [EmployeeName], 
	     CONCAT_WS(' ', em.FirstName, em.LastName) AS [ManagerName],
	     d.Name AS [DepartmentName]
    FROM Employees e 
    JOIN Employees em ON em.EmployeeID = e.ManagerID
    JOIN Departments d ON d.DepartmentID = e.DepartmentID
ORDER BY e.EmployeeID

--11. Min Average Salary
  SELECT TOP(1) AVG(Salary) AS AverageSalary
    FROM Employees e 
    JOIN Departments d ON d.DepartmentID = e.DepartmentID
GROUP BY e.DepartmentID
ORDER BY AverageSalary

USE [Geography]

--12. Highest Peaks in Bulgaria
  SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation
    FROM MountainsCountries mc
    JOIN Mountains m ON m.Id = mc.MountainId
	JOIN Peaks p ON p.MountainId = m.Id
   WHERE mc.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

--13. Count Mountain Ranges
  SELECT c.CountryCode, COUNT(*) 
    FROM Countries c
    JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
   WHERE c.CountryCode IN ('BG', 'RU', 'US')
GROUP BY c.CountryCode

--14. Countries with Rivers
SELECT TOP (5) c.CountryName, r.RiverName 
      FROM CountriesRivers cr
RIGHT JOIN Rivers r ON r.Id = cr.RiverId
RIGHT JOIN Countries c ON cr.CountryCode = c.CountryCode
RIGHT JOIN Continents con ON con.ContinentCode = c.ContinentCode
     WHERE c.ContinentCode = 'AF'
  ORDER BY c.CountryName 

--15. *Continents and Currencies
  SELECT ContinentCode, CurrencyCode, Total AS [CurrencyUsage] FROM (
  SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS Total,
         DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) AS Ranked
    FROM Countries
GROUP BY ContinentCode, CurrencyCode) AS K
   WHERE Ranked = 1 AND Total > 1
ORDER BY ContinentCode

--16. Countries Without Any Mountains
   SELECT COUNT(*) AS [Count]
     FROM Countries c
LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
    WHERE mc.MountainId IS NULL

--17. Highest Peak and Longest River by Country
   SELECT TOP(5) c.CountryName, MAX(p.Elevation) AS [HighestPeak], MAX(r.Length) [LongestRiver]
     FROM Countries c
LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains m ON m.Id = mc.MountainId
LEFT JOIN Peaks p ON p.MountainId = m.Id
LEFT JOIN CountriesRivers cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers r ON r.Id = cr.RiverId
 GROUP BY CountryName
 ORDER BY HighestPeak DESC, LongestRiver DESC, CountryName

 --18. Highest Peak Name and Elevation by Country
   SELECT TOP(5) k.CountryName, k.PeakName, k.HighestPeak, k.MountainRange
     FROM ( 
   SELECT c.CountryName,
          ISNULL(p.PeakName, '(no highest peak)') AS [PeakName],
          ISNULL(m.MountainRange, '(no mountain)') AS [MountainRange],
          ISNULL(MAX(p.Elevation), 0) AS [HighestPeak],
	      DENSE_RANK() OVER (PARTITION BY CountryName ORDER BY MAX(p.Elevation) DESC) AS Ranked
     FROM Countries c
LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains m ON m.Id = mc.MountainId
LEFT JOIN Peaks p ON p.MountainId = m.Id
LEFT JOIN CountriesRivers cr ON cr.CountryCode = c.CountryCode
 GROUP BY c.CountryName, p.PeakName, m.MountainRange) AS k
    WHERE Ranked = 1
 ORDER BY CountryName, PeakName