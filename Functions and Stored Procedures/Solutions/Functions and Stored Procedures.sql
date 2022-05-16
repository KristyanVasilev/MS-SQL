USE SoftUni

--1. Employees with Salary Above 35000 - stored procedure 
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName 
  FROM Employees
 WHERE Salary > 35000

EXEC usp_GetEmployeesSalaryAbove35000

--2. Employees with Salary Above Number - stored procedure
CREATE PROC usp_GetEmployeesSalaryAboveNumber(@inputSalary DECIMAL(18,4))
AS
SELECT FirstName, LastName 
  FROM Employees
 WHERE Salary > @inputSalary

EXEC usp_GetEmployeesSalaryAboveNumber 48100

--03. Town Names Starting With - stored procedure
CREATE PROC usp_GetTownsStartingWith(@startingLetter VARCHAR(50))
AS
SELECT [Name]
  FROM Towns
 WHERE SUBSTRING([Name], 1, LEN(@startingLetter)) = @startingLetter

EXEC usp_GetTownsStartingWith 'Bo'

--04. Employees from Town - stored procedure
CREATE PROC usp_GetEmployeesFromTown(@townName VARCHAR(50))
AS
SELECT e.FirstName AS [First Name], e.LastName AS [Last Name]
  FROM Employees e
  JOIN Addresses a ON a.AddressID = e.AddressID
  JOIN Towns t ON t.TownID = a.TownID
 WHERE t.[Name] = @townName

EXEC usp_GetEmployeesFromTown 'Sofia'

--05. Salary Level Function - function
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(50)
AS
BEGIN
DECLARE @result VARCHAR(50)

IF (@salary < 30000)
	SET @result = 'Low'
ELSE IF (@salary >= 30000 AND @salary <= 50000)
	SET @result = 'Average'
ELSE 
	SET @result = 'High'

RETURN @result;
END

SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) AS [Salary Level]
  FROM Employees

--06. Employees by Salary Level - stored procedure 
CREATE PROC usp_EmployeesBySalaryLevel(@salaryLevel VARCHAR(50))
AS
SELECT FirstName, LastName
  FROM Employees
 WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel

EXEC usp_EmployeesBySalaryLevel 'High'

--07. Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX)) 
RETURNS BIT
BEGIN
DECLARE @count INT = 1

WHILE (@count <= LEN(@word))
BEGIN
	  DECLARE @currentLetter CHAR(1) = SUBSTRING(@word, @count, 1) 
	  
	  IF (CHARINDEX(@currentLetter, @setOfLetters) = 0)
	  RETURN 0
	  
	  SET @count += 1
END
RETURN 1
END

DECLARE @setOfLetters VARCHAR(MAX) = 'osifa'
 SELECT 
        [Name] AS [Town],
        @setOfLetters AS [Set of letters], 
        dbo.ufn_IsWordComprised([Name], @setOfLetters) AS [Result]
   FROM Towns

--08. Delete Employees and Departments