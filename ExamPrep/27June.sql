CREATE DATABASE WMS

--01. Design Database
CREATE TABLE [Clients]
(
	[ClientId] INT PRIMARY KEY IDENTITY,
    [FirstName] VARCHAR(50) NOT NULL,
    [LastName] VARCHAR(50) NOT NULL,
    [Phone] CHAR(12) NOT NULL,
	CHECK (LEN([PHONE]) = 12) --Min Lenght
)

CREATE TABLE [Mechanics]
(
	[MechanicId] INT PRIMARY KEY IDENTITY,
    [FirstName] VARCHAR(50) NOT NULL,
    [LastName] VARCHAR(50) NOT NULL,
    [Address] VARCHAR(255) NOT NULL,
)


CREATE TABLE [Models]
(
	[ModelId] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL UNIQUE,
)

CREATE TABLE [Jobs]
(
	[JobId] INT PRIMARY KEY IDENTITY,
    [ModelId] INT FOREIGN KEY REFERENCES [Models]([ModelId]) NOT NULL,
    [Status] VARCHAR(11) NOT NULL DEFAULT('Pending'), --Default Value
    [ClientId] INT FOREIGN KEY REFERENCES [Clients]([ClientId]) NOT NULL,
    [MechanicId] INT FOREIGN KEY REFERENCES [Mechanics]([MechanicId]),
    [IssueDate] DATE NOT NULL,
    [FinishDate] DATE,

	CHECK ([Status] IN ('Pending', 'In Progress', 'Finished')) --Allowed values
)

CREATE TABLE [Orders]
(
	[OrderId] INT PRIMARY KEY IDENTITY,
    [JobId] INT FOREIGN KEY REFERENCES [Jobs]([JobId]) NOT NULL,
    [IssueDate] DATE,
    [Delivered] BIT NOT NULL DEFAULT(0), --FALSE
)

CREATE TABLE [Vendors]
(
	[VendorId] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE [Parts]
(
	[PartId] INT PRIMARY KEY IDENTITY,
    [SerialNumber] VARCHAR(50) NOT NULL UNIQUE,
    [Description] VARCHAR(255),
    [Price] DECIMAL(6,2) NOT NULL,
    [VendorId] INT FOREIGN KEY REFERENCES [Vendors]([VendorId]) NOT NULL,
    [StockQty] INT NOT NULL DEFAULT(0),

	CHECK ([Price] > 0),
	CHECK ([StockQty] >= 0)
)

CREATE TABLE [OrderParts]
(
	[OrderId] INT FOREIGN KEY REFERENCES [Orders]([OrderId]) NOT NULL,
	[PartId] INT FOREIGN KEY REFERENCES [Parts]([PartId]) NOT NULL,
	[Quantity] INT NOT NULL DEFAULT(1),

	PRIMARY KEY([OrderId],[PartId]),
	CHECK ([Quantity] > 0)
)

CREATE TABLE [PartsNeeded]
(
	[JobId] INT FOREIGN KEY REFERENCES [Jobs]([JobId]) NOT NULL,
	[PartId] INT FOREIGN KEY REFERENCES [Parts]([PartId]) NOT NULL,
	[Quantity] INT NOT NULL DEFAULT(1),

	PRIMARY KEY([JobId],[PartId]),
	CHECK ([Quantity] > 0)
)

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



