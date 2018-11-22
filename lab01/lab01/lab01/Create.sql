USE master
GO

IF NOT EXISTS (
	SELECT name
		FROM sys.databases
		WHERE name = N'MercedesBenz'
)

BEGIN
	CREATE DATABASE MercedesBenz
END
GO

USE MercedesBenz
GO

IF OBJECT_ID('dbo.MercedesBenz') IS NOT NULL
DROP TABLE dbo.[MercedesBenz]
GO

IF OBJECT_ID('dbo.Factory') IS NOT NULL
DROP TABLE dbo.[Factory]
GO



IF OBJECT_ID('dbo.Car') IS NOT NULL
DROP TABLE dbo.[Car]
GO

IF OBJECT_ID('dbo.Dealer') IS NOT NULL
DROP TABLE dbo.[Dealer]
GO



CREATE TABLE dbo.[Dealer]
(
	Id	INT NOT NULL PRIMARY KEY IDENTITY(1,1),  
    City NVARCHAR(20) NOT NULL,
	DealerName NVARCHAR(10) NOT NULL,
	CarAmount INT NOT NULL CHECK (CarAmount >= 30)
);
GO

CREATE TABLE dbo.[Car]
(
	Id	INT NOT NULL PRIMARY KEY IDENTITY(1,1),  
	CarModel NVARCHAR(50) NOT NULL,
	DateOfIssue DATE NOT NULL,
	HorsePower INT NOT NULL CHECK (HorsePower >= 130),
	IsTransmission BIT NOT NULL
);
GO



CREATE TABLE dbo.[Factory]
(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
	City NVARCHAR(20) NOT NULL,
	CarAmount INT NOT NULL CHECK (CarAmount >= 100)
);
GO

CREATE TABLE dbo.[MercedesBenz]
(
	Id	INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
    CarId  INT NOT NULL REFERENCES dbo.Car (Id),
    DealerId INT NOT NULL REFERENCES dbo.Dealer (Id),
	FactoryId INT NOT NULL REFERENCES dbo.Factory (Id), 
    [DeliveryDate] DATE NOT NULL
);
GO

