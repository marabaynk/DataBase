sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
sp_configure 'clr enabled', 1
GO
RECONFIGURE
GO
EXEC sp_configure 'clr strict security', 0; 
RECONFIGURE;

DROP FUNCTION GetRandomNumber;
DROP AGGREGATE CountCar;
DROP FUNCTION StringLength;
DROP PROCEDURE AverageHorsePower;
DROP TRIGGER DeleteCar;
DROP TABLE dbo.TestCar;
DROP TYPE Car;
DROP ASSEMBLY SqlFunc;

CREATE ASSEMBLY SqlFunc
AUTHORIZATION dbo
FROM 'C:\Users\Koi\Desktop\DataBase\MercedesBenz\MercedesBenz\bin\Debug\MercedesBenz.dll'
WITH PERMISSION_SET = SAFE
GO

-- 1) Определяемую пользователем скалярную функцию CLR 
CREATE FUNCTION GetRandomNumber ()
RETURNS INT
AS
EXTERNAL NAME
SqlFunc.[SqlFunc].GetRandomNumber
GO
SELECT dbo.GetRandomNumber() AS RandomNumber
GO
-- 2) Пользовательскую агрегатную функцию CLR 
CREATE AGGREGATE CountCar( @instr int )
RETURNS INT
EXTERNAL NAME
SqlFunc.[SqlAggregate1]
GO

SELECT dbo.CountCar(CarAmount) AS NumberOfCar
FROM MercedesBenz.dbo.Factory
GO
SELECT* FROM MercedesBenz.dbo.Car where CarModel = 'E-Classe'

-- 3) Определяемую пользователем табличную функцию CLR 
go
CREATE FUNCTION StringLength ( @input NVARCHAR(4000) )
RETURNS TABLE 
(
   word NVARCHAR(4000), 
   len INT
)
AS
EXTERNAL NAME
SqlFunc.[UserDefinedFunctions].TableFunction
GO

SELECT * FROM dbo.StringLength('Car')
GO
-- 4) Хранимую процедуру CLR

CREATE PROCEDURE AverageHorsePower( @bindingg NVARCHAR(4000) )
AS
External Name
SqlFunc.[StoredProcedures].AvgCarNum
GO

EXEC AverageHorsePower 'GLS-Classe'
GO

--5) Триггер
CREATE TRIGGER DeleteCar
ON Car
INSTEAD OF DELETE
AS
EXTERNAL NAME
SqlFunc.[Triggers].SqlTrigger1
GO

DELETE Car
WHERE Id = 1
GO

--6) Определяемы пользователем тип данных

CREATE TYPE dbo.Car
EXTERNAL NAME SqlFunc.[Car];
GO

CREATE TABLE dbo.TestCar
( 
  id INT IDENTITY(1,1) NOT NULL, 
  isTransmission Car NOT NULL,
  [CarModel] NVARCHAR(50) NOT NULL
);
GO


INSERT INTO dbo.TestCar(isTransmission, [CarModel]) VALUES('1', 'BMW'); 
SELECT id, isTransmission.ToString() AS isTransmission, [CarModel]
FROM dbo.TestCar;

