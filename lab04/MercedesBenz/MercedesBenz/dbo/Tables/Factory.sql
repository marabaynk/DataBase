CREATE TABLE [dbo].[Factory] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [City]      NVARCHAR (20) NOT NULL,
    [CarAmount] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CHECK ([CarAmount]>=(100))
);


GO
CREATE TRIGGER DenyInsert 
ON Factory
INSTEAD OF INSERT
AS
BEGIN
    RAISERROR('You cant add a new factory.' ,10, 1);
END;
