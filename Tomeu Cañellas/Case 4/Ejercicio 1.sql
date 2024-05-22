--CASO 4: Ejercicio 1
--Creamos el Stored Procedure
CREATE PROCEDURE dbo.CountDuplicates
    --Declaramos la variable que introducimos (nombre de la tabla)
    @TableName NVARCHAR(MAX)
AS
BEGIN
    --Declaramos las variables internas
    DECLARE @ColumnList NVARCHAR(MAX)
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @duplicates INT; 
    DECLARE @message VARCHAR(MAX);

    -- Obtenemos la lista de columnas de la tabla
    SELECT @ColumnList = STRING_AGG(QUOTENAME(name), ', ')
    FROM sys.columns
    WHERE object_id = OBJECT_ID(@TableName)

    -- Si no se encuentra ninguna columna, devolvemos un mensaje de error
    IF @ColumnList IS NULL
    BEGIN
        PRINT 'La tabla especificada no existe o no tiene columnas.'
        RETURN
    END

    -- Construimos la consulta dinámica para contar duplicados
    SET @SQL = 
    '
    SELECT 
        @duplicates = COUNT(*)
    FROM 
        (
            SELECT ' + @ColumnList + '
            FROM ' + @TableName + '
            GROUP BY ' + @ColumnList + '
            HAVING COUNT(*) > 1
        ) AS subquery;
    '

    -- Ejecutamos la consulta dinámica indicando el output
    EXEC sp_executesql @SQL, N'@duplicates INT OUTPUT', @duplicates OUTPUT

    --Declaramos el mensaje de salida
    SET @message = 'Existen un total de ' + CAST(@duplicates AS VARCHAR(10)) + ' duplicados en la tabla ' + CAST(@TableName AS VARCHAR(MAX));

    -- Imprimimos el mensaje
    PRINT @message;
END;

--Tests:

EXEC dbo.CountDuplicates '[SQL_EN_LLAMAS_ALUMNOS].[case04].[sales]';
EXEC dbo.CountDuplicates '[SQL_EN_LLAMAS_ALUMNOS].[case04].[salesssssssss]';

--Drop:

DROP PROCEDURE dbo.CountDuplicates;
