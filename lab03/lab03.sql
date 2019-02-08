--A. Четыре функции
--Скалярная функция
USE MercedesBenz
GO
IF OBJECT_ID (N'dbo.AverageHP', N'FN') IS NOT NULL
    DROP FUNCTION dbo.AverageHP
GO
CREATE FUNCTION dbo.AverageHP()
RETURNS int
WITH SCHEMABINDING
AS
BEGIN
       RETURN (SELECT AVG(HorsePower) FROM dbo.Car)
END
GO

SELECT dbo.AverageHP()

--Подставляемая табличная функция
GO

DROP FUNCTION IF EXISTS dbo.ExpensiveOrder

GO

CREATE FUNCTION dbo.NewCar()
RETURNS TABLE
AS
RETURN (
    SELECT Factory.[CarAmount] AS TotalCarFactory, Dealer.[CarAmount] AS TotalCArDealer, [MercedesBenz].DeliveryDate
    FROM Factory JOIN [MercedesBenz] ON Factory.Id = [MercedesBenz].FactoryId
	JOIN Dealer ON Dealer.Id = [MercedesBenz].DealerId
    WHERE [MercedesBenz].CarId > 50
    )
GO

SELECT *
FROM dbo.NewCar()
GO


--Многооператорная табличная функция
GO

DROP FUNCTION IF EXISTS dbo.sportCar

GO

CREATE FUNCTION dbo.sportCar()
RETURNS @orders TABLE 
(
    TotalCarFactory NVARCHAR(50) NOT NULL,
	TotalCarDealer NVARCHAR(50) NOT NULL,
	DeliveryDate date
)
AS
BEGIN
    INSERT INTO @orders 
    SELECT Factory.[CarAmount] AS TotalCarFactory, Dealer.[CarAmount] AS TotalCArDealer, [MercedesBenz].DeliveryDate
    FROM Factory JOIN [MercedesBenz] ON Factory.Id = [MercedesBenz].FactoryId
	JOIN Dealer ON Dealer.Id = [MercedesBenz].DealerId
	JOIN Car ON Car.Id = [MercedesBenz].CarId
    WHERE CarModel = 'E-Classe' AND HorsePower > 200
RETURN
END
GO

SELECT *
FROM dbo.sportCar()


-- Рекурсивная функция
GO
    DROP FUNCTION IF EXISTS dbo.GetAllCars
GO

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
GO

SELECT *
FROM dbo.GetAllCars()


--B. Четыре хранимых процедуры

-- Хранимая процедура без параметров или с параметрами
GO

DROP PROCEDURE IF EXISTS dbo.SelectGLS

GO
CREATE PROCEDURE dbo.SelectGLS AS
BEGIN
    SELECT COUNT(CarId) AS countCars FROM dbo.[MercedesBenz] JOIN dbo.Car ON dbo.[MercedesBenz].CarId = dbo.Car.Id
	WHERE Car.CarModel = 'GLS-Classe'
END
GO

EXEC dbo.SelectGLS
GO

--Рекурсивная хранимая процедура или хранимую процедур с рекурсивным ОТВ
GO
DROP PROCEDURE IF EXISTS dbo.SelectCarFromId
GO

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
		WHERE Id = 1
		UNION ALL


		SELECT N.Id, N.NextCarId, N.CarModel, D.dateOfIssue, D.HorsePower, Level + 1
		FROM @NEWCAR AS N INNER JOIN DirectReports AS D ON N.Id = d.NextCarId 
	)
	SELECT *
	FROM DirectReports
	WHERE Id <> @carid - 1;
GO

EXEC dbo.SelectCarFromId @carid = 30
GO


--Хранимая процедура с курсором
DROP PROCEDURE IF EXISTS dbo.CursSearch
GO
CREATE PROCEDURE CursSearch AS
BEGIN
-- Объявляем переменную
	DECLARE @TableName nvarchar(255)
	DECLARE @TableCatalog nvarchar(255)
-- Объявляем курсор
	DECLARE TableCursor CURSOR FOR
		SELECT TABLE_NAME, TABLE_CATALOG FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_TYPE = 'BASE TABLE'
-- Открываем курсор и выполняем извлечение первой записи 
		OPEN TableCursor
			FETCH NEXT FROM TableCursor INTO @TableName, @TableCatalog
-- Проходим в цикле все записи из множества
			WHILE @@FETCH_STATUS = 0
			BEGIN
			SELECT @TableName AS NAMETABLE, @TableCatalog AS TABLECATALOG
			FETCH NEXT FROM TableCursor INTO @TableName, @TableCatalog 
			END
		CLOSE TableCursor
	DEALLOCATE TableCursor
END
GO
EXEC CursSearch
GO


-- Хранимую процедуру доступа к метаданным
IF OBJECT_ID ( N'dbo.ScalarFunc', 'P' ) IS NOT NULL
      DROP PROCEDURE dbo.ScalarFunc
GO
CREATE PROCEDURE ScalarFunc 
AS
BEGIN
    SELECT TABLE_NAME
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG='MercedesBenz'
END;
GO

EXECUTE ScalarFunc;
GO

--C. Два DML триггера

--Триггер AFTER
DROP TRIGGER IF EXISTS dbo.Car_INSERT

GO
CREATE TRIGGER Car_INSERT
ON Car
AFTER INSERT
AS
BEGIN
	DECLARE @CarCount int;
    SET @CarCount = 30
    WHILE @CarCount > 0
		BEGIN
			INSERT INTO [MercedesBenz] (CarId, DealerId, FactoryId, DeliveryDate)
			SELECT ABS(CHECKSUM(NewId()) %100), ABS(CHECKSUM(NewId()) %100)+1, ABS(CHECKSUM(NewId()) %100)+2, '2222-11-11'
			FROM INSERTED
			SET @CarCount = @CarCount - 1;
		END;
END;
GO

INSERT INTO Car(CarModel, DateOfIssue, HorsePower, IsTransmission)
VALUES('BMSTU', '2018-09-11', 333, 1)

SELECT *
FROM Car


--Триггер INSTEAD OF
DROP TRIGGER IF EXISTS DenyInsert
GO
CREATE TRIGGER DenyInsert 
ON Factory
INSTEAD OF INSERT
AS
BEGIN
    RAISERROR('You cant add a new factory.' ,10, 1);
END;
GO

INSERT INTO Factory(City, CarAmount)
VALUES('MoscowNeverSleep', 555)

SELECT * FROM Factory