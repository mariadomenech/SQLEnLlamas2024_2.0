/* CREACIÓN DE FUNCIONES */
CREATE OR ALTER FUNCTION dbo.GetNombreColumnas(@nombreEsquema VARCHAR(20), @nombreTabla VARCHAR(20)) 
RETURNS NVARCHAR (MAX)
AS 
BEGIN
	DECLARE
		@nombreColumnas NVARCHAR(MAX)

	SELECT 
		 @nombreColumnas = STRING_AGG(COLUMN_NAME, ', ')
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_SCHEMA = @nombreEsquema 
		AND TABLE_NAME = @nombreTabla
	
	RETURN @nombreColumnas
END;

/* CREACIÓN DEL PROCEDURE */
CREATE OR ALTER PROCEDURE NumeroDuplicados
	@nombreBD VARCHAR(30)
	,@nombreEsquema VARCHAR(30)
  ,@nombreTabla VARCHAR(30)
AS
BEGIN
	DECLARE @nombreTablaCompleto NVARCHAR(100)
	DECLARE @nombreColumnas NVARCHAR(MAX)
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @tablaIntermedia TABLE (duplicados INT)
	DECLARE @numeroDuplicados NVARCHAR(10)
	DECLARE @outputMensaje NVARCHAR(MAX)

	SET @nombreTablaCompleto = QUOTENAME(@nombreBD) + N'.' + QUOTENAME(@nombreEsquema) + N'.' + QUOTENAME(@nombreTabla)

	IF EXISTS (SELECT * FROM sys.objects WHERE QUOTENAME(DB_NAME(db_id())) = QUOTENAME(@nombreBD))
		IF EXISTS (SELECT * FROM sys.objects WHERE QUOTENAME(DB_NAME(db_id())) = QUOTENAME(@nombreBD) 
			AND QUOTENAME(OBJECT_SCHEMA_NAME(object_id, db_id())) = QUOTENAME(@nombreEsquema))
			IF EXISTS (SELECT * FROM sys.objects WHERE QUOTENAME(DB_NAME(db_id())) = QUOTENAME(@nombreBD) 
				AND  QUOTENAME(OBJECT_SCHEMA_NAME(object_id, db_id())) = QUOTENAME(@nombreEsquema) 
				AND QUOTENAME(OBJECT_NAME(object_id, db_id())) = QUOTENAME(@nombreTabla))
				BEGIN
					SET @nombreColumnas = dbo.GetNombreColumnas(@nombreEsquema, @nombreTabla)

					SET @sql = 'SELECT COUNT(*) FROM (
						SELECT *, COUNT(*) AS duplicados
						FROM ' + @nombreTablaCompleto +
						' GROUP BY ' + @nombreColumnas +
						' HAVING COUNT(*) > 1
						) consulta'

					INSERT INTO @tablaIntermedia EXEC sp_executesql @sql

					SELECT @numeroDuplicados=duplicados FROM @tablaIntermedia

					SET @OutputMensaje = 'Se han detectado ' + @numeroDuplicados + ' duplicados en la tabla ' + UPPER(@nombreTabla) 
				END
			ELSE
				SET @OutputMensaje = 'No existe la tabla seleccionada ' + UPPER(@nombreTabla) + ' en el esquema ' + UPPER(@nombreEsquema) + ', por favor, introduzca el nombre de una tabla válida para esta BD y esquema'
		ELSE
			SET @OutputMensaje = 'No existe el esquema seleccionado ' + UPPER(@nombreEsquema) + ', por favor, introduzca uno válido para esta BD'
	ELSE
		SET @OutputMensaje = 'No existe la BD seleccionada ' + UPPER(@nombreBD) + ', por favor, introduzca el nombre de una BD válida'

	SELECT @OutputMensaje AS Mensaje
END;

/* PRUEBAS DE EJECUCIONES  */
EXEC NumeroDuplicados @nombreBD = 'SQL_EN_LLAMAS_ALUMNOS', @nombreEsquema = 'case04', @nombreTabla = 'sales'
EXEC NumeroDuplicados @nombreBD = SQL_EN_LLAMAS_ALUMNOS, @nombreEsquema = case04, @nombreTabla = product_details
EXEC NumeroDuplicados @nombreBD = SQL_EN_LLAMAS_ALUMNOSA, @nombreEsquema = case04, @nombreTabla = sales
EXEC NumeroDuplicados @nombreBD = SQL_EN_LLAMAS_ALUMNOS, @nombreEsquema = case045, @nombreTabla = sales
EXEC NumeroDuplicados @nombreBD = SQL_EN_LLAMAS_ALUMNOS, @nombreEsquema = case02, @nombreTabla = sales

/* ELIMINACIÓN DEL PROCEDIMIENTO */
DROP PROCEDURE IF EXISTS NumeroDuplicados;

/* ELIMINACIÓN DE LAS FUNCIONES */
DROP FUNCTION GetNombreColumnas;

/* EXPLICACIÓN DE LA LÓGICA SEGUIDA 
1) Se ha creado una función en la cual, pasándole como parámetros el nombre del esquema y el nombre de la tabla, nos devuelve como resultado
el nombre de las columnas de esta tabla separándolas por comas de la forma col1, col2, col3, etc.
2) Se ha creado un procedimiento que recibe por parámetro 3 variables, el nombre de una BD, el nombre de un esquema y el nombre de una tabla.
Dentro de este creamos el nombre completo de la tabla con su esquema y BD para utilizarlo en la consulta y obtenemos el nombre de las columnas de las tablas
con la función creada al principio.
Se hacen las comprobaciones de errores oportunas (en este orden):
	- Que exista la BD elegida
	- Que exista el esquema elegido
	- Que exista el nombre de la tabla elegida
Si todo es correcto, se genera una consulta donde se le pasa el nombre completo de la tabla y el nombre de las columnas (obtenido con la función) y se obtiene
el número de registros duplicados para esa tabla. Se inserta el valor obtenido en una tabla intermedia y se vuelca en una variable tipo texto.
Una vez con esto, se genera el mensaje correspondiente. En caso de que hubiese algún error, también se genera el mensaje correspondiente al mismo. */
