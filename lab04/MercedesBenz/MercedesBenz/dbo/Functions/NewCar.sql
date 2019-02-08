CREATE FUNCTION dbo.NewCar()
RETURNS TABLE
AS
RETURN (
    SELECT Factory.[CarAmount] AS TotalCarFactory, Dealer.[CarAmount] AS TotalCArDealer, [MercedesBenz].DeliveryDate
    FROM Factory JOIN [MercedesBenz] ON Factory.Id = [MercedesBenz].FactoryId
	JOIN Dealer ON Dealer.Id = [MercedesBenz].DealerId
    WHERE [MercedesBenz].CarId > 50
    )
