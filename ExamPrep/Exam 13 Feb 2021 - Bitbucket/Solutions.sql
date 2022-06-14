--02. Insert
INSERT INTO Files ([Name], Size, ParentId, CommitId) VALUES
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3, 3),
('Controller.php', 353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix',	7662.92, 7, 7)

INSERT INTO Issues (Title, IssueStatus, RepositoryId	, AssigneeId) VALUES
('Critical Problem with HomeController.cs file', 'open', 1,	4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs',	'closed',8,	2),
('Unreachable code in Index.cs', 'open', 9,	8)

--03. Update
UPDATE Issues
SET IssueStatus = 'closed'
WHERE Id = 6

--04. Delete

DELETE FROM RepositoriesContributors
 WHERE RepositoryId = ( SELECT Id FROM Repositories
 WHERE [Name] = 'Softuni-Teamwork')

DELETE FROM Files
 WHERE CommitId = 
       (SELECT c.Id 
        FROM Repositories r
        JOIN Commits c ON c.RepositoryId = r.Id
        WHERE r.[Name] = 'Softuni-Teamwork')

DELETE FROM Commits
 WHERE RepositoryId = ( SELECT Id FROM Repositories
 WHERE [Name] = 'Softuni-Teamwork')

DELETE FROM Issues
 WHERE RepositoryId = ( SELECT Id FROM Repositories
 WHERE [Name] = 'Softuni-Teamwork')

DELETE FROM Repositories
 WHERE [Name] = 'Softuni-Teamwork'


--05. Querying 
  SELECT Id, [Message], RepositoryId, ContributorId  
    FROM Commits
ORDER BY Id, [Message], RepositoryId, ContributorId 

--5.1
  SELECT Id,[Name], Size FROM Files
   WHERE [Name] LIKE '%html' AND Size > 1000
ORDER BY Size DESC, id ASC, [Name] ASC

--5.2
SELECT i.Id, u.Username + ' ' + ':' + ' ' + I.Title AS [IssueAssignee] FROM Issues i
JOIN Users u ON u.Id = i.AssigneeId
ORDER BY i.Id DESC, [IssueAssignee] ASC

--5.3
SELECT fs.Id, fs.[Name],CONCAT(fs.Size, 'KB') AS [Size] FROM Files f
FULL OUTER JOIN files fs ON f.ParentId = fs.Id
WHERE f.Id IS NULL
ORDER BY fs.Id, fs.[Name], fs.Size DESC

--5.4
   SELECT TOP(5) r.Id, r.[Name], COUNT(c.Id) AS [Commits]
     FROM Commits c
LEFT JOIN Repositories r ON r.Id = c.RepositoryId
LEFT JOIN RepositoriesContributors rc ON rc.RepositoryId = r.Id
 GROUP BY r.Id, r.[Name]
 ORDER BY [Commits] DESC, r.Id ASC, r.[Name] ASC

--5.5
  SELECT u.Username, AVG(f.Size) AS [Size] 
    FROM Files f
    JOIN Commits c ON f.CommitId = c.id
    JOIN Users u ON u.Id = c.ContributorId
   WHERE c.ContributorId IN
          (SELECT u.Id FROM Users u
             JOIN RepositoriesContributors rc ON rc.ContributorId = u.Id
             JOIN Repositories r ON r.Id = rc.RepositoryId
         GROUP BY u.Id) 
GROUP BY u.Username
ORDER BY AVG(f.Size) DESC, u.Username ASC

--06. Programmability 
 CREATE FUNCTION udf_AllUserCommits(@username NVARCHAR(30)) 
RETURNS INT
     AS
  BEGIN

DECLARE @UserId INT = (SELECT Id FROM Users 
			              WHERE Username = @username)

 RETURN   (SELECT COUNT(*) FROM Commits
	        WHERE ContributorId = @UserId)
    END
--SELECT dbo.udf_AllUserCommits('UnderSinduxrein')

--6.1
CREATE PROC usp_SearchForFiles(@fileExtension VARCHAR(20))
AS
SELECT f.Id, f.[Name], CONCAT(f.Size, 'KB') AS [Size]
FROM Files f
WHERE f.[Name] LIKE '%' + @fileExtension
ORDER BY f.Id, f.[Name], f.Size DESC

EXEC usp_SearchForFiles 'txt'