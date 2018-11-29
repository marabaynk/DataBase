BULK INSERT MercedesBenz.dbo.Car
FROM 'C:\Users\Koi\Documents\Visual Studio 2015\lab01\lab01\Car.csv'
WITH (DATAFILETYPE = 'char', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
GO 

BULK INSERT MercedesBenz.dbo.Dealer
FROM 'C:\Users\Koi\Documents\Visual Studio 2015\lab01\lab01\Dealer.csv'
WITH (DATAFILETYPE = 'char', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
GO 

BULK INSERT MercedesBenz.dbo.Factory
FROM 'C:\Users\Koi\Documents\Visual Studio 2015\lab01\lab01\Factory.csv'
WITH (DATAFILETYPE = 'char', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
GO 

BULK INSERT MercedesBenz.dbo.[MercedesBenz]
FROM 'C:\Users\Koi\Documents\Visual Studio 2015\lab01\lab01\MercedesBenz.csv'
WITH (DATAFILETYPE = 'char', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
GO 
