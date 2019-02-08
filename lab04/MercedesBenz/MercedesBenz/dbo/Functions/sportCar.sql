
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
