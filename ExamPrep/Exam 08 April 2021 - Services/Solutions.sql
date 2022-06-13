--02. Insert
INSERT INTO Employees (FirstName, LastName, Birthdate, DepartmentId) VALUES
('Marlo', 'O''Malley', '1958-9-21', 1),
('Niki', 'Stanaghan', '1969-11-26', 4),
('Ayrton', 'Senna', '1960-03-21', 9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati', '1959-07-20', 5)

INSERT INTO Reports(CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId) VALUES
(1,	1, '2017-04-13', NULL,'Stuck Road on Str.133',	6, 2),
(6,	3, '2015-09-05', '2015-12-06','Charity trail running',	3, 5),
(14, 2, '2015-09-07', NULL,'Falling bricks on Str.58',	5, 2),
(4,	3, '2017-07-03', '2017-07-06','Cut off streetlight on Str.11',	1, 1)

--03. Update
UPDATE Reports
SET CloseDate = GETDATE()
WHERE CloseDate IS NULL

--04. Delete
DELETE FROM Reports
 WHERE StatusId = 4

--05. Querying 
  SELECT [Description], FORMAT (OpenDate, 'dd-MM-yyyy') as OpenDate 
    FROM Reports r
   WHERE EmployeeId IS NULL
ORDER BY r.OpenDate ASC, [Description] ASC

--5.1
  SELECT r.[Description], c.[Name]  FROM Reports r
    JOIN Categories c ON r.CategoryId = c.Id
ORDER BY r.[Description] ASC, c.[Name] ASC

--5.2
  SELECT TOP(5) c.[Name] AS [CategoryName], COUNT(r.Id) AS [ReportsNumber] 
    FROM Reports r
    JOIN Categories c ON r.CategoryId = c.Id
GROUP BY r.CategoryId, c.[Name]
ORDER BY COUNT(r.Id) DESC, c.[Name] ASC

--5.3
  SELECT u.Username, c.[Name] AS [CategoryName]
    FROM Reports r
    JOIN Users u ON u.Id = r.UserId
    JOIN Categories c ON c.Id = r.CategoryId
   WHERE DATEPART(MONTH, r.OpenDate) = DATEPART(MONTH, u.Birthdate) AND DATEPART(DAY, r.OpenDate) = DATEPART(DAY, u.Birthdate)
ORDER BY u.Username ASC, c.[Name] ASC

--5.4
SELECT e.FirstName + ' ' + e.LastName AS [FullName], COUNT(u.Id) AS [UsersCount]
FROM Users u
JOIN Reports r ON u.Id = r.UserId
RIGHT JOIN Employees e ON r.EmployeeId = e.Id
GROUP BY e.FirstName, e.LastName
ORDER BY COUNT(u.Id) DESC, [FullName] ASC

--5.5 ERROR WITH JUDGE!!!
   SELECT 
 DISTINCT
	      CASE
		    WHEN e.FirstName IS NULL OR e.LastName IS NULL THEN 'None'
		    ELSE e.FirstName + ' ' + e.LastName
	      END AS [Employee],
	      ISNULL(d.[Name], 'None') AS [Department],
	      ISNULL(c.[Name], 'None') AS [Category],
	      r.[Description] AS [Description],
	      FORMAT(r.OpenDate, 'dd.MM.yyyy') AS [OpenDate],
	      s.[Label] AS [Status],
	      u.[Name] AS [User]
     FROM Employees e
     JOIN Departments d ON d.Id = e.DepartmentId
     JOIN Categories c ON c.DepartmentId = d.Id
     JOIN Reports r ON r.EmployeeId = e.Id
     JOIN [Status] s ON r.StatusId = s.Id
     JOIN Users u ON r.UserId = u.Id
 ORDER BY [Employee] DESC, [Department], [Category], [Description],
	[OpenDate], [Status], [User]

--06. Programmability  
CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @result INT
	IF (@StartDate IS NULL OR @EndDate IS NULL)
    BEGIN
	RETURN 0
	END

	SET @result = DATEDIFF(HOUR, @StartDate, @EndDate)
    RETURN @result
END

CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @EmpDepart INT = (
		SELECT DepartmentId FROM Employees WHERE Id = @EmployeeId)
		DECLARE @CategId INT = (
		SELECT CategoryId FROM Reports WHERE Id = @ReportId)
		DECLARE @ReportDepart INT = (
		SELECT DepartmentId FROM Categories WHERE Id = @CategId)
			IF (@EmpDepart <> @ReportDepart)
			BEGIN
				ROLLBACK;
				THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1
			END

			UPDATE Reports
			SET EmployeeId = @EmployeeId
			WHERE Id = @ReportId
	COMMIT
END			


