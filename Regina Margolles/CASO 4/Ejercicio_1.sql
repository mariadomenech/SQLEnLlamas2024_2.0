CREATE OR ALTER PROCEDURE RMC_Caso5_Ejercicio1 
 @DB NVARCHAR(128) = NULL,
 @TABLE_SCHEMA NVARCHAR(128) = NULL,
 @TABLE_NAME NVARCHAR(128) = NULL, 
 @RESULTADO NVARCHAR(128) OUTPUT
AS
BEGIN


DECLARE @COLUMN_NAMES NVARCHAR(MAX) = NULL,
		    @QUERY NVARCHAR(MAX) = NULL,
		    @var int = NULL;

IF EXISTS
(

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_CATALOG = @DB AND TABLE_SCHEMA = @TABLE_SCHEMA AND TABLE_NAME = @TABLE_NAME

)
BEGIN

SET @COLUMN_NAMES = (SELECT STRING_AGG(COLUMN_NAME,',')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_CATALOG = @DB AND TABLE_SCHEMA = @TABLE_SCHEMA AND TABLE_NAME = @TABLE_NAME);

SET @QUERY =('Select @var = COUNT(*)'+ 
             ' from
              (
              SELECT  * 
              		FROM ' + @DB + '.' + @TABLE_SCHEMA + '.' + @TABLE_NAME +
              		' GROUP BY ' + @COLUMN_NAMES +
              		' HAVING COUNT(*)>1
              )as t'
            );

Exec sp_executesql @QUERY, N'@var int out', @var OUTPUT
SET @resultado = 'SE HAN DETECTADO ' + CAST (@var AS varchar(12) )+ ' DUPLICADOS EN LA TABLA ' + @TABLE_NAME
END
END
GO



/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Bien planteado! Solo me queda incluyas la llamada al procedimiento con alguna variable de ejemplo.

Código: OK
Legibilidad: OK
Resultado: OK
*/
