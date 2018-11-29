SELECT TOP 100 * FROM MercedesBenz.dbo.Car
SELECT * FROM MercedesBenz.dbo.Dealer ORDER BY CarAmount
SELECT * FROM MercedesBenz.dbo.Factory
SELECT * FROM MercedesBenz.dbo.[MercedesBenz]
SELECT * FROM MercedesBenz.dbo.Car


SELECT Id,CarModel 
FROM MercedesBenz.dbo.Car 
WHERE IsTransmission = 1

INSERT MercedesBenz.dbo.Car(CarModel,DateOfIssue,HorsePower,IsTransmission)
VALUES ('E-Classe','11.09.2028',70,1);
	

SELECT  create_date, modify_date
FROM sys.tables