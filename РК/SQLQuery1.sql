USE master
GO

IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'Club'
) 
BEGIN 
	CREATE DATABASE Club
END
GO

USE Club
GO

IF OBJECT_ID('dbo.Boss') IS NOT NULL
DROP TABLE dbo.Boss
GO

IF OBJECT_ID('dbo.Club') IS NOT NULL
DROP TABLE dbo.Club
GO

IF OBJECT_ID('dbo.Customer') IS NOT NULL
DROP TABLE dbo.Customer
GO

CREATE TABLE dbo.Club
(
	Id	INT NOT NULL PRIMARY KEY IDENTITY(1,1),  
	[Name] NVARCHAR(50) NOT NULL REFERENCES dbo.Boss(Id),
	DateOfFoundation DATETIME NOT NULL,
	aboutClub NVARCHAR(50) NOT NULL
);
GO

INSERT INTO  dbo.Club ([Name], DateOfFoundation, aboutClub)
VALUES 
	('boxing' , '07/07/1998', 'good'),
	('mma' , '12/07/1999', 'well'),
	('karate' , '20/10/2005', 'perfect'),
	('akido' , '11/07/2008', 'good'),
	('akido' , '07/07/2009', 'well'),
	('boxing' , '07/07/2015', 'well'),
	('mma' , '27/07/2000', 'brilliant'),
	('mma' , '07/11/2001', 'good'),
	('boxing' , '01/12/1998', 'perfect'),
	('karate' , '10/07/2017', 'good');
	
SELECT * FROM Club


CREATE TABLE dbo.Boss
(
	Id	INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
	[Name] NVARCHAR(50) NOT NULL,
	dateOfBirth DATETIME NOT NULL,
	experience INT NOT NULL,
	phoneNumber VARCHAR(20) NOT NULL
);
GO
INSERT INTO  dbo.Boss([Name], dateOfBirth, experience, phoneNumber)
VALUES 
	('ÀÂÃ' , '07/07/1975', '2', '+7-999-123'),
	('ÐÏÍ' , '07/07/1989', '13', '+7-999-124'),
	('ÀÀÀ' , '07/07/1987', '15', '+7-999-125'),
	('ÄÅÊ' , '07/07/1956', '25', '+7-985-126'),
	('ÃÒÎ' , '07/07/1967', '30', '+7-999-127'),
	('ÌÂË' , '07/07/1990', '5', '+7-999-128'),
	('ÂÂÂ' , '07/07/1997', '6', '+7-999-129'),
	('ÌÌÌ' , '07/07/1978', '25', '+7-985-133'),
	('ÍÍÍ' , '07/07/1979', '25', '+7-999-122'),
	('ÈÈÈ' , '07/07/1967', '31', '+7-985-155');

SELECT * FROM Boss


CREATE TABLE dbo.Customer
(
	Id	INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
    [Name] NVARCHAR(50) NOT NULL,
    DateOfBirth DATETIME NOT NULL, 
    City NVARCHAR(20) NOT NULL,
	email NVARCHAR(20) NOT NULL
);
GO

INSERT INTO dbo.Customer ([Name], DateOfBirth, City, email)
VALUES 
	('Ìàðàáÿí Êîðþí Âàðàçäàòîâè÷', '11/09/1998', 'Moscow', 'koryun9999@mail.ru'),
	('À À À', '11/09/1999', 'Moscow', '11@mail.ru'),
	('Á Á Á', '13/09/1978', 'Tula', '22@mail.ru'),
	('À Á Â', '19/09/1989', 'Moscow', '33@mail.ru'),
	('Ð Â Í', '18/09/1990', 'Moscow', '44@mail.ru'),
	('Í Í Í', '17/09/1999', 'Sochi', '55@mail.ru'),
	('Ì Ì Ì', '16/09/1997', 'Piter', '66@mail.ru'),
	('Ø Ò Ð', '15/09/1996', 'Voronej', '77@mail.ru'),
	('Ì Î Ï', '14/09/1995', 'Sochi', '88@mail.ru'),
	('Ó Â Ð', '13/09/1994', 'Tula', '99@mail.ru');

SELECT * FROM dbo.Customer

ALTER TABLE dbo.Customer ADD CONSTRAINT
FK_CF FOREIGN KEY (Id) REFERENCES dbo.Club (Id)
GO



SELECT  email, DateOfBirth,
		CASE City
			WHEN 'Moscow' THEN 'EEEEEE'
			WHEN 'Tula' THEN 'OOOOO'
		END AS 'bmstu'
FROM dbo.Customer 

SELECT dateOfBirth, experience, phoneNumber,
		AVG(experience) OVER(PARTITION BY [Name] ORDER BY [Name])
FROM dbo.Boss


SELECT [Name],phoneNumber, AVG(experience) AS 'Avarage Experience'
FROM dbo.Boss
GROUP BY [Name]
HAVING AVG(experience) >
(
	SELECT AVG(experience)
	FROM dbo.Boss
)



CREATE PROCEDURE Drop_ufn @count INT OUT
WITH RECOMPILE
AS
BEGIN
SELECT un.definition as Def
FROM sys.objects AS o
JOIN sys.sql_modules AS un ON un.object_id = o.object_id
WHERE o.type = 'FN' ; 
SET @count = @@ROWCOUNT;
END
GO

DECLARE @c int;
EXEC Drop_ufn @c OUT;
PRINT @c; 
GO