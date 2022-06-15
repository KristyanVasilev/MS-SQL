CREATE DATABASE Bakery

--Design Database
CREATE TABLE Countries 
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) UNIQUE,
)

CREATE TABLE Customers 
(
    Id INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(25),
    LastName VARCHAR(25),
    Gender CHAR(1),
    Age INT,
    PhoneNumber VARCHAR(10),
    CountryId INT FOREIGN KEY REFERENCES Countries(Id),

	CHECK (Gender = 'M' OR Gender = 'F'),
	CHECK (LEN(PhoneNumber) = 10)
)

CREATE TABLE Products 
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(25) UNIQUE,
    [Description] VARCHAR(250),
    Recipe VARCHAR(MAX),
    Price MONEY,

	CHECK (Price >= 0),
)

CREATE TABLE Feedbacks 
(
    Id INT PRIMARY KEY IDENTITY,
    [Description] VARCHAR(255),
    Rate DECIMAL(15,2),
    ProductId INT FOREIGN KEY REFERENCES Products(Id),
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id),

	CHECK (Rate BETWEEN 0 AND 10),
)

CREATE TABLE Distributors 
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(25) UNIQUE,
    AddressText VARCHAR(30),
    Summary VARCHAR(200),
    CountryId INT FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Ingredients	 
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(30),
    [Description] VARCHAR(200),
    OriginCountryId INT FOREIGN KEY REFERENCES Countries(Id),
    DistributorId INT FOREIGN KEY REFERENCES Distributors(Id)
)

CREATE TABLE ProductsIngredients	 
(
    ProductId INT FOREIGN KEY REFERENCES Products(Id),
    IngredientId INT FOREIGN KEY REFERENCES Ingredients(Id)

	PRIMARY KEY(ProductId, IngredientId)
)

