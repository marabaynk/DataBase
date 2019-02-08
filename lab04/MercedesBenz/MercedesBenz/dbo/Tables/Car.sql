CREATE TABLE [dbo].[Car] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [CarModel]       NVARCHAR (50) NOT NULL,
    [DateOfIssue]    DATE          NOT NULL,
    [HorsePower]     INT           NOT NULL,
    [IsTransmission] BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CHECK ([HorsePower]>=(130))
);


GO
CREATE TRIGGER Car_INSERT
ON Car
AFTER INSERT
AS
BEGIN
	DECLARE @CarCount int;
    SET @CarCount = 30
    WHILE @CarCount > 0
		BEGIN
			INSERT INTO [MercedesBenz] (CarId, DealerId, FactoryId, DeliveryDate)
			SELECT ABS(CHECKSUM(NewId()) %100), ABS(CHECKSUM(NewId()) %100)+1, ABS(CHECKSUM(NewId()) %100)+2, '2222-11-11'
			FROM INSERTED
			SET @CarCount = @CarCount - 1;
		END;
END;
