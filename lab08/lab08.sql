SELECT * FROM Dealer

DROP PROCEDURE GetTablesList;
CREATE PROCEDURE GetTablesList AS
BEGIN
	SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = 'BASE TABLE'
END;

DROP PROCEDURE GetHPByID;
CREATE PROCEDURE GetHPByID(@id INT, @hp INT OUTPUT) AS
BEGIN
	SET @hp = (SELECT HorsePower FROM Car
			   WHERE Id = @id)
END;