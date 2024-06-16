/* Crear un procedimiento almacenado que dado el nombre de una tabla nos diga los posibles registros duplicados*/
create PROCEDURE JLMG_Ejercicio4_1_BuscarDuplicados
@nombre_tabla varchar(128) ---- El nombre de la tabla debe ir acompañado del esquema y de la BBDD donde busca si se quiere

AS
BEGIN
    --- Cargamos las columnas de la tabla en una variable para luego componer la select.
    DECLARE @columnas NVARCHAR(MAX)
    SET @columnas = (
        SELECT STRING_AGG(name, ', ')
        FROM syscolumns
        WHERE id = OBJECT_ID( @nombre_tabla)
                    )
	
	if @columnas is not null   --- Si no tenemos columnas es que no hemos encontrado la tabla y devolveremos un mensaje
	begin 
	
			--- Buscamos los posibles casos que haya en que todas la columnas sean igual y contamos.
				DECLARE @sql NVARCHAR(MAX)
			SET @sql = N'
				SELECT ' + @columnas + ', COUNT(*) AS Cantidad
				FROM ' + @nombre_tabla + '
				GROUP BY ' + @columnas + '
				HAVING COUNT(*) > 1'
   
				EXEC sp_executesql @sql
	 end else
	 begin
	         Select 'El nombre de la tabla no se encuentra en la base de datos'

	 end 
END;
/*---- La ejecución de SP */
exec JLMG_Ejercicio4_1_BuscarDuplicados '[SQL_EN_LLAMAS_ALUMNOS].[case04].[sales]';

/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Genial solución usando los metadatos para encontrar las columnas. Como parte extra, por ejemplo, se podría
construir una solución más general para cualquier tabla pasando base de datos, esquema y tabla para comprobar las distintas tablas de metadatos y
realizar el mismo proceso.

RESULTADO: OK.
CÓDIGO: OK.
LEGIBILIDAD: OK.

*/

