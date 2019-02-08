CREATE TABLE [dbo].[textTable] (
    [id]   INT            IDENTITY (1, 1) NOT NULL,
    [name] NVARCHAR (100) NOT NULL,
    [num]  INT            NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

