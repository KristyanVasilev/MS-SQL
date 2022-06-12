CREATE DATABASE Airport

--01. Design Database
CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
    FullName VARCHAR(100) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE,
)

CREATE TABLE Pilots
(
	Id INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(30) NOT NULL UNIQUE,
    LastName VARCHAR(30) NOT NULL UNIQUE,
    Age TINYINT NOT NULL,
    Rating FLOAT,

	CHECK (Age >= 21 AND Age <= 62),
	CHECK (Rating >= 0.0 AND Rating <= 10.0) 
)

CREATE TABLE AircraftTypes
(
	Id INT PRIMARY KEY IDENTITY,
    TypeName VARCHAR(30) NOT NULL UNIQUE
)

CREATE TABLE Aircraft
(
	Id INT PRIMARY KEY IDENTITY,
    Manufacturer VARCHAR(25) NOT NULL,
    Model VARCHAR(30) NOT NULL,
    [Year] INT NOT NULL,
    FlightHours INT,
    Condition CHAR(1) NOT NULL,
	TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft
(
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	PilotId INT FOREIGN KEY REFERENCES Pilots(Id) NOT NULL,
    
	PRIMARY KEY(AircraftId,PilotId),
)

CREATE TABLE Airports
(
	Id INT PRIMARY KEY IDENTITY,
    AirportName VARCHAR(70) NOT NULL UNIQUE,
    Country VARCHAR(100) NOT NULL UNIQUE,
)

CREATE TABLE FlightDestinations
(
	Id INT PRIMARY KEY IDENTITY,
    AirportId INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL,
    [Start] DATETIME NOT NULL,
    AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
    PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
    TicketPrice DECIMAL(18,2) DEFAULT(15) NOT NULL
)