USE Bank
GO

--09. Find Full Name
CREATE PROC usp_GetHoldersFullName
AS
SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name]
  FROM AccountHolders

EXEC usp_GetHoldersFullName

--10. People with Balance Higher Than
  CREATE PROC usp_GetHoldersWithBalanceHigherThan(@sumToCompare MONEY) 
      AS
  SELECT FirstName, LastName
    FROM AccountHolders ah
    JOIN Accounts a ON a.AccountHolderId = ah.Id 
GROUP BY FirstName, LastName
  HAVING SUM(Balance) > @sumToCompare
ORDER BY FirstName, LastName

EXEC usp_GetHoldersWithBalanceHigherThan 5000


--11. Future Value Function
-- FV=I*({(1+R)}^T)
-- I = sum, R = yearlyInterestRate, T = year
CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(18,4), @yearlyInterestRate FLOAT, @year INT)
RETURNS DECIMAL(15,4)
AS
BEGIN
    DECLARE @result DECIMAL(15,4)

	SET @result = (@sum * POWER((1 + @yearlyInterestRate), @year))
    RETURN @result
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5) AS [Output]

--12. Calculating Interest
CREATE PROC usp_CalculateFutureValueForAccount (@accountID INT, @yearlyInterestRate FLOAT)
AS
SELECT 
       a.Id AS [Account Id],
       ah.FirstName AS [First Name], 
       ah.LastName AS [Last Name], 
	   a.Balance AS [Current Balance],
       dbo.ufn_CalculateFutureValue(a.Balance, @yearlyInterestRate, 5) AS [Balance in 5 years]
  FROM AccountHolders ah
  JOIN Accounts a ON a.AccountHolderId = ah.Id 
 WHERE a.Id = @accountID

EXEC usp_CalculateFutureValueForAccount 1, 0.1

--13. *Cash in User Games Odd Rows
USE Diablo
GO

CREATE FUNCTION ufn_CashInUsersGames (@gameNAme VARCHAR(100))
RETURNS TABLE
AS
  RETURN (SELECT SUM(k.SumCash) AS TotalCash
    FROM (SELECT Cash AS SumCash,
	      ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNumber
    FROM Games AS g
	JOIN UsersGames AS ug ON ug.GameId = g.Id
   WHERE [Name] = @gameName) AS k
WHERE k.RowNumber % 2 = 1)

SELECT * FROM ufn_CashInUsersGames ('Lisbon')
