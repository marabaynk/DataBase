USE MercedesBenz
go

--1 ���������� SELECT, ������������ �������� ���������.
SELECT Id, CarAmount, DealerName
FROM Dealer
WHERE City = 'Moscow'


--2 ���������� SELECT, ������������ �������� BETWEEN.
SELECT DISTINCT CarAmount, City
FROM Factory
WHERE CarAmount BETWEEN '30' AND '50'

--3 ���������� SELECT, ������������ �������� LIKE.
SELECT DISTINCT DateOfIssue
FROM Car JOIN MercedesBenz ON Car.Id = MercedesBenz.Id WHERE CarModel LIKE '%E-Classe%'

--4 ���������� SELECT, ������������ �������� IN � ��������� �����������.
SELECT Id, CarModel, DateOfIssue, HorsePower 
FROM Car
WHERE Id IN
(
	SELECT Id 
	FROM Car
	WHERE CarModel = 'E-Classe'
) AND IsTransmission = 1

--5 ���������� SELECT, ������������ �������� EXISTS � ��������� �����������.
SELECT Id, CarModel, HorsePower
FROM Car
WHERE EXISTS
(
	SELECT CarModel
	FROM Car JOIN MercedesBenz
		ON Car.Id = MercedesBenz.CarId
	WHERE Car.HorsePower > 500 
)

--6 ���������� SELECT, ������������ �������� ��������� � ���������
SELECT CarModel, Id, HorsePower
FROM Car
WHERE HorsePower > ALL
    (
        SELECT HorsePower
        FROM Car
        WHERE HorsePower = 557
    )

--7 ���������� SELECT, ������������ ���������� ������� � ���������� ��������.
SELECT AVG(TotalAmount) AS 'ACT AVERAGE', SUM(TotalAmount)/COUNT(Id) AS 'Calc AVG'
FROM 
    (
        SELECT Id, SUM(CarAmount) AS TotalAmount
        FROM Factory
        GROUP BY Id
    ) AS TotalFactory

--8 ���������� SELECT, ������������ ��������� ���������� � ���������� ��������.
SELECT CarModel, 
    (
        SELECT MAX(CarAmount)
        FROM Dealer
		WHERE City = 'Moscow'
    ) AS MyCarAmount
FROM Car

--9 ���������� SELECT, ������������ ������� ��������� CASE.
SELECT CarModel, DateOfIssue, 
	CASE YEAR(DateOfIssue)
		WHEN YEAR(Getdate()) THEN 'This Year'
		WHEN YEAR(GetDate()) - 1 THEN 'Last year'
		ELSE CAST(DATEDIFF(year, DateOfIssue, Getdate()) AS varchar(5)) + ' years ago'
	END AS 'When'
FROM Car

--10 ���������� SELECT, ������������ ��������� ��������� CASE.
SELECT HorsePower,
    CASE
        WHEN HorsePower <= 200 THEN 'Comfort'
        WHEN HorsePower <= 400 THEN 'Sport'
        WHEN HorsePower <= 600 THEN 'Sport+'
        ELSE 'Hybrid'
    END AS TypeOfCare
FROM Car

--11 �������� ����� ��������� ��������� ������� �� ��������������� ������ ������ ���������� SELECT.
SELECT Id,
    SUM(HorsePower) AS HP,
    CAST(SUM(HorsePower * 100)AS money) AS CarPrise
INTO #BestSelling
FROM Car
WHERE Id IS NOT NULL
GROUP BY Id
SELECT * FROM #BestSelling

--12 ���������� SELECT, ������������ ��������� ��������������� ���������� � �������� ����������� ������ � ����������� FROM.
SELECT 'Quality' AS Criteria, DealerName as 'Best Selling'
FROM Dealer P JOIN
    (
        SELECT TOP 1 Id
        FROM Car
        GROUP BY Id
    ) AS OD ON OD.Id = P.Id

--13 ���������� SELECT, ������������ ��������� ���������� � ������� ����������� 3.
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

--14 ���������� SELECT, ��������������� ������ � ������� ����������� GROUP BY, �� ��� ����������� HAVING.
SELECT CarModel,
    HorsePower,
    AVG(HorsePower) AS AvgHP
FROM Car
WHERE IsTransmission = 1
GROUP BY HorsePower, CarModel

--15 ���������� SELECT, ��������������� ������ � ������� ����������� GROUP BY � ����������� HAVING.
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

--16 ������������ ���������� INSERT, ����������� ������� � ������� ����� ������ ��������.
INSERT Dealer(City, DealerName, CarAmount)
VALUES ('Moscow', 'AVILON', '5555')
SELECT * FROM Dealer 

--17 ������������� ���������� INSERT, ����������� ������� � ������� ��������������� ������ ������ ���������� ����������.
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

--18 ������� ���������� UPDATE.
UPDATE Dealer
SET CarAmount = 3333
WHERE City = 'Moscow'

--19 ���������� UPDATE �� ��������� ����������� � ����������� SET.
UPDATE Factory
SET CarAmount =
	(
		SELECT AVG(CarAmount)
		FROM [Factory]
		--WHERE Id = 3 
	)
WHERE Id = 3
SELECT * FROM Factory

--20 ������� ���������� DELETE.
DELETE [Dealer]
WHERE City = NULL

--21 ���������� DELETE � ��������� ��������������� ����������� � ����������� WHERE.
DELETE FROM MercedesBenz
WHERE Id IN
    (
        SELECT Id
        FROM Car
        WHERE Id = 5
    )

--22 ���������� SELECT, ������������ ������� ���������� ��������� ���������
WITH MercedesBenz (Id, CarId) 
AS
(
	SELECT CarModel, COUNT(*) AS Total FROM Car
	WHERE CarModel IS NOT NULL GROUP BY CarModel
)
SELECT AVG(CarId) AS '������� ���������� Id' 
FROM MercedesBenz

--23 ���������� SELECT, ������������ ����������� ���������� ��������� ���������.


--24 ������� �������. ������������� ����������� MIN/MAX/AVG OVER()
SELECT
	AVG(HorsePower) OVER(PARTITION BY Id, CarModel) AS AvgCar,
	MIN(HorsePower) OVER(PARTITION BY Id, CarModel) AS MinCar,
	MAX(HorsePower) OVER(PARTITION BY Id, CarModel) AS MaxCar
FROM Car

--25
SELECT CarModel, row_number() OVER (PARTITION BY CarModel ORDER BY HorsePower) AS rn
FROM Car;
 