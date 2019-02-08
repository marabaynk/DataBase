CREATE PROCEDURE CursSearch AS
BEGIN
-- Объявляем переменную
	DECLARE @TableName nvarchar(255)
	DECLARE @TableCatalog nvarchar(255)
-- Объявляем курсор
	DECLARE TableCursor CURSOR FOR
		SELECT TABLE_NAME, TABLE_CATALOG FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_TYPE = 'BASE TABLE'
-- Открываем курсор и выполняем извлечение первой записи 
		OPEN TableCursor
			FETCH NEXT FROM TableCursor INTO @TableName, @TableCatalog
-- Проходим в цикле все записи из множества
			WHILE @@FETCH_STATUS = 0
			BEGIN
			SELECT @TableName AS NAMETABLE, @TableCatalog AS TABLECATALOG
			FETCH NEXT FROM TableCursor INTO @TableName, @TableCatalog 
			END
		CLOSE TableCursor
	DEALLOCATE TableCursor
END
