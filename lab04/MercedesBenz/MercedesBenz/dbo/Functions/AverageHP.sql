﻿CREATE FUNCTION dbo.AverageHP()
RETURNS int
WITH SCHEMABINDING
AS
BEGIN
       RETURN (SELECT AVG(HorsePower) FROM dbo.Car)
END