/* Alumno: Sergio Díaz */
/* CASO 4 - Ejercicio 1: Procedure para obtener registros duplicados dada una tabla */


CREATE PROCEDURE [dbo].[SDF_CASO4_RETO1] @TablaCompleta NVARCHAR(100) --Parametro de entrada de nuestro procedimiento (tabla en formato BBDD.Esquema.NombreTabla)
AS
BEGIN
	DECLARE @Columnas NVARCHAR(MAX) -- Declaramos todas nuestras variables
	DECLARE @RegistrosDuplicados INT
	DECLARE @BBDD VARCHAR(100)
	DECLARE @Esquema VARCHAR(100)
	DECLARE @Tabla VARCHAR(100)
	DECLARE @SQLString NVARCHAR(MAX);
	DECLARE @ParmDefinition NVARCHAR(100);

	SELECT @BBDD = Value --Separamos el parametro de entrada recibido para obtener la bbdd, el esquema y el nombre de la tabla
	FROM String_Split(@TablaCompleta, '.', 1)
	WHERE Ordinal = 1

	SELECT @Esquema = Value
	FROM String_Split(@TablaCompleta, '.', 1)
	WHERE Ordinal = 2

	SELECT @Tabla = Value
	FROM String_Split(@TablaCompleta, '.', 1)
	WHERE Ordinal = 3

	IF ( --Chequeamos si existe la tabla en la BBDD
			EXISTS (
				SELECT *
				FROM INFORMATION_SCHEMA.TABLES
				WHERE TABLE_CATALOG = @BBDD
					AND TABLE_SCHEMA = @Esquema
					AND TABLE_NAME = @Tabla
				)
			)
	BEGIN 
		SELECT @Columnas = STRING_AGG(COLUMN_NAME, ',') -- Obtenemos todas las columnas de la tabla
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_CATALOG = @BBDD
			AND TABLE_SCHEMA = @Esquema
			AND TABLE_NAME = @Tabla

		SET @SQLString = N'SELECT  @RegTotOut = COUNT(*) FROM ( SELECT * FROM ' + @TablaCompleta + ' GROUP BY ' + @Columnas + ' HAVING (COUNT (*) > 1 ) ) PR '; --Formamos nuestra query dinámica
		SET @ParmDefinition = N'@RegTotOut INT OUTPUT'; -- Definimos un parámetro de salida de nuestra sql dinámica

		EXEC sp_executesql @SQLString
			,@ParmDefinition
			,@RegTotOut = @RegistrosDuplicados OUTPUT -- Ejecutamos la sql y asignamos el resultado a la variable

		SELECT CONCAT (
				'La tabla '
				,@TablaCompleta
				,' cuenta con un total de '
				,@RegistrosDuplicados
				,' registros duplicados'
				) AS MENSAJE --Mensaje de salida
	END
	ELSE
		SELECT 'La tabla introducida no existe' AS MENSAJE -- Mensaje de salida si la tabla no existe
END

------EJECUCIONES DEL PROCEDURE-------
EXEC SDF_CASO4_RETO1 'SQL_EN_LLAMAS_ALUMNOS.case04.sales'
EXEC SDF_CASO4_RETO1 'SQL_EN_LLAMAS_ALUMNOS.case04.product_details'



/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Bien planteado! Controlas todas las casuísticas! Buen uso de la tabla de sistema INFORMATION_SCHEMA.COLUMNS para montar una sql dinámica.

Código: OK
Legibilidad: OK
Resultado: OK
*/
