-- RETO 1. LAS TABLAS NO ESTÁN MUY LIMPIAS, CREA UN PROCEDIMIENTO ALMACENADO QUE
-- INFORMANDO EL NOMBRE DE LA TABLA, NOS DEVUELVA EL NÚMERO DE POSIBLES DUPLICADOS.
USE SQL_EN_LLAMAS_ALUMNOS;
GO

-- Creación de una función UDF genérica que obtiene el nombre de las columnas de una tabla a partir de vistas de catálogo (metadata)			
CREATE OR ALTER FUNCTION case04.PNG_getColumns (
	@database_name NVARCHAR(MAX)
	,@schema_name NVARCHAR(MAX)
	,@table_name NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @string_agg_col_names NVARCHAR(MAX);

	WITH
		METADATA_SCHEMA AS (
			SELECT *
			FROM sys.schemas
			WHERE LOWER(name) LIKE LOWER(@schema_name)
		)

		,METADATA_OBJECT AS (
			SELECT obj.object_id
			FROM METADATA_SCHEMA AS sch
			LEFT JOIN sys.objects AS obj
				ON sch.schema_id = obj.schema_id
			WHERE LOWER(obj.name) LIKE LOWER(@table_name)
		)

		,METADATA_COLUMNS AS (
			SELECT name
			FROM sys.columns
			WHERE object_id = (SELECT object_id FROM METADATA_OBJECT)
		)

		SELECT @string_agg_col_names = STRING_AGG(name, ', ') FROM METADATA_COLUMNS;
	RETURN @string_agg_col_names
END;
GO

-- Creación del procedimiento almacenado que contabiliza los duplicados
CREATE OR ALTER PROCEDURE case04.PNG_countDeduplicates
	@database_name NVARCHAR(MAX)
	,@schema_name NVARCHAR(MAX)
	,@table_name NVARCHAR(MAX)
AS
BEGIN
	-- Control y validación del parámetro @database_name
	DECLARE @database_log NVARCHAR(MAX);
	SELECT @database_log = name FROM sys.databases WHERE LOWER(name) LIKE LOWER(@database_name);

	IF @database_log IS NULL
		PRINT 'LA BASE DE DATOS ' + QUOTENAME(UPPER(@database_name)) + ' NO EXISTE'

	ELSE
		-- Control y validación del parámetro @schema_name
		DECLARE @schema_log NVARCHAR(MAX);
		SELECT @schema_log = name FROM sys.schemas WHERE LOWER(name) LIKE LOWER(@schema_name);

		IF @schema_log IS NULL
			PRINT 'EL ESQUEMA ' + QUOTENAME(UPPER(@schema_name)) + ' NO EXISTE'

		ELSE
			-- Obtención del nombre de las columnas de la tabla de entrada a partir de la función definida anteriormente
			DECLARE @string_agg_col_names NVARCHAR(MAX);

			SELECT @string_agg_col_names = case04.PNG_getColumns (@database_name, @schema_name, @table_name);

			-- Control y validación del parámetro @table_name
			IF @string_agg_col_names IS NULL
				PRINT 'LA TABLA ' + QUOTENAME(UPPER(@table_name)) + ' NO EXISTE EN EL ESQUEMA ' +
						QUOTENAME(UPPER(@schema_name))

			ELSE IF @database_log IS NOT NULL AND @schema_log IS NOT NULL AND @string_agg_col_names IS NOT NULL
			BEGIN
				-- Construcción de una query base para ejecutar dos consultas diferentes
				DECLARE @base_query NVARCHAR(MAX);
				SET @base_query = N'
					WITH
						DUPLICATE_RECORDS AS (
							SELECT ' + @string_agg_col_names + ', COUNT(*)-1 AS number_of_duplicate_records
							FROM ' + QUOTENAME(@database_name) + '.' + QUOTENAME(@schema_name) + '.' + QUOTENAME(@table_name) +
							' GROUP BY ' + @string_agg_col_names +
							' HAVING COUNT(*) > 1)
					';
				-- Query 1. Muestra en una tabla los registros duplicados más una columna que contabiliza el número de duplicados en la ventana RESULTS
				DECLARE @show_duplicate_records NVARCHAR(MAX);
				SET @show_duplicate_records =  @base_query + ' SELECT * FROM DUPLICATE_RECORDS;'
				EXEC sp_executesql @show_duplicate_records;
    
				-- Query 2. Guarda el número de duplicados totales de la tabla seleccionada en la variable @count para luego imprimir su valor en la ventana MESSAGES
				DECLARE @count_duplicate_records NVARCHAR(MAX), @count INT;
				SET @count_duplicate_records =  @base_query + ' SELECT @count = SUM(number_of_duplicate_records) FROM DUPLICATE_RECORDS;'
				EXEC sp_executesql @count_duplicate_records, N'@count INT OUTPUT', @count OUTPUT;

				-- Creación de un mensaje de salida en la ventana MESSAGES que informa del número de duplicados totales de la tabla seleccionada
				PRINT 'SE HAN DETECTADO ' + CAST(ISNULL(@count, 0) AS VARCHAR(20)) + ' REGISTROS DUPLICADOS EN LA TABLA ' +
						QUOTENAME(UPPER(@table_name)) + ' DEL ESQUEMA ' + QUOTENAME(UPPER(@schema_name)) +
						' EN LA BASE DE DATOS ' + QUOTENAME(UPPER(@database_name))
				END;
END;
GO

-- Caso de uso - Modifica el valor de estas variables para comprobar distintas combinaciones
DECLARE @check_database_name NVARCHAR(MAX), @check_schema_name NVARCHAR(MAX), @check_table_name NVARCHAR(MAX);
SET @check_database_name = 'SQL_EN_LLAMAS_ALUMNOS'
SET @check_schema_name = 'case04'
SET @check_table_name = 'sales'

-- Ejecución del procedimiento almacenado
EXECUTE case04.PNG_countDeduplicates
	@database_name = @check_database_name
	,@schema_name = @check_schema_name
	,@table_name = @check_table_name;
GO

-- Eliminación el procedimiento almacenado
DROP PROCEDURE case04.PNG_countDeduplicates;


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Todo perfecto! Poco te puedo decir muy original la forma de mostrar los resultados en las diferentes ventanas. 
Estoy aprendiendo muchas cosas de sql server que nunca se me habrían ocurrido! jajaja.

RESULTADO: Correcto
CÓDIGO: Correcto.
LEGIBILIDAD: Correcto.

*/
