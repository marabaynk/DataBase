-- Задание 1
-- Cars
SELECT TOP 5 CarModel, DateOfIssue, HorsePower, IsTransmission
FROM Car
FOR XML AUTO, ELEMENTS
-- Factories
SELECT TOP 5 City, CarAmount
FROM Factory
FOR XML RAW, TYPE
-- Dealers
SELECT TOP 5 City, DealerName, CarAmount
FROM Dealer
FOR XML AUTO, ELEMENTS
-- MercedesBenz
SELECT TOP 5 CarId, DealerId, FactoryId, DeliveryDate
FROM MercedesBenz
FOR XML AUTO, ELEMENTS
-- EXPLICIT
SELECT 1 as tag, NULL as parent,
City as 'Dealer!1!City',
DealerName as 'Dealer!1!DealerName',
CarAmount as 'Dealer!1!CarAmount'
FROM Dealer
FOR XML EXPLICIT

-- Задание 2
DECLARE @iord int
DECLARE @ord xml
SELECT @ord = c FROM OPENROWSET(BULK 'Z:\Desktop\DataBase\lab05\test.xml', SINGLE_BLOB) AS TEMP(c)
EXEC sp_xml_preparedocument @iord OUTPUT, @ord;

SELECT * FROM OPENXML (@iord, N'/ROOT/Dealer', 2)
WITH (City NVARCHAR(100), DealerName NVARCHAR(100), CarAmount INT);

EXEC sp_xml_removedocument @iord;

