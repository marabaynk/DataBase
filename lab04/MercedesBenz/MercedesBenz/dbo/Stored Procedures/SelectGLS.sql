CREATE PROCEDURE dbo.SelectGLS AS
BEGIN
    SELECT COUNT(CarId) AS countCars FROM dbo.[MercedesBenz] JOIN dbo.Car ON dbo.[MercedesBenz].CarId = dbo.Car.Id
	WHERE Car.CarModel = 'GLS-Classe'
END
