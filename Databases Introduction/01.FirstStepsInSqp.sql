--Problem 1.	Create Database
CREATE DATABASE Minions

--Problem 2.	Create Tables
CREATE TABLE Minions
(
   Id INT PRIMARY KEY,
   [Name] VARCHAR(30),
   Age INT
)

CREATE TABLE Towns
(
   Id INT PRIMARY KEY,
   [Name] VARCHAR(50),
)

--Problem 3.	Alter Minions Table
ALTER TABLE Minions
ADD TownId INT

ALTER TABLE Minions
ADD FOREIGN KEY (TownId) REFERENCES Towns(Id)

--Problem 4.	Insert Records in Both Tables
INSERT INTO Towns(Id,Name) VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions(Id, Name, Age, TownId) VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

SELECT * FROM Towns

SELECT * FROM Minions

--Problem 5.	Truncate Table Minions
DELETE FROM Minions

--Problem 6.	Drop All Tables
DROP TABLE Minions
DROP TABLE Towns

--Problem 7.	Create Table People
CREATE TABLE People
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(200) NOT NULL,
    Picture VARCHAR(MAX),
	Height FLOAT (2),
    [Weight] FLOAT (2),
    Gender BIT NOT NULL,
	Birthdate DATETIME NOT NULL,
	Biography NVARCHAR(MAX)
)

INSERT INTO People(Name, Picture, Height, Weight, Gender, Birthdate, Biography) VALUES
('Sofia', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 155.23, 67.2, 1, 5/12/2002, NULL),
('Peter', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 125.23, 47.2, 0, 6/1/2002, NULL),
('George', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 145.23, 87.2, 0, 8/2/2002, NULL),
('Didi', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 165.23, 77.2, 1, 9/9/2002, NULL),
('Mitko', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 185.23, 97.2, 0, 11/10/2002, NULL)

SELECT * FROM People

--Problem 8.	Create Table Users
CREATE TABLE Users
(
    Id BIGINT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(30) NOT NULL,
    [Password] VARCHAR(MAX) NOT NULL,
    ProfilePicture VARCHAR(MAX) NOT NULL,
	LastLongTime DATETIME,
    IsDeleted BIT
)

INSERT INTO Users(Name, Password, ProfilePicture, LastLongTime, IsDeleted) VALUES
('Sofia', 'pARola1', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 5/12/2002, NULL),		  
('Peter', 'pARola2', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 6/1/2002, 1),			 
('George','pARola3', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 8/2/2002, 0),
('Didi', 'pARola4', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 9/9/2002, 1),
('Mitko','pARola5', 'https://judge.softuni.org/Contests/Practice/Index/284#0', 11/10/2002, NULL)

SELECT * FROM Users

--Problem 9.	Change Primary Key
ALTER TABLE Users
DROP CONSTRAINT [PK__Users__3214EC070CA393D8]

ALTER TABLE Users
ADD CONSTRAINT PK_IdUsername PRIMARY KEY (Id, Name)

--Problem 10.	Add Check Constraint
ALTER TABLE Users
ADD CONSTRAINT CH_PasswordMustBeAtLeast5Symbols CHECK (LEN([Password]) > 5)

--Problem 11.	Set Default Value of a Field
ALTER TABLE Users
ADD CONSTRAINT DF_LastLongTime DEFAULT GETDATE() FOR LastLongTime

--Problem 12.	Set Unique Field
ALTER TABLE Users
DROP CONSTRAINT PK_IdUsername

ALTER TABLE Users
ADD CONSTRAINT PK_Id PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT CH_NameLenghtMustBeAtLeast3Symbols CHECK (LEN([Name]) > 3)
