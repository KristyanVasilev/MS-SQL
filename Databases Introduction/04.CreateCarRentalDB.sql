--Problem 14.	Car Rental Database
CREATE DATABASE	CarRental

CREATE TABLE Categories 
(
    Id INT PRIMARY KEY NOT NULL,
    CategoryName VARCHAR(200) NOT NULL,
    DailyRate DECIMAL(15,2) NOT NULL,
    WeeklyRate DECIMAL(15,2) NOT NULL,
    MonthlyRate DECIMAL(15,2) NOT NULL,
    WeekendRate DECIMAL(15,2) NOT NULL
)

INSERT INTO Categories(Id, CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) VALUES
(1, 'SUV', 50.20, 105.23, 300.50, 140.33),
(2, 'COUPE', 70.20, 145.23, 400.50, 180.33),
(3, 'SEDAD', 60.20, 115.63, 310.50, 140.33)

CREATE TABLE Cars  
(
    Id INT PRIMARY KEY NOT NULL,
    PlateNumber VARCHAR(15) NOT NULL,
    Manufacturer VARCHAR(15) NOT NULL,
    Model VARCHAR(15),
    CarYear DATETIME NOT NULL,
    CategoryId INT NOT NULL,
	Doors INT NOT NULL,
	Picture VARCHAR(MAX),
	Condition VARCHAR(50),
	Available BIT NOT NULL
)

INSERT INTO Cars(Id, PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available) VALUES
(1, 'KH7079BT', 'Audi', 'A3', 5/6/2005, 2, 3, NULL, NULL, 1),
(2, 'CA5755BX', 'BMW', 'F30', 8/4/2007, 1, 5, NULL, NULL, 0),
(3, 'CA777777', 'Mercedes', NULL, 3/7/2008, 3, 5, NULL, NULL, 1)

CREATE TABLE Employees
(
	Id INT PRIMARY KEY NOT NULL,
    FirstName VARCHAR(25) NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    Title VARCHAR(100),
    Notes VARCHAR(MAX)
)

INSERT INTO Employees(Id, FirstName, LastName, Title, Notes) VALUES
(1, 'Gosho', 'Peshev', NULL, NULL),
(2, 'Mitko', 'Mirchev', NULL, NULL),
(3, 'Pesho', 'Mitkov', NULL, NULL)

CREATE TABLE Customers 
(
	Id INT PRIMARY KEY NOT NULL,
    DriverLicenceNumber INT NOT NULL,
    FullName VARCHAR(25) NOT NULL,
    [Address] VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    ZIPCode VARCHAR(100),
    Notes VARCHAR(MAX)
)

INSERT INTO Customers(Id, DriverLicenceNumber, FullName, [Address], City, ZIPCode, Notes) VALUES
(1, 1234, 'Pesho', 'ul. 8 Dekemvri','Sofia', NULL, NULL),
(2, 5678, 'Mitko', 'Kum Parka','Dupnitsa', NULL, NULL),
(3, 1513, 'Lube', 'ul. 3ti May', 'Sofia', NULL, NULL)

CREATE TABLE RentalOrders  
(
	Id INT PRIMARY KEY NOT NULL,
    EmployeeId INT NOT NULL,
    CustomerId INT NOT NULL,
    CarId INT NOT NULL,
    TankLevel INT NOT NULL,
    KilometrageStart INT NOT NULL,
    KilometrageEnd INT NOT NULL,
    TotalKilometrage INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    TotalDays INT NOT NULL,
    RateApplied VARCHAR(100),
	TaxRate DECIMAL(15,2) NOT NULL,
	OrderStatus VARCHAR(100),
    Notes VARCHAR(MAX)
)

INSERT INTO RentalOrders(Id, EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes) VALUES
(1, 1, 2, 2, 40, 1000, 1200, 200, GETDATE(), 6/20/2022, 2, NULL, 50.50, NULL, NULL),
(2, 2, 1, 1, 60, 1200, 1500, 300, GETDATE(), 5/20/2022, 1, NULL, 70.50, NULL, NULL),
(3, 3, 3, 3, 80, 2000, 2600, 600, GETDATE(), 8/20/2022, 4, NULL, 79.50, NULL, NULL)