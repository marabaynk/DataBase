USE MercedesBenz
go

--1 Инструкция SELECT, использующая предикат сравнения.
SELECT Id, CarAmount, DealerName
FROM Dealer
WHERE City = 'Moscow'


--2 Инструкция SELECT, использующая предикат BETWEEN.
SELECT DISTINCT CarAmount, City
FROM Factory
WHERE CarAmount BETWEEN '30' AND '50'

--3 Инструкция SELECT, использующая предикат LIKE.
SELECT DISTINCT DateOfIssue
FROM Car JOIN MercedesBenz ON Car.Id = MercedesBenz.Id WHERE CarModel LIKE '%E-Classe%'

--4 Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
SELECT Id, CarModel, DateOfIssue, HorsePower 
FROM Car
WHERE Id IN
(
	SELECT Id 
	FROM Car
	WHERE CarModel = 'E-Classe'
) AND IsTransmission = 1

--5 Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
SELECT Id, CarModel, HorsePower
FROM Car
WHERE EXISTS
(
	SELECT CarModel
	FROM Car JOIN MercedesBenz
		ON Car.Id = MercedesBenz.CarId
	WHERE Car.HorsePower > 500 
)

--6 Инструкция SELECT, использующая предикат сравнения с квантором
SELECT CarModel, Id, HorsePower
FROM Car
WHERE HorsePower > ALL
    (
        SELECT HorsePower
        FROM Car
        WHERE HorsePower = 557
    )

--7 Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
SELECT AVG(TotalAmount) AS 'ACT AVERAGE', SUM(TotalAmount)/COUNT(Id) AS 'Calc AVG'
FROM 
    (
        SELECT Id, SUM(CarAmount) AS TotalAmount
        FROM Factory
        GROUP BY Id
    ) AS TotalFactory

--8 Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
SELECT CarModel, 
    (
        SELECT MAX(CarAmount)
        FROM Dealer
		WHERE City = 'Moscow'
    ) AS MyCarAmount
FROM Car

--9 Инструкция SELECT, использующая простое выражение CASE.
SELECT CarModel, DateOfIssue, 
	CASE YEAR(DateOfIssue)
		WHEN YEAR(Getdate()) THEN 'This Year'
		WHEN YEAR(GetDate()) - 1 THEN 'Last year'
		ELSE CAST(DATEDIFF(year, DateOfIssue, Getdate()) AS varchar(5)) + ' years ago'
	END AS 'When'
FROM Car

--10 Инструкция SELECT, использующая поисковое выражение CASE.
SELECT HorsePower,
    CASE
        WHEN HorsePower <= 200 THEN 'Comfort'
        WHEN HorsePower <= 400 THEN 'Sport'
        WHEN HorsePower <= 600 THEN 'Sport+'
        ELSE 'Hybrid'
    END AS TypeOfCare
FROM Car

--11 Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT.
SELECT Id,
    SUM(HorsePower) AS HP,
    CAST(SUM(HorsePower * 100)AS money) AS CarPrise
INTO #BestSelling
FROM Car
WHERE Id IS NOT NULL
GROUP BY Id
SELECT * FROM #BestSelling

--12 Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM.
SELECT 'Quality' AS Criteria, DealerName as 'Best Selling'
FROM Dealer P JOIN
    (
        SELECT TOP 1 Id
        FROM Car
        GROUP BY Id
    ) AS OD ON OD.Id = P.Id

--13 Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3.
SELECT SUM(HorsePower) AS HP, CarModel
FROM Car
GROUP BY CarModel
HAVING SUM(HorsePower) = 
    (
        SELECT MAX(HP2)
        FROM
        (
            SELECT SUM(HorsePower) as HP2, CarModel
            FROM Car
            GROUP BY CarModel
        ) AS OD
    )

--14 Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING.
SELECT CarModel,
    HorsePower,
    AVG(HorsePower) AS AvgHP
FROM Car
WHERE IsTransmission = 1
GROUP BY HorsePower, CarModel

--15 Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING.
SELECT CarModel, AVG(HorsePower) AS 'Average HP'
FROM Car 
GROUP BY CarModel
HAVING AVG(HorsePower) >
    (
        SELECT AVG(HorsePower) AS HP
        FROM Car  
    )
SELECT Avg(HorsePower)
From Car

--16 Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений.
INSERT Dealer(City, DealerName, CarAmount)
VALUES ('Moscow', 'AVILON', '5555')
SELECT * FROM Dealer 

--17 Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса.
INSERT [Factory] (Id, City, CarAmount)
SELECT Id + 100 , City, CarAmount
FROM Factory
WHERE City = 'Moscow'

INSERT [Factory] (Id, City, CarAmount)
   SELECT (
				SELECT MAX(Id)
				FROM Factory
				WHERE City = 'Moscow'
		  ), 'Yerevan', 3456 FROM Factory
WHERE City = 'Moscow'

--18 Простая инструкция UPDATE.
UPDATE Dealer
SET CarAmount = 3333
WHERE City = 'Moscow'

--19 Инструкция UPDATE со скалярным подзапросом в предложении SET.
UPDATE Factory
SET CarAmount =
	(
		SELECT AVG(CarAmount)
		FROM [Factory]
		--WHERE Id = 3 
	)
WHERE Id = 3
SELECT * FROM Factory

--20 Простая инструкция DELETE.
DELETE [Dealer]
WHERE City = NULL

--21 Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE.
DELETE FROM MercedesBenz
WHERE Id IN
    (
        SELECT Id
        FROM Car
        WHERE Id = 5
    )

--22 Инструкция SELECT, использующая простое обобщенное табличное выражение
WITH MercedesBenz (Id, CarId) 
AS
(
	SELECT CarModel, COUNT(*) AS Total FROM Car
	WHERE CarModel IS NOT NULL GROUP BY CarModel
)
SELECT AVG(CarId) AS 'Среднее количество Id' 
FROM MercedesBenz

--23 Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.


--24 Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
SELECT
	AVG(HorsePower) OVER(PARTITION BY Id, CarModel) AS AvgCar,
	MIN(HorsePower) OVER(PARTITION BY Id, CarModel) AS MinCar,
	MAX(HorsePower) OVER(PARTITION BY Id, CarModel) AS MaxCar
FROM Car

--25
SELECT CarModel, row_number() OVER (PARTITION BY CarModel ORDER BY HorsePower) AS rn
FROM Car;
 