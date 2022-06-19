--02. Insert
INSERT INTO Volunteers ([Name], PhoneNumber, [Address], AnimalId, DepartmentId) VALUES
('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
('Dimitur Stoev', '0877564223', NULL, 42, 4),
('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO Animals ([Name], BirthDate, OwnerId, AnimalTypeId) VALUES
('Giraffe',	'2018-09-21', 21, 1),
('Harpy Eagle',	'2015-04-17', 15, 3),
('Hamadryas Baboon', '2017-11-02', NULL, 1),
('Tuatara',	'2021-06-30', 2, 4)

--03. Update
UPDATE Animals
   SET OwnerId = 4
 WHERE OwnerId IS NULL

--04. Delete
DELETE 
  FROM Volunteers
 WHERE DepartmentId = 2

DELETE 
  FROM VolunteersDepartments
 WHERE Id = 2

--Querying 
--05. Volunteers
  SELECT [Name], PhoneNumber,[Address],AnimalId, DepartmentId 
    FROM Volunteers
ORDER BY [Name], AnimalId, DepartmentId

--6. Animals data
  SELECT a.[Name], aat.AnimalType, FORMAT(a.Birthdate, 'dd.MM.yyyy') 
    FROM Animals a
    JOIN AnimalTypes aat ON a.AnimalTypeId = aat.Id
ORDER BY a.[Name]

--7. Owners and Their Animals
  SELECT TOP(5) o.[Name] AS [Owner], COUNT(a.Id) AS [CountOfAnimals] 
    FROM Owners o
    JOIN Animals a ON o.Id = a.OwnerId
GROUP BY o.[Name]
ORDER BY COUNT(a.Id) DESC, o.[Name] ASC

--8. Owners, Animals and Cages
  SELECT o.[Name] + '-' +a.[Name] AS [OwnersAnimals], o.PhoneNumber, c.Id AS [CageId] 
    FROM Owners o 
    JOIN Animals a ON o.Id = a.OwnerId
    JOIN AnimalsCages ac ON ac.AnimalId = a.Id
    JOIN Cages c ON c.Id = ac.CageId
GROUP BY o.[Name], o.PhoneNumber, a.[Name], a.AnimalTypeId, c.Id
  HAVING a.AnimalTypeId = 1
ORDER BY o.[Name], a.[Name] DESC

select * from AnimalTypes

--9. Volunteers in Sofia
  SELECT [Name], PhoneNumber, REPLACE([Address],'Sofia , ',' ')AS [Address] 
    FROM
         (SELECT [Name], PhoneNumber, REPLACE([Address],'Sofia,',' ') AS [Address] 
            FROM Volunteers
           WHERE DepartmentId = 2 AND [Address] LIKE '%SOFIA%')AS SUB
ORDER BY [Name]

--10. Animals for Adoption
  SELECT a.[Name], DATEPART(YEAR,a.Birthdate ) AS [BirthYear] ,att.AnimalType 
    FROM Animals a
    JOIN AnimalTypes att ON a.AnimalTypeId = att.Id
   WHERE OwnerId IS NULL AND DATEDIFF(YEAR, BirthDate, GETDATE()) < 5 AND AnimalTypeId != 3
ORDER BY a.[Name]

SELECT * FROM AnimalTypes

--Programmability 
--11. All Volunteers in a Department
CREATE FUNCTION udf_GetVolunteersCountFromADepartment(@VolunteersDepartment VARCHAR(30)) 
        RETURNS INT
             AS
          BEGIN
         RETURN (SELECT COUNT(v.Id)
		   FROM VolunteersDepartments vd
	       JOIN Volunteers v ON v.DepartmentId = vd.Id
	      WHERE vd.DepartmentName = @VolunteersDepartment)
            END

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')

--12. Animals with Owner or Not
CREATE PROC usp_AnimalsWithOwnersOrNot (@AnimalName VARCHAR(30))
         AS
     SELECT a.[Name],
       CASE
			WHEN a.OwnerId IS NULL THEN 'For adoption'
			ELSE o.[Name]
        END AS [OwnersName]
       FROM Animals a
  LEFT JOIN Owners o ON a.OwnerId = o.Id
      WHERE a.[Name] = @AnimalName

EXEC usp_AnimalsWithOwnersOrNot 'Pumpkinseed Sunfish'
EXEC usp_AnimalsWithOwnersOrNot 'Hippo'


