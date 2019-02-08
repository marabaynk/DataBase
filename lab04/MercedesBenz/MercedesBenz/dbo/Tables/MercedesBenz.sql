CREATE TABLE [dbo].[MercedesBenz] (
    [Id]           INT  IDENTITY (1, 1) NOT NULL,
    [CarId]        INT  NOT NULL,
    [DealerId]     INT  NOT NULL,
    [FactoryId]    INT  NOT NULL,
    [DeliveryDate] DATE NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    FOREIGN KEY ([CarId]) REFERENCES [dbo].[Car] ([Id]),
    FOREIGN KEY ([DealerId]) REFERENCES [dbo].[Dealer] ([Id]),
    FOREIGN KEY ([FactoryId]) REFERENCES [dbo].[Factory] ([Id])
);

