CREATE DATABASE TableRelations

-- Problem 1. One-To-One Relationship
CREATE TABLE Passports
(
	PassportID INT PRIMARY KEY IDENTITY(101,1),
	PassportNumber CHAR(8) NOT NULL
)

CREATE TABLE Persons
(
	PersonID INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	Salary DECIMAL(15,2) NOT NULL,
	PassportID INT UNIQUE FOREIGN KEY REFERENCES Passports(PassportID)
)

INSERT INTO Passports VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO Persons VALUES
('Roberto', 43300.00, 102),
('Tom',	56100.00, 103),
('Yana', 60200.00, 101)

-- Problem 2. One-To-Many Relationship
CREATE TABLE Manufacturers
(
	ManufacturerID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(20) NOT NULL,
	EstablishedOn DATETIME NOT NULL
)

CREATE TABLE Models
(
	ModelID INT PRIMARY KEY IDENTITY(101,1),
	[Name] NVARCHAR(20) NOT NULL,
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers VALUES
('BMW', '07-03-1916'),
('Tesla', '01-01-2003'),
('Lada', '01-05-1966')

INSERT INTO Models VALUES
('X1', 1),
('i6', 1),
('Model S',	2),
('Model X',	2),
('Model 3',	2),
('Nova', 3)

-- Problem 3. Many-To-Many Relationship

CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	[NAME] NVARCHAR(30)
)

CREATE TABLE Exams
(
	ExamID INT PRIMARY KEY IDENTITY(101,1),
	[NAME] NVARCHAR(30)
)

CREATE TABLE StudentsExams
(
	StudentID INT,
	ExamID INT,

	CONSTRAINT PK_Students_Exams PRIMARY KEY(StudentID, ExamID),
	CONSTRAINT FK_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
	CONSTRAINT FK_Exams FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
)

INSERT INTO Students VALUES
('Mila'),                                     
('Toni'),
('Ron')

INSERT INTO Exams VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

INSERT INTO StudentsExams VALUES
(1,	101),
(1,	102),
(2,	101),
(3,	103),
(2,	102),
(2,	103)

-- Problem 4. Self-Referencing 

CREATE TABLE Teachers
(
	TeacherID INT PRIMARY KEY IDENTITY(101,1),
	[Name] NVARCHAR(30),
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105 ),
('Mark', 101 ),
('Greta', 101 )

-- Problem 5. Online Store Database

CREATE TABLE Cities
(
    CityID INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    Birthday DATE,
    CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Orders
(
	OrderID INT PRIMARY KEY IDENTITY,
	CustimerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes
(
	ItemTypeID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Items
(
	ItemID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems
(
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID)

	CONSTRAINT PK_Order_Item PRIMARY KEY(OrderID, ItemID)
)

-- Problem 9. *Peaks in Rila
SELECT * FROM Mountains
	WHERE MountainRange = 'Rila'

SELECT * FROM Peaks
	WHERE MountainId = 17

SELECT m.MountainRange, p.PeakName, p.Elevation
FROM Mountains AS m
	JOIN Peaks AS p ON P.MountainId = m.Id
		WHERE m.MountainRange = 'Rila'
			ORDER BY P.Elevation DESC