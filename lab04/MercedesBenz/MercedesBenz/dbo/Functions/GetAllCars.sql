
CREATE FUNCTION dbo.GetAllCars()
RETURNS @AllCars TABLE 
(
	Id	INT NOT NULL,  
	NextCarId INT,
	CarModel NVARCHAR(50) NOT NULL,
	dateOfIssue date NOT NULL,
	HorsePower INT NOT NULL,
	Level INT
)


AS

BEGIN
	DECLARE @NEWCAR TABLE (Id INT, NextCarId INT, CarModel NVARCHAR(50) NOT NULL, dateOfIssue date NOT NULL, HorsePower INT NOT NULL)
	INSERT INTO @NEWCAR(Id, NextCarId, CarModel, dateOfIssue, HorsePower)
	SELECT Id, Id + 1, CarModel, DateOfIssue, HorsePower
	FROM Car;

	WITH DirectReports (Id, NextCarId, CarModel, dateOfIssue, HorsePower, Level)
	AS
	(
		SELECT Id, Id + 1 AS NextCar, CarModel, DateOfIssue, HorsePower, 0 AS Level
		FROM Car
		WHERE Id = 1
		UNION ALL


		SELECT N.Id, N.NextCarId, N.CarModel, D.dateOfIssue, D.HorsePower, Level + 1
		FROM @NEWCAR AS N INNER JOIN DirectReports AS D ON N.Id = d.NextCarId 
	)

	INSERT INTO @AllCars (Id, NextCarId, CarModel, dateOfIssue, HorsePower, Level)
	SELECT Id, NextCarId, CarModel, dateOfIssue, HorsePower, Level
		FROM DirectReports;
	RETURN
END
