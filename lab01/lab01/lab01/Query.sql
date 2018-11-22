SELECT TOP 100 * FROM MercedesBenz.dbo.Car
SELECT * FROM MercedesBenz.dbo.Dealer ORDER BY CarAmount
SELECT * FROM MercedesBenz.dbo.Factory
SELECT * FROM MercedesBenz.dbo.[MercedesBenz]

SELECT Id,CarModel FROM MercedesBenz.dbo.Car WHERE IsTransmission = 1

INSERT INTO MercedesBenz.dbo.Factory VALUES (
'MSK',
'UK',
10);