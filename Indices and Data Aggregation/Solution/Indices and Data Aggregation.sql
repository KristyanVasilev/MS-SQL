USE Gringotts

--1. Records’ Count
SELECT COUNT(*) 
  FROM WizzardDeposits

--02. Longest Magic Wand
  SELECT TOP(1) MagicWandSize AS [LongestMagicWand]
    FROM WizzardDeposits
GROUP BY MagicWandSize
ORDER BY MagicWandSize DESC

--3. Longest Magic Wand Per Deposit Groups
  SELECT DepositGroup ,MAX(MagicWandSize) AS [LongestMagicWand]
    FROM WizzardDeposits
GROUP BY DepositGroup

--4. * Smallest Deposit Group Per Magic Wand Size
SELECT TOP(2) DepositGroup 
    FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

--5. Deposits Sum
  SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
    FROM WizzardDeposits
GROUP BY DepositGroup

--06. Deposits Sum for Ollivander Family
  SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
    FROM WizzardDeposits
   WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--7. Deposits Filter
  SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
    FROM WizzardDeposits
   WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
  HAVING SUM(DepositAmount) < 150000
ORDER BY SUM(DepositAmount) DESC

--8.  Deposit Charge
  SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge)
    FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

--09. Age Groups
  SELECT Result.AgeGroup, COUNT(Result.AgeGroup) AS WizardCount 
    FROM (
  SELECT
    CASE 
	     WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
	     WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
	     WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
	     WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
	     WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
	     WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
	     WHEN Age >= 61 THEN '[61+]'
     END AS AgeGroup
    FROM WizzardDeposits) AS Result
GROUP BY Result.AgeGroup

--10. First Letter
  SELECT SUBSTRING(FirstName, 1, 1) AS ExtractString
    FROM WizzardDeposits
   WHERE DepositGroup = 'Troll Chest'
GROUP BY DepositGroup, SUBSTRING(FirstName, 1, 1)

--11. Average Interest 
  SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest
    FROM WizzardDeposits
   WHERE DepositStartDate > '01-01-1985'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired ASC

--12. * Rich Wizard, Poor Wizard
SELECT SUM (Guests.DepositAmount - Hosts.DepositAmount) AS [Difference]
  FROM WizzardDeposits AS Hosts
  JOIN WizzardDeposits AS Guests ON Guests.Id + 1 = Hosts.Id 

USE SoftUni
--13. Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID 

--14. Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary) AS MinimumSalary
FROM Employees
WHERE DepartmentID IN (2, 5, 7) AND HireDate > '01-01-2000'
GROUP BY DepartmentID

--15. Employees Average Salaries
SELECT *
  INTO MyNewTable
  FROM Employees
 WHERE Salary > 30000

DELETE
  FROM MyNewTable
 WHERE ManagerID = 42

UPDATE MyNewTable
   SET Salary += 5000
 WHERE DepartmentID = 1

  SELECT DepartmentID, AVG(Salary) AS AverageSalary
    FROM MyNewTable
GROUP BY DepartmentID

--16. Employees Maximum Salaries
  SELECT DepartmentID, MAX(Salary) AS MaxSalary
    FROM Employees
GROUP BY DepartmentID
  HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--17. Employees Count Salaries
SELECT COUNT(*) AS [Count]
  FROM Employees
 WHERE ManagerID IS NULL

--18. 3rd Highest Salary
SELECT DISTINCT k.DepartmentID, k.Salary
  FROM (
SELECT DepartmentID, Salary,
       DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS Ranked
  FROM Employees) AS k
 WHERE Ranked = 3

--19. **Salary Challenge
  SELECT DepartmentID, AVG(Salary) AS AvarageSalary
    INTO DepartmentIdAndAvgSalary
    FROM Employees
GROUP BY DepartmentID

  SELECT TOP(10) e.FirstName, e.LastName, e.DepartmentID
    FROM DepartmentIdAndAvgSalary da
    JOIN Employees e ON e.DepartmentID = da.DepartmentID
   WHERE e.Salary > da.AvarageSalary
ORDER BY e.DepartmentID

-- second solution
SELECT TOP(10) e.FirstName, e.LastName, e.DepartmentID 
  FROM Employees e
 WHERE e.Salary > (SELECT AVG(Salary)
                   FROM Employees  
                   WHERE DepartmentID = e.DepartmentID
				   GROUP BY DepartmentID)
