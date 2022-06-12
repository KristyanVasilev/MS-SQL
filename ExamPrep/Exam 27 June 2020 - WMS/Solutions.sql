--02. Insert
INSERT INTO Clients (FirstName, LastName, Phone) VALUES
('Teri',     'Ennaco' , '570-889-5187'),
('Merlyn',   'Lawler' , '201-588-7810'),
('Georgene', 'Montezuma' , '925-615-5185'),
('Jettie',   'Mconnell'  , '908-802-3564'),
('Lemuel',   'Latzke' , '631-748-6479'),
('Melodie',	 'Knipp'  , '805-690-1682'),
('Candida',	 'Corbley' , '908-275-8357')

INSERT INTO Parts ([SerialNumber], [Description], Price, VendorId) VALUES
('WP8182119',	'Door Boot Seal', 117.86, 2),
('W10780048',	'Suspension Rod', 42.81, 1),
('W10841140',	'Silicone Adhesive', 6.77, 4),
('WPY055980',	'High Temperature Adhesive', 13.94,	3)

--03.Update
SELECT * 
  FROM Mechanics 
 WHERE FirstName = 'Ryan' AND LastName = 'Harnos'
 -- Ryan Harnos's ID = 3
 SELECT * FROM Jobs 

UPDATE Jobs
   SET MechanicId = 3
 WHERE [Status] = 'Pending'

UPDATE Jobs
   SET [Status] = 'In Progress'
 WHERE [Status] = 'Pending' AND MechanicId = 3

 --04. Delete 
DELETE FROM OrderParts -- First delete all relations!!!
 WHERE OrderId = 19

DELETE FROM Orders 
 WHERE OrderId = 19

 --05. Quering
 --5.1
   SELECT (m.FirstName + ' ' + m.LastName) AS [Mechanic], [j].[Status] AS [Status],
          j.IssueDate AS [IssueDate]
     FROM Mechanics AS m
LEFT JOIN Jobs AS j ON m.MechanicId =j.MechanicId
 ORDER BY m.MechanicId, j.IssueDate, j.JobId

 --5.2
   SELECT (c.FirstName + ' ' + c.LastName) AS [Client],
          DATEDIFF(DAY, j.IssueDate,'2017-04-24') AS [Days going],
		  j.Status
     FROM Clients c
LEFT JOIN Jobs j ON c.ClientId = j.ClientId
    WHERE j.Status != 'Finished'

--5.3
SELECT [Mechanic], AVG([Average Days])
  FROM
     (
     SELECT (m.FirstName + ' ' + m.LastName) AS [Mechanic],
              DATEDIFF(DAY, j.IssueDate, j.FinishDate) AS [Average Days],
     		  m.MechanicId AS Id
       FROM Mechanics AS m
  LEFT JOIN Jobs AS j ON m.MechanicId =j.MechanicId
      WHERE j.Status = 'Finished'
     )   AS [SubQuery]
GROUP BY Mechanic, Id
ORDER BY Id

--5.4
SELECT FirstName + ' ' + LastName AS [Available]
  FROM Mechanics
 WHERE MechanicId NOT IN
       ( SELECT MechanicId FROM Jobs
          WHERE [Status] = 'In Progress'
       GROUP BY MechanicId)

--5.5
SELECT * FROM Orders o
SELECT * FROM OrderParts op
SELECT * FROM Parts p
SELECT * FROM Jobs j
LEFT JOIN Orders o ON o.JobId = j.JobId

SELECT * FROM Parts p
LEFT JOIN OrderParts op ON p.PartId = op.PartId
LEFT JOIN Orders o ON o.OrderId = op.OrderId
LEFT JOIN Jobs j ON j.JobId = o.JobId


SELECT j.JobId, ISNULL(SUM(p.Price * op.Quantity), 0) AS [Total]
FROM Jobs j
LEFT JOIN Orders o ON o.OrderId = j.JobId
LEFT JOIN OrderParts op ON o.OrderId = op.OrderId
LEFT JOIN Parts p ON p.PartId = op.OrderId
WHERE j.Status = 'Finished'
GROUP BY j.JobId
ORDER BY Total DESC, j.JobId

--5.6
SELECT * 
FROM (SELECT p.PartId,
			 p.Description,
			 pn.Quantity AS [Required],
			 p.StockQty AS [In Stock],
			 ISNULL(op.Quantity, 0) AS [Ordered]
		FROM Jobs j
      LEFT JOIN PartsNeeded pn ON pn.JobId = pn.PartId
      LEFT JOIN Parts p ON pn.PartId = p.PartId
      LEFT JOIN Orders o ON o.JobId = j.JobId
      LEFT JOIN OrderParts op ON op.OrderId = o.OrderId
      WHERE j.[Status] <> 'Finished' AND (o.Delivered = 0 OR o.Delivered IS NULL)
    ) AS [SubQuery]
WHERE [Required] > [In Stock] + [Ordered]
ORDER BY [PartId]

--7 Function
CREATE FUNCTION udf_GetCost(@jobId INT)
RETURNS DECIMAL(8,2)
AS
BEGIN
    DECLARE @result DECIMAL(8,2)
    DECLARE @jobsOrderCount INT = (SELECT COUNT(OrderId) FROM Jobs j 
								   LEFT JOIN Orders o ON o.JobId = j.JobId
								   WHERE j.JobId = @jobId)

	IF @jobsOrderCount = 0
    BEGIN
	RETURN 0
	END

	SET @result = (SELECT SUM(p.Price * op.Quantity) FROM Jobs j 
				   LEFT JOIN Orders o ON o.JobId = j.JobId
				   LEFT JOIN OrderParts op ON o.OrderId = op.OrderId
				   LEFT JOIN Parts p ON p.PartId = op.PartId
				   WHERE j.JobId = @jobId)
	RETURN @result
END



