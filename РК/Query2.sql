SELECT TOP 1000 * FROM dbo.Tickets
SELECT * FROM dbo.[Sessions] ORDER BY ID
SELECT * FROM dbo.Films
SELECT * FROM dbo.Halls

SELECT Id FROM dbo.Halls WHERE IsVIP = 1

INSERT INTO dbo.Films VALUES (
'fsuhe',
'jsdfh',
10);

SELECT * FROM sys.check_constraints

SELECT * FROM sys.all_objects


/*1*/
SELECT DISTINCT Id,[Name]
FROM Films
WHERE Duration >
       (
		SELECT MIN(Duration)
		FROM Films
		)


/*2*/
SELECT DISTINCT HallId, FilmId
FROM [Sessions]
WHERE [DateTime] BETWEEN '2018-10-01' AND '2018-10-03' 


/*3*/
SELECT DISTINCT [Name]
FROM Films
WHERE Genre LIKE '%Fantasy%'


/*4*/
SELECT Id, HallId, FilmId, Price
FROM [Sessions]
WHERE HallId IN
	( 
		SELECT Id
		FROM Halls
		WHERE IsVIP = 1
	)


/*5 почему выводятся все записи*/
--SELECT SessionId, Id, [Row]
SELECT COUNT(*)
FROM Tickets 
WHERE EXISTS 
	(
		SELECT iD
        FROM Tickets 
        WHERE [Row] = 10
	)


/*6*/
SELECT Id, Price, HallId
FROM [Sessions]
WHERE HallId = 1 AND Price > SOME
	(
		SELECT Price
		FROM [Sessions]
		WHERE HallId = 1
	)


/*7*/
SELECT FilmId, SUM(Price) AS Money 
FROM [Sessions] 
GROUP BY FilmId


/*8*/
SELECT	Id,
	(
		SELECT AVG(Price)
		FROM [Sessions]
		WHERE [Sessions].FilmId = Films.Id
	) AS AvgPrice,
	(
		SELECT MIN(Price)
		FROM [Sessions]
		WHERE [Sessions].FilmId = Films.Id
) AS MaxPrice,
[Name]
FROM Films


/*9*/
SELECT FilmId, SessionId,
	CASE DAY([DateTime])
		WHEN DAY(Getdate()) THEN 'This day'
		WHEN DAY(GetDate()) - 1 THEN 'Last day'
		ELSE CAST(DATEDIFF(DAY, [DateTime], Getdate()) AS varchar(5)) + '  days ago'
	END AS 'When'
FROM Tickets JOIN [Sessions] ON Tickets.SessionId = [Sessions].Id


/*10*/
SELECT Id AS [Session],
	CASE
		WHEN Price < 200 THEN 'Inexpensive'
		WHEN Price < 500 THEN 'Fair'
		WHEN Price < 700 THEN 'Expensive'
		ELSE 'Very Expensive'
	END AS Price
FROM [Sessions]


/*11*/
SELECT AVG(s.Price * h.NumbSeats) AS Profit, s.[DateTime] AS [Time], h.IsVIP AS IsHallVIP
INTO #AverageProfitByTimeAndHallType
FROM [Sessions] s JOIN Halls h
	ON s.HallId = h.Id
GROUP BY s.[DateTime], h.IsVIP 

SELECT * FROM #AverageProfitByTimeAndHallType


/*12 Найти и объединить сеансы: 1)Самый дорогой билет, 2)Самая большая суммарная прибль */
SELECT 'By the cost' AS Criteria, s.Id as 'Session Id', s.Price AS 'Criteria value'
FROM [Sessions] s JOIN
	(
		SELECT TOP 1 Id
		FROM [Sessions]
		ORDER BY Price DESC
	) AS s2 ON s.Id = s2.Id
UNION
SELECT 'By revenue' AS Criteria, s.Id as 'Session Id', s2.Revenue AS 'Criteria value'
FROM [Sessions] s JOIN
	(
		SELECT TOP 1 s.Id, s.Price * h.NumbSeats AS 'Revenue'
		FROM [Sessions] s JOIN Halls h
			ON s.HallId = h.Id
		ORDER BY s.Price * h.NumbSeats DESC
	) AS s2 ON  s.Id = s2.Id


ALTER TABLE Films ADD Rating INT NULL; 
/*13 Найти самый прибыльный сеанс с фильмом с самым низким рейтингом в не vip зале, самый неприбыльный сеанс с фильмом с самым высоким рейтингом в vip зале*/
SELECT 'The most profitable session with the film with the lowest rating in the non-VIP room' AS Criteria, s.*
FROM [Sessions] s JOIN
	(
		SELECT TOP 1 s.Id
		FROM [Sessions] s JOIN Films f
			ON s.FilmId = f.Id
			JOIN Halls h 
			ON s.HallId = h.Id
		WHERE s.Id IN
			(
				SELECT Id
				FROM [Sessions]
				WHERE HallId IN
					(
						SELECT Id
						FROM Halls
						WHERE IsVIP = 0
					)
			)
		 ORDER BY f.Rating ASC, s.Price * h.NumbSeats DESC
	) AS s1 ON  s.Id = s1.Id
UNION
SELECT 'The most unprofitable session with the film with the highest rating in the VIP room' AS Criteria, s.*
FROM [Sessions] s JOIN
	(
		SELECT TOP 1 s.Id
		FROM [Sessions] s JOIN Films f
			ON s.FilmId = f.Id
			JOIN Halls h 
			ON s.HallId = h.Id
		WHERE s.Id IN
			(
				SELECT Id
				FROM [Sessions]
				WHERE HallId IN
					(
						SELECT Id
						FROM Halls
						WHERE IsVIP = 1
					)
			)
		 ORDER BY f.Rating DESC, s.Price * h.NumbSeats ASC
	) AS s1 ON  s.Id = s1.Id


/*14*/
SELECT f.Id,
	AVG(Price) AS AvgPrice,
	MIN(Price) AS MinPrice,
	f.[Name]
FROM Films f LEFT OUTER JOIN [Sessions] ON f.Id = [Sessions].FilmId
GROUP BY f.Id, f.[Name]


/*15*/
SELECT HallId, AVG(Price) AS 'Average Price'
FROM [Sessions]
GROUP BY HallId
HAVING AVG(Price) >
	(
		SELECT AVG(Price) AS MPrice
		FROM [Sessions]
	)


/*16*/
INSERT INTO Films ([Name], Genre, Duration, Rating, PrequelId)
VALUES ('Patrick', 'Comedy', 94, 4)



/*17 Добавить в табл фильмы фильм с именем: (История создания Имя фильма, у которого больше всех сеансов)*/
INSERT Films ([Name], Genre, Duration, Rating, PrequelId)
SELECT (
			SELECT TOP 1 'History of creation "' + f.[Name] + '"'
			FROM [Sessions] s JOIN Films f ON  f.Id = s.FilmId
			GROUP BY f.Id, f.[Name]
			ORDER BY COUNT(*) DESC
		), 'Historical', 100, 9


SELECT * from Films


/*18*/
UPDATE [Sessions]
SET Price = Price * 0.5
WHERE Id = 4

SELECT * from [Sessions]


/*19*/
UPDATE [Sessions]
SET Price =
	(
		SELECT AVG(Price)
		FROM [Sessions]
		WHERE HallId = 5
	)
WHERE Id = 1


/*20*/
INSERT INTO Films ([Name], Genre, Duration, Rating, PrequelId)
VALUES ('Need to be deleted', 'Comedy', 94, 3)

SELECT * FROM Films

DELETE Films
WHERE [Name] = 'Need to be deleted'


/*21*/
DELETE FROM Films
WHERE Id IN
	(
		SELECT f.Id
		FROM Films f LEFT OUTER JOIN [Sessions] s
		ON f.Id = s.FilmId
		WHERE s.Id = 5
	)


/*22 когда удаляется таблица*/
WITH FilmsCTE([Name], Genre, Duration, Rating, PrequelId)
	AS
	(
		SELECT [Name], Genre, Duration, Rating, PrequelId FROM Films
	)
SELECT * FROM FilmsCTE


/*23 Создать предшествующий id фильма() (столбец)*/
ALTER TABLE Films ADD PrequelId INT NULL;
ALTER TABLE Films DROP COLUMN Prequel;  

INSERT INTO Films ([Name], Genre, Duration, Rating, PrequelId)
VALUES ('The House with a Clock in its Walls 2','Fantasy',111,6,1)
INSERT INTO Films ([Name], Genre, Duration, Rating, PrequelId)
VALUES ('Venom 2','Fantasy',102,4,3)
INSERT INTO Films ([Name], Genre, Duration, Rating, PrequelId)
VALUES ('Ruby and the Lord of the Water 2','Animation',90,7,5)
INSERT INTO Films ([Name], Genre, Duration, Rating, PrequelId)
VALUES ('Ruby and the Lord of the Water 3','Animation',83,6,10)

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
SELECT Id, [Name], Genre, Duration, Rating, PrequelId, Level
FROM FilmReports;



/*24*/
SELECT s.FilmId,
	s.Price,
	f.[Name],
	AVG(s.Price) OVER(PARTITION BY s.FilmId, f.[Name]) AS AvgPrice,
	MIN(s.Price) OVER(PARTITION BY s.FilmId, f.[Name]) AS MinPrice,
	MAX(s.Price) OVER(PARTITION BY s.FilmId, f.[Name]) AS MaxPrice
FROM [Sessions] s LEFT OUTER JOIN Films f ON f.Id = s.FilmId


/*25 устранить повторы*/
SELECT [Name],
  ROW_NUMBER() OVER(PARTITION BY [Name]
                    ORDER BY (SELECT NULL)) AS n
FROM Films;