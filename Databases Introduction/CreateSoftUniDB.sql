--Problem 16.	Create SoftUni Database & Insert data
CREATE DATABASE SoftUni

CREATE TABLE Towns 
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

INSERT INTO Towns ([Name]) VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

CREATE TABLE Addresses 
(
	Id INT PRIMARY KEY IDENTITY,
	AddressText VARCHAR(50) NOT NULL,
	TownId INT NOT NULL
)

CREATE TABLE Departments  
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

INSERT INTO Departments ([Name]) VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

CREATE TABLE Employees   
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50) NOT NULL, 
	MiddleName VARCHAR(50), 
	LastName VARCHAR(50) NOT NULL, 
	JobTitle VARCHAR(50) NOT NULL, 
	DepartmentId INT NOT NULL, 
	HireDate DATETIME NOT NULL, 
	Salary DECIMAL(15,2), 
	AddressId INT
)

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '01-02-2013', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '02-03-2004', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '08-28-2016', 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '09-12-2007', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '08-28-2016', 599.88)

--Problem 19.	Basic Select All Fields
SELECT * FROM Towns

SELECT * FROM Departments

SELECT * FROM Employees

--Problem 20.	Basic Select All Fields and Order Them
SELECT * FROM Towns ORDER BY [Name] ASC

SELECT * FROM Departments ORDER BY [Name] ASC

SELECT * FROM Employees ORDER BY Salary DESC

--Problem 21.	Basic Select Some Fields
SELECT [Name] FROM Towns ORDER BY [Name] ASC

SELECT [Name] FROM Departments ORDER BY [Name] ASC

SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

--Problem 22.	Increase Employees Salary
UPDATE Employees
SET Salary *= 1.1
SELECT Salary FROM Employees 