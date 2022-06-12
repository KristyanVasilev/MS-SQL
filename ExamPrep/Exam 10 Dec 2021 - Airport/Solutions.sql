--02. Insert
DECLARE @idx INT = 5;
  WHILE (@idx <= 15)
  BEGIN
		INSERT INTO Passengers (Fullname, Email)
		SELECT FirstName + ' ' + LastName AS [FullName],
			   CONCAT(FirstName,LastName,'@gmail.com')
		FROM Pilots
		WHERE Id = @idx
		SET @idx += 1;
	END

--03. Update
SELECT * FROM Aircraft
 WHERE Condition = 'C' OR Condition = 'B' AND FlightHours IS NULL OR FlightHours <= 100 AND [YEAR] >= 2013

UPDATE Aircraft
   SET Condition = 'A'
 WHERE Condition IN('C','B')
   AND (FlightHours = 0 OR FlightHours <= 100 OR FlightHours IS NULL)
   AND [YEAR] >= 2013

 --04. Delete
DELETE FROM Passengers
 WHERE LEN(FullName) <= 10

 --05. Querying
 SELECT Manufacturer, Model, FlightHours, Condition FROM Aircraft
 ORDER BY FlightHours DESC

 --5.1
 SELECT p.FirstName, p.LastName, a.Manufacturer, a.Model, a.FlightHours FROM Pilots p
 LEFT JOIN PilotsAircraft pa ON p.Id = pa.PilotId
 LEFT JOIN  Aircraft a ON a.Id = pa.AircraftId
     WHERE a.FlightHours IS NOT NULL AND a.FlightHours >= 0 AND a.FlightHours < 304
  ORDER BY a.FlightHours DESC, p.FirstName ASC

 --5.2
SELECT TOP (20) Fd.Id, fd.[Start], p.FullName, a.AirportName, fd.TicketPrice 
      FROM FlightDestinations fd
 LEFT JOIN Airports a ON a.Id = fd.AirportId
 LEFT JOIN Passengers p ON fd.PassengerId = p.Id
     WHERE DATEPART(DAY, fd.[Start]) % 2 = 0
  ORDER BY fd.TicketPrice DESC, a.AirportName ASC

--5.3
   SELECT a.Id, a.Manufacturer, a.FlightHours,
          COUNT(f.AircraftId) AS [FlightDestinationsCount],
		  ROUND(AVG(f.TicketPrice), 2) AS [AvgPrice]
     FROM FlightDestinations f
LEFT JOIN Aircraft a ON f.AircraftId = a.Id
 GROUP BY  a.Id, f.AircraftId, a.Manufacturer, a.FlightHours
   HAVING COUNT(AircraftId) >= 2
 ORDER BY [FlightDestinationsCount] DESC,a.Id

 --5.4
   SELECT p.FullName, 
          COUNT(p.Id) AS[CountOfAircraft],
          SUM(f.TicketPrice) AS [TotalPayed]
     FROM Passengers p
LEFT JOIN FlightDestinations f ON p.Id = f.PassengerId
    WHERE SUBSTRING(FullName,2,1) = 'a'
 GROUP BY Fullname, PassengerId
   HAVING COUNT(PassengerId) > 1
 ORDER BY Fullname

--5.5
SELECT a.AirportName, f.[Start] AS [DayTime], f.TicketPrice, p.FullName, af.Manufacturer,af.Model 
FROM FlightDestinations f
LEFT JOIN Airports a ON f.AirportId = a.Id
LEFT JOIN Aircraft af ON af.Id = f.AircraftId
LEFT JOIN Passengers p ON p.Id = f.PassengerId
WHERE DATEPART(HOUR, f.[Start]) >= 6 AND DATEPART(HOUR, f.[Start]) <= 20 AND f.TicketPrice > 2500
ORDER BY af.Model

--6.0 Programmability 
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(MAX))
RETURNS INT
AS
BEGIN
    DECLARE @result INT 

	    SET @result =   (SELECT COUNT(p.Id)       
                           FROM Passengers p
                           JOIN FlightDestinations f ON p.Id = f.PassengerId
                          WHERE p.Email = @email
                       GROUP BY PassengerId)
	    IF (@result IS NULL)
	   SET @result = 0;
	RETURN @result
END

--6.1
CREATE PROC usp_SearchByAirportName(@airportName VARCHAR(70))
AS
   SELECT a.AirportName, p.FullName, 
     CASE
			WHEN TicketPrice <= 400 THEN 'Low'
			WHEN TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
			ELSE 'High'
      END AS [LevelOfTicketPrice], 
                  af.Manufacturer, 
                  af.Condition, 
                  aft.TypeName
     FROM FlightDestinations f
LEFT JOIN Airports a ON f.AirportId = a.Id
LEFT JOIN Aircraft af ON af.Id = f.AircraftId
LEFT JOIN Passengers p ON p.Id = f.PassengerId
LEFT JOIN AircraftTypes aft ON aft.Id = af.TypeId
    WHERE a.AirportName = @airportName
 ORDER BY Manufacturer,Fullname


--EXEC usp_GetEmployeesSalaryAboveNumber 48100