--02. Insert
INSERT INTO Cigars (CigarName, BrandId, TastId, SizeId, PriceForSingleCigar, ImageURL) VALUES
('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses (Town, Country, Streat, ZIP) VALUES
('Sofia', 'Bulgaria', '18 Bul. Vasil levski', '1000'),
('Athens', 'Greece', '4342 McDonald Avenue', '10435'),
('Zagreb', 'Croatia', '4333 Lauren Drive', '10000')

--03. Update
UPDATE Cigars
SET PriceForSingleCigar *= 1.20
WHERE Id IN (SELECT c.Id
FROM Cigars AS c 
JOIN Tastes AS t ON c.TastId = t.Id
WHERE t.TasteType = 'Spicy')

UPDATE Brands
SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL

--04. Delete
DELETE FROM Clients
 WHERE AddressId IN(
SELECT Id FROM Addresses
 WHERE Country LIKE 'C%')

DELETE FROM Addresses
 WHERE Country LIKE 'C%'

 --05. Querying 
  SELECT CigarName, PriceForSingleCigar, ImageURL 
    FROM Cigars
ORDER BY PriceForSingleCigar ASC, CigarName DESC

 --5.1
   SELECT c.Id, c.CigarName, c.PriceForSingleCigar, t.TasteType,           t.TasteStrength
     FROM Cigars c
LEFT JOIN Tastes t ON c.TastId = t.Id
    WHERE t.TasteType = 'Earthy' OR t.TasteType = 'Woody'
 ORDER BY c.PriceForSingleCigar DESC

--5.2
SELECT Id, FirstName + ' ' + LastName AS [ClientName], Email FROM Clients
WHERE Id NOT IN (
SELECT ClientId FROM ClientsCigars 
GROUP BY ClientId)
ORDER BY [ClientName] ASC

--5.3
  SELECT TOP(5) c.CigarName, c.PriceForSingleCigar, c.ImageURL
    FROM Cigars c
    JOIN Sizes s ON c.SizeId = s.Id
   WHERE s.[Length] >= 12 AND (c.CigarName LIKE '%ci%' OR c.PriceForSingleCigar > 50) AND s.RingRange > 2.55
ORDER BY c.CigarName ASC, c.PriceForSingleCigar DESC

--5.4
  SELECT c.FirstName+ ' ' + c.LastName AS [FullName],
         a.Country,
         a.ZIP, 
         CONCAT('$', MAX(cs.PriceForSingleCigar)) AS [CigarPrice]  
    FROM Clients c
    JOIN ClientsCigars cc ON c.Id = cc.ClientId
    JOIN Cigars cs ON cc.CigarId = cs.Id
    JOIN Addresses a ON c.AddressId = a.Id
GROUP BY c.Id, a.Country, c.FirstName,c.LastName, a.ZIP
  HAVING c.Id IN
         (SELECT c.Id 
            FROM Clients c
            JOIN Addresses a ON c.AddressId = a.Id
           WHERE a.ZIP NOT LIKE '%[^0-9]%')
ORDER BY [FullName], MAX(cs.PriceForSingleCigar) DESC

--5.5
  SELECT c.LastName, 
         AVG(s.Length) AS [CiagrLength], 
         CEILING(AVG(s.RingRange)) AS [CiagrRingRange]
    FROM Clients c
    JOIN ClientsCigars cc ON c.Id = cc.ClientId
    JOIN Cigars cs ON cc.CigarId = cs.Id
    JOIN Sizes s ON cs.SizeId = s.Id
GROUP BY c.LastName
ORDER BY CiagrLength DESC

--06. Programmability 
 CREATE FUNCTION udf_ClientWithCigars(@name NVARCHAR(30)) 
RETURNS INT
     AS
  BEGIN
 RETURN (SELECT COUNT(cs.Id)
           FROM Clients c
           JOIN ClientsCigars cc ON c.Id = cc.ClientId
           JOIN Cigars cs ON cc.CigarId = cs.Id
          WHERE c.FirstName = @name)
    END

--6.1
CREATE PROC usp_SearchByTaste(@taste VARCHAR(20))
AS
   SELECT c.CigarName, 
          CONCAT('$',c.PriceForSingleCigar) AS [Price], 
          t.TasteType, 
          b.BrandName,
          CONCAT(s.[Length],' ', 'cm') AS [CigarLength], 
          CONCAT(s.RingRange,' ', 'cm') AS [CigarRingRange]
    FROM Tastes t
    JOIN Cigars c ON c.TastId = t.Id
    JOIN Sizes s ON c.SizeId = s.Id
    JOIN Brands b ON b.Id = c.BrandId
   WHERE t.TasteType = @taste
ORDER BY s.[Length] ASC, s.RingRange DESC

EXEC usp_SearchByTaste 'Woody'