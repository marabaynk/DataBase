
CREATE PROCEDURE dbo.SelectCarFromId
	@carid INT
AS
	DECLARE @NEWCAR TABLE (Id INT, NextCarId INT, CarModel NVARCHAR(50) NOT NULL, dateOfIssue date NOT NULL, HorsePower INT NOT NULL)
	INSERT INTO @NEWCAR(Id, NextCarId, CarModel, dateOfIssue, HorsePower)
	SELECT Id, Id + 1, CarModel, DateOfIssue, HorsePower
	FROM Car;

	WITH DirectReports (Id, NextCarId, CarModel, dateOfIssue, HorsePower, Level)
	AS
	(
		SELECT Id, Id + 1 AS NextCar, CarModel, DateOfIssue, HorsePower, 0 AS Level
		FROM Car
		WHERE Id = @carid
		UNION ALL


		SELECT N.Id, N.NextCarId, N.CarModel, D.dateOfIssue, D.HorsePower, Level + 1
		FROM @NEWCAR AS N INNER JOIN DirectReports AS D ON N.Id = d.NextCarId 
	)
	SELECT *
	FROM DirectReports
	WHERE Id <> @carid - 1;
