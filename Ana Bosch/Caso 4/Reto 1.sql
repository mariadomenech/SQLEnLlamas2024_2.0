-- RETO 1: Las tablas no están muy limpias, crea un procedimiento almacenado que al indicar el nombre de la tabla 
-- (incluyendo el schema y la base de datos), nos devuelva el número de posibles duplicados?

-- Para hacer el procedimiento aplicable a cualquier tabla, se crea una función que extrae los 
-- campos de cualquier tabla y los prepara como texto para agrupar con group by 
CREATE OR ALTER FUNCTION dbo.dynamicValues (
	@final_table NVARCHAR(256)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	
	DECLARE @values NVARCHAR(MAX)
	
	-- Extrameos los campos de la tabla y los preparamos como texto
	SELECT @values = STRING_AGG(name, ', ')
	FROM sys.columns
	WHERE object_id = OBJECT_ID(@final_table)

	RETURN @values
END;

-- Procedimiento para calcular el número de duplicados de cualquier tabla
CREATE OR ALTER PROCEDURE RETO_1
	@bd NVARCHAR(256), 
	@sch NVARCHAR(256), 
	@table NVARCHAR(256)
AS
BEGIN
	DECLARE 
		@msg NVARCHAR(256)
		
	-- Controlamos que la BD exista
	IF EXISTS (
		SELECT name 
		FROM master.sys.databases 
		WHERE name = @bd)

			-- Controlamos que el esquema exista
			IF EXISTS (
				SELECT * 
				FROM sys.schemas 
				WHERE name = @sch) 

					-- Controlamos que la tabla exista en el esquema y BD dada
					IF EXISTS (
						SELECT * 
						FROM INFORMATION_SCHEMA.TABLES 
						WHERE TABLE_CATALOG = @bd
							AND TABLE_SCHEMA = @sch
							AND TABLE_NAME = @table)
							
						BEGIN
							DECLARE
								@final_table NVARCHAR(256),		-- Variable con la tabla completa bd.sch.table
								@dynamic_values NVARCHAR(MAX),  -- Variable con los campos de cada tabla para poder conocer los duplicados de cualquier tabla
								@ParmDefinition NVARCHAR(500),  -- Parametros de sp_executesql
								@duplicates INT,				-- Variable para almacenar la salida de la ejecución
								@sql NVARCHAR(MAX)				-- Variable para almacenar la sql

							-- Obtenemos la tabla completa bd.sch.table
							SET @final_table = CONCAT(@bd, '.', @sch, '.', @table)
							-- Obtenemos los campos de cada tabla dinamicamente
							SET @dynamic_values = dbo.dynamicValues(@final_table)
							-- Establecemos los parametros de sp_executesql
							SET @ParmDefinition = N'@retvalOUT int OUTPUT'

							-- Obtenemos la sql que queremos ejecutar
							SET @sql = N'
								SELECT @retvalOUT = COUNT(*)
								FROM (
									SELECT *
									FROM ' + @final_table
									+ N'
									GROUP BY ' + @dynamic_values + 
									N' HAVING ( COUNT(*) > 1 )
								) A '
			
							-- Ejecutamos la sql
							EXEC sp_executesql @sql, @ParmDefinition, @retvalOUT=@duplicates OUTPUT

							-- Mostramos resultado si la info dada es correcta
							SET @msg = CONCAT('Se han detectado ', @duplicates, ' duplicados en la tabla ', @table)
						END
					ELSE
						SET @msg = 'Introduce una tabla válida en ese esquema y BD'
				ELSE
					SET @msg = 'Introduce un esquema válido en la BD'
			ELSE
				SET @msg = 'Introduce una BD válida'						
	SELECT @msg as msg
END

-- Pruebas de ejecución
EXEC RETO_1 
	@bd = 'SQL_EN_LLAMAS_ALUMNS', 
	@sch = 'case04',
	@table='sales'

EXEC RETO_1 
	@bd = 'SQL_EN_LLAMAS_ALUMNOS', 
	@sch = 'case0',
	@table='sales'

EXEC RETO_1 
	@bd = 'SQL_EN_LLAMAS_ALUMNOS', 
	@sch = 'case04',
	@table='sale'

EXEC RETO_1 
	@bd = 'SQL_EN_LLAMAS_ALUMNOS', 
	@sch = 'case04',
	@table='sales'

-- Borro procedure asegurandome que no falle y salga error si no existe
DROP PROCEDURE IF EXISTS RETO_1 

-- Borro función asegurandome que no falle y salga error si no existe
DROP FUNCTION IF EXISTS dbo.dynamicValues

--  El usuario puede introducir cualquier tabla para conocer sus duplicados al prescindir de sentencias hardcodeadas e intentar parametrizarlo al máximo.

/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Está perfecto, controla todas los posibles casos haciendo usos de las tablas de metadatos y hace su función
perfectamente. Muy currado, genial!!

*/

