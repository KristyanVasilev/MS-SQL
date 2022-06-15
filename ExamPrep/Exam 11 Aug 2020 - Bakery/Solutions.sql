
--02. Insert
INSERT INTO Distributors ([Name], CountryId, AddressText, Summary) VALUES
('Deloitte & Touche', 2, '6 Arch St #9757',	'Customizable neutral traveling'),
('Congress Title', 13, '58 Hancock St',	'Customer loyalty'),
('Kitchen People', 1, '3 E 31st St #77',	'Triple-buffered stable delivery'),
('General Color Co Inc', 21, '6185 Bohn St #72',	'Focus group'),
('Beck Corporation', 23, '21 E 64th Ave',	'Quality-focused 4th generation hardware')

INSERT INTO Customers (FirstName, LastName, Age, Gender, PhoneNumber, CountryId) VALUES
('Francoise',	'Rautenstrauch', 15,	'M',	'0195698399',	5),
('Kendra',	'Loud', 22,	'F',	'0063631526',	11),
('Lourdes',	'Bauswell', 50,	'M',	'0139037043',	8),
('Hannah',	'Edmison', 18,	'F',	'0043343686',	1),
('Tom',	'Loeza', 31,	'M',	'0144876096',	23),
('Queenie',	'Kramarczyk', 30,	'F',	'0064215793',	29),
('Hiu',	'Portaro', 25,	'M',	'0068277755',	16),
('Josefa',	'Opitz', 43,	'F',	'0197887645',	17)

--03. Update
UPDATE Ingredients
   SET DistributorId = 35
 WHERE [Name] = 'Paprika' OR [Name] ='Poppy' OR [Name] ='Bay Leaf'

UPDATE Ingredients
   SET OriginCountryId = 14	
 WHERE OriginCountryId = 8

--04. Delete
DELETE FROM Feedbacks
 WHERE ProductId = 5 OR CustomerId = 14

 --05.Querying 
  SELECT [Name], Price, [Description]
    FROM Products
ORDER BY Price DESC, [Name] ASC

--5.1
  SELECT ProductId, Rate, [Description], CustomerId, Age, Gender 
    FROM Feedbacks f
    JOIN Customers c ON f.CustomerId = c.Id
   WHERE f.Rate < 5
ORDER BY f.ProductId DESC, f.Rate ASC

--5.2
  SELECT FirstName + ' ' + LastName AS [CustomerName], PhoneNumber, Gender
    FROM Customers
   WHERE Id NOT IN(SELECT CustomerId FROM Feedbacks)
ORDER BY Id	

--5.3
  SELECT c.FirstName, c.Age, c.PhoneNumber 
    FROM Customers c
    JOIN Countries cr ON c.CountryId = cr.Id
   WHERE (c.AGE >= 21 AND c.FirstName like '%an%')
      OR  (c.PhoneNumber LIKE '%38' AND cr.[Name] != 'Greece')
ORDER BY c.FirstName, c.Age

--5.4
  SELECT d.[Name] AS [DistributorName], 
         i.[Name] AS [IngredientName], 
         p.[Name] AS [ProductName], 
         AVG(f.Rate) AS [AverageRate]
    FROM Distributors d
    JOIN Ingredients i ON d.Id = i.DistributorId
    JOIN ProductsIngredients pri ON i.Id = pri.IngredientId
    JOIN Products p ON pri.ProductId = p.Id
    JOIN Feedbacks f ON f.ProductId = p.Id
GROUP BY d.[Name], i.[Name], p.[Name]
  HAVING  AVG(f.Rate) BETWEEN 5 AND 8
ORDER BY d.[Name], i.[Name], p.[Name]

--5.5
 SELECT  temp.CountryName, temp.DisributorName 
   FROM
          (SELECT c.[Name] AS [CountryName],
                  d.[Name] AS [DisributorName],
                  DENSE_RANK() OVER (PARTITION BY c.[Name] ORDER BY COUNT(i.Id) DESC) AS [Ranked]
             FROM Countries c
             JOIN Distributors d ON c.Id = d.CountryId
             JOIN Ingredients i ON d.Id = i.DistributorId
         GROUP BY d.[Name], c.[Name]) AS temp
   WHERE temp.Ranked = 1
ORDER BY temp.CountryName, temp.DisributorName



--06.Programmability 
CREATE VIEW v_UserWithCountries AS
SELECT FirstName + ' ' + LastName AS [CustomerName],
       Age,
       Gender,
       cr.[Name] AS [CountryName]
  FROM Customers c
  JOIN Countries cr ON c.CountryId = cr.Id

SELECT TOP 5 *
  FROM v_UserWithCountries
 ORDER BY Age

--6.1 TRIGGER
CREATE TRIGGER tr_DeleteProducts
ON Products INSTEAD OF DELETE
AS
BEGIN
DELETE FROM Feedbacks
WHERE ProductId = (SELECT Id FROM deleted)

DELETE FROM ProductsIngredients
WHERE ProductId = (SELECT Id FROM deleted)

DELETE FROM Products
WHERE Id = (SELECT Id FROM deleted)
END