--A. Четыре функции
--Скалярная функция
USE CinemaDB
GO
IF OBJECT_ID (N'dbo.AveragePrice', N'FN') IS NOT NULL
    DROP FUNCTION dbo.AveragePrice
GO
CREATE FUNCTION dbo.AveragePrice()
RETURNS smallmoney
WITH SCHEMABINDING
AS
BEGIN
       RETURN (SELECT AVG(Price) FROM dbo.[Sessions])
END
GO

SELECT dbo.AveragePrice()


--Подставляемая табличная функция
USE CinemaDB
GO
IF OBJECT_ID (N'dbo.Expensive', N'FN') IS NOT NULL
    DROP FUNCTION dbo.Expensive
GO

CREATE FUNCTION dbo.Expensive()
RETURNS TABLE
AS
RETURN (
    SELECT [Sessions].Id, [Sessions].[DateTime], Films.[Name]
    FROM [Sessions] JOIN Films ON [Sessions].FilmId = Films.Id
    WHERE [Sessions].Price > 800
    )
GO


SELECT *
FROM dbo.Expensive()
GO


--Многооператорная табличная функция
USE CinemaDB
GO
IF OBJECT_ID (N'dbo.InexpensiveInVIPHalls', N'FN') IS NOT NULL
    DROP FUNCTION dbo.InexpensiveInVIPHalls
GO

CREATE FUNCTION dbo.InexpensiveInVIPHalls()
RETURNS @FilmsInVIP TABLE 
(
    [Name] NVARCHAR(50) NOT NULL,
	HallId	INT NOT NULL,
	[Row] INT NOT NULL,
	Seat INT NOT NULL 
)
AS
BEGIN
    INSERT INTO @FilmsInVIP 
    SELECT F.[Name], H.Id, T.[Row], T.Seat
    FROM Tickets T JOIN [Sessions] S ON T.SessionId = S.Id JOIN Films F ON S.FilmId = F.Id JOIN Halls H ON S.HallId = H.Id
    WHERE H.IsVIP = 1 AND S.Price < 400
RETURN
END
GO

SELECT *
FROM dbo.InexpensiveInVIPHalls()


--Рекурсивная функция или функция с рекурсивным ОТВ
--Получить все фильмы серии
USE CinemaDB
GO
    DROP FUNCTION IF EXISTS dbo.GetAllPartsOfFilm
GO

CREATE FUNCTION dbo.GetAllPartsOfFilm()
RETURNS @AllPartsOfFilm TABLE 
(
	Id	INT,  
	[Name] NVARCHAR(50) NOT NULL,
	[Genre] NVARCHAR(15) NOT NULL,
	Duration INT NOT NULL CHECK (Duration >= 30),
	Rating INT,
	PrequelId INT,
	Level INT
)
AS
BEGIN
	WITH FilmReports(Id, [Name], Genre, Duration, Rating, PrequelId, Level)
	AS
	(
		SELECT f.Id, f.[Name], f.Genre, f.Duration, f.Rating, f.PrequelId, 0 AS Level
		FROM Films AS f
		WHERE PrequelId IS NULL
		UNION ALL
		SELECT f.Id, f.[Name], f.Genre, f.Duration, f.Rating, f.PrequelId, Level + 1
		FROM Films AS f INNER JOIN FilmReports AS d ON d.Id = f.PrequelId
	)
	INSERT INTO @AllPartsOfFilm (Id, [Name], [Genre], Duration, Rating, PrequelId, Level)
	SELECT Id, [Name], Genre, Duration, Rating, PrequelId, Level
		FROM FilmReports;
	RETURN
END
GO

SELECT *
FROM dbo.GetAllPartsOfFilm()

SELECT *
FROM dbo.Films


--B. Четыре хранимых процедуры

-- Хранимая процедура без параметров или с параметрами
USE CinemaDB
GO

IF OBJECT_ID ( N'dbo.SelectSessionsVenom', 'P' ) IS NOT NULL
      DROP PROCEDURE dbo.SelectSessionsVenom
GO
CREATE PROCEDURE dbo.SelectSessionsVenom AS
BEGIN
      SELECT AVG(Price) AS "Средняя цена", COUNT(*) AS "Количество сеансов 'Venom'"
      FROM Films F JOIN [Sessions] S ON S.FilmId = F.Id
	  WHERE F.[Name] = 'Venom'
END
GO

EXEC dbo.SelectSessionsVenom
GO


--Рекурсивная хранимая процедура или хранимую процедур с рекурсивным ОТВ
USE CinemaDB
GO
      DROP PROCEDURE IF EXISTS dbo.SelectFilmWithoutPreque
GO

CREATE PROCEDURE dbo.SelectFilmWithoutPreque
	@filmId INT
AS
	WITH FilmReports(Id, [Name], PrequelId)
	AS
	(
		SELECT Id, [Name], PrequelId
		FROM Films AS f
		WHERE Id = @filmId 
		UNION ALL
		SELECT f.Id, f.[Name], f.PrequelId
		FROM Films AS f INNER JOIN FilmReports AS Fr ON f.Id = Fr.PrequelId
	)
	SELECT *
	FROM FilmReports
	WHERE Id <> @filmId;
GO

EXEC dbo.SelectFilmWithoutPreque @filmId = 15
GO

SELECT *
    FROM Films


--Хранимая процедура с курсором
--Print all of films
USE CinemaDB
GO

-- Объявляем переменную
DECLARE @TableName nvarchar(255)
-- Объявляем курсор
	DECLARE TableCursor CURSOR FOR
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_TYPE = 'BASE TABLE'
-- Открываем курсор и выполняем извлечение первои? записи 
		OPEN TableCursor
			FETCH NEXT FROM TableCursor INTO @TableName
-- Проходим в цикле все записи из множества
			WHILE @@FETCH_STATUS = 0
			BEGIN
			PRINT @TableName
			FETCH NEXT FROM TableCursor INTO @TableName END
-- Убираем за собои? «хвосты»
		CLOSE TableCursor
	DEALLOCATE TableCursor


-- Хранимую процедуру доступа к метаданным
IF OBJECT_ID ( N'dbo.ScalarFunc', 'P' ) IS NOT NULL
      DROP PROCEDURE dbo.ScalarFunc
GO
CREATE PROCEDURE ScalarFunc 
AS
BEGIN
    SELECT TABLE_NAME
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG='CinemaDB'
END;
GO

EXECUTE ScalarFunc;
GO


--C. Два DML триггера

--Триггер AFTER
--При добавлении сеанса создать билеты
DROP TRIGGER IF EXISTS dbo.Session_INSERT

USE CinemaDB
GO
CREATE TRIGGER Session_INSERT
ON [Sessions]
AFTER INSERT
AS
BEGIN
	DECLARE @RowCount int;
    SET @RowCount = 10
    WHILE @RowCount > 0
		BEGIN
			DECLARE @SeatCount int;
			SET @SeatCount = 20
			WHILE @SeatCount > 0
				BEGIN
					INSERT INTO Tickets (SessionId, [Row], Seat)
					SELECT Id, @RowCount, @SeatCount
					FROM INSERTED
					SET @SeatCount = @SeatCount - 1;
				END;
			SET @RowCount = @RowCount - 1;
		END;
END;
GO

INSERT INTO [Sessions](FilmId, HallId, [DateTime], Price)
VALUES(3,1,'2018-12-12 12:35:29.123',150)

SELECT *
FROM [Sessions]

SELECT *
FROM Tickets
ORDER BY Id DESC



--Триггер INSTEAD OF
--Запрет на добавление залов
DROP TRIGGER IF EXISTS DenyInsert
GO
CREATE TRIGGER DenyInsert 
ON Halls
INSTEAD OF INSERT
AS
BEGIN
    RAISERROR('Adding a new hall is not allowed.',10,1);
END;
GO

INSERT INTO Halls(NumbSeats, IsVIP)
VALUES(30, 1)

SELECT *
FROM Halls