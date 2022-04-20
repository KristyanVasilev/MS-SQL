--Problem 13.	Movies Database
CREATE DATABASE Movies

CREATE TABLE Directors 
(
    Id INT PRIMARY KEY NOT NULL,
    DirectorName VARCHAR(90) NOT NULL,
    Notes VARCHAR(MAX)
)

INSERT INTO Directors(Id, DirectorName, Notes) VALUES
(1, 'Sofia', NULL),
(2, 'Peter', NULL),
(3, 'George', NULL),
(4, 'Mitko', NULL),
(5, 'Lube', NULL)



CREATE TABLE Genres  
(
    Id INT PRIMARY KEY NOT NULL,
    GenreName VARCHAR(90) NOT NULL,
    Notes VARCHAR(MAX)
)

INSERT INTO Genres(Id, GenreName, Notes) VALUES
(1, 'Horror', NULL),
(2, 'Fantasy', NULL),
(3, 'Comedy', NULL),
(4, 'Other Genre', NULL),
(5, 'Documentary', NULL)


CREATE TABLE Categories   
(
    Id INT PRIMARY KEY NOT NULL,
    CategoryName VARCHAR(90) NOT NULL,
    Notes VARCHAR(MAX)
)

INSERT INTO Categories(Id, CategoryName, Notes) VALUES
(1, 'A', NULL),
(2, 'B', NULL),
(3, 'C', NULL),
(4, 'D', NULL),
(5, 'E', NULL)

CREATE TABLE Movies    
(
    Id INT PRIMARY KEY NOT NULL,
    Titles VARCHAR(90) NOT NULL,
    DirectorId INT NOT NULL,
    CopyrightYear DATE,
    [Length] TIME NOT NULL,
    GenreId INT NOT NULL,
    CategoryId INT NOT NULL,
    Rating INT,
    Notes VARCHAR(MAX)
)

INSERT INTO Movies(Id, Titles,DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating, Notes) VALUES
(1, 'The Nun', 1, NULL, '02:29:49', 1, 1, 8, Null),
(2, 'Interstelar', 2, NULL, '02:29:49', 2, 2, 9, Null),
(3, 'Blabla', 3, NULL, '02:19:59', 3, 3, 6, Null),
(4, 'LAla', 3, NULL, '04:29:39', 3, 3, 7, Null),
(5, 'Lala Land', 3, NULL, '01:59:59', 3, 3, 5, Null)


--SELECT * FROM Movies