CREATE TABLE [dbo].[Dealer] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [City]       NVARCHAR (20) NOT NULL,
    [DealerName] NVARCHAR (10) NOT NULL,
    [CarAmount]  INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CHECK ([CarAmount]>=(30))
);

