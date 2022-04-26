--Problem 15.	Hotel Database & add data
--CREATE DATABASE Hotel

CREATE TABLE Employees   
(
	Id INT PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50) NOT NULL, 
	LastName VARCHAR(50) NOT NULL, 
	Title VARCHAR(50) NOT NULL, 
	Notes VARCHAR(MAX), 
)

INSERT INTO Employees (Id, FirstName, LastName, Title, Notes) VALUES
(1, 'Ivan', 'Ivanov', '.NET Developer', NULL),
(2, 'Petar', 'Petrov', 'Senior Engineer', NULL),
(3, 'Maria', 'Ivanova', 'Intern', NULL)

CREATE TABLE Customers   
(
	AccountNumber INT PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50) NOT NULL, 
	LastName VARCHAR(50) NOT NULL, 
	PhoneNumber VARCHAR(15) NOT NULL, 
	EmergencyName VARCHAR(50) NOT NULL, 
	EmergencyNumber VARCHAR(15) NOT NULL, 
	Notes VARCHAR(MAX) 
)

INSERT INTO Customers(AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes) VALUES
(10, 'Ivan', 'Ivanov', '0896313666', 'VA', '313', NULL),
(20, 'Petar', 'Petrov', '0896313555', 'GA', '515', NULL),
(30, 'Maria', 'Ivanova', '0896344627', 'ZA', '414', NULL)

CREATE TABLE RoomStatus 
(
	RoomStatus VARCHAR(50) NOT NULL,  
	Notes VARCHAR(MAX)
)

INSERT INTO RoomStatus(RoomStatus, Notes) VALUES
('Available', NULL),
('Not Available', NULL),
('Cleaning', NULL)

CREATE TABLE RoomTypes 
(
	RoomType VARCHAR(50) NOT NULL,  
	Notes VARCHAR(MAX)
)

INSERT INTO RoomTypes(RoomType, Notes) VALUES
('Apartment', NULL),
('One bedroom', NULL),
('Two bedroom', NULL)

CREATE TABLE BedTypes 
(
	BedType VARCHAR(50) NOT NULL,  
	Notes VARCHAR(MAX)
)

INSERT INTO BedTypes(BedType, Notes) VALUES
('King Bed', NULL),
('Normal size bed', NULL),
('Big bed', NULL)

CREATE TABLE Rooms   
(
	RoomNumber INT PRIMARY KEY NOT NULL,
	RoomType VARCHAR(50) NOT NULL, 
	BedType VARCHAR(50) NOT NULL, 
	Rate INT, 
	RoomStatus VARCHAR(50) NOT NULL,  
	Notes VARCHAR(MAX)
)

INSERT INTO Rooms(RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes) VALUES
(120, 'Apartment', 'King bed', 9, 'Available', NULL),
(121, 'Two bed', 'Big bed', 4, ' Not Available', NULL),
(122, 'One bed', 'Normal bed', 6, 'Cleaning', NULL)

CREATE TABLE Payments   
(
	Id INT PRIMARY KEY NOT NULL,
	EmployeeId INT NOT NULL, 
	PaymentDate DATETIME NOT NULL, 
	AccountNumber VARCHAR(50) NOT NULL, 
	FirstDateOccupied DATETIME NOT NULL, 
	LastDateOccupied DATETIME NOT NULL, 
	TotalDays INT NOT NULL, 
	AmountCharged DECIMAL(15,2) NOT NULL, 
	TaxRate DECIMAL(15,2), 
	TaxAmount DECIMAL(15,2), 
	PaymentTotal DECIMAL(15,2) NOT NULL, 
	Notes VARCHAR(MAX) 
)

INSERT INTO Payments(Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes) VALUES
(5, 1, GETDATE(), 10, '06-07-2022', '08-07-2022', 2, 230.20, NULL, NULL, 230.20, NULL),
(6, 3, GETDATE(), 20, '07-08-2022', '09-08-2022', 2, 170.40, NULL, NULL, 170.40, NULL),
(7, 3, GETDATE(), 30, '01-02-2022', '03-02-2022', 2, 150.70, NULL, NULL, 150.70, NULL)

CREATE TABLE Occupancies    
(
	Id INT PRIMARY KEY NOT NULL,
	EmployeeId INT NOT NULL, 
	DateOccupied DATETIME NOT NULL, 
	AccountNumber VARCHAR(50) NOT NULL, 
	RoomNumber INT NOT NULL, 
	RateApplied INT, 
	PhoneCharge DECIMAL(15,2), 
	Notes VARCHAR(MAX) 
)

INSERT INTO Occupancies(Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes) VALUES
(76, 1, GETDATE(), 10, 121, NULL, NULL, NULL),
(77, 2, GETDATE(), 20, 122, NULL, NULL, NULL),
(78, 3, GETDATE(), 30, 123, NULL, NULL, NULL)

--Problem 23.	Decrease Tax Rate
UPDATE Payments 
SET TaxRate *= 0.97

SELECT TaxRate FROM Payments

--Problem 24.	Delete All Records
DELETE FROM Occupancies
