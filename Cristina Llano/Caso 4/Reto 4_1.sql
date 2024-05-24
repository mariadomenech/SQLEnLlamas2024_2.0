/*Las tablas no están muy limpias, crea un procedimiento de almacenado que informando el nombre de la tabla nos devuelva el número de posibles duplicados*/

USE [SQL_EN_LLAMAS_ALUMNOS]
GO
-- Ulizamos el use con el nombre de la bbd con el fin de que no tengamos que hacer validaciones extras
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE CLN_Case4_Reto1

@nombre_tabla VARCHAR(50)

AS
    DECLARE @des_nombre_tabla VARCHAR(50) = @nombre_tabla,
			-- Como solo se solicita en la tarea nombre de tabla nos centramos en ello.
			-- Asignamos el esquema con el que estamos trabajando.
			@des_bbdd_tabla VARCHAR(20) = 'case04.', 
			@des_concat_columnas NVARCHAR(MAX),
			@query_sql NVARCHAR(MAX),
			@des_salida VARCHAR(200),
			@int_resultado INT 
BEGIN		
	-- Validamos si existe la tabla indicada
	IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = @des_nombre_tabla)
		SET @des_salida = 'La tabla introducida '+ @des_nombre_tabla +' no es correcta'
	ELSE
		BEGIN
			-- En primer lugar horizontalizamos los campos en una variable.
			SET @des_concat_columnas = (SELECT STRING_AGG(name, ', ') FROM sys.syscolumns WHERE id = OBJECT_ID(concat(@des_bbdd_tabla,@des_nombre_tabla)))

			SET @query_sql = N'	SELECT @int_resultado = COUNT(*) FROM 
      								(	SELECT ' + @des_concat_columnas + ', COUNT(*) AS num_total_dupli
      									FROM ' + @des_bbdd_tabla + @des_nombre_tabla + '
      									GROUP BY ' + @des_concat_columnas + '
      									HAVING COUNT(*) > 1
      								) dupli;'

			EXEC sp_executesql @query_sql, N'@int_resultado INT OUTPUT', @int_resultado OUTPUT

			SET @des_salida = 'Esta tabla puede tener un total de ' + CAST(@int_resultado AS VARCHAR(20)) + ' duplicados'
		END
	SELECT @des_salida AS des_salida_informacion
END;
-- Ahora lanzamos el procedure creado para ver resultados
EXEC CLN_Case4_Reto1 'sales'; 
EXEC CLN_Case4_Reto1 'sales_mala'; 

/* Para finalizar eliminamos el procedure si no lo hemos hecho ya */
DROP PROCEDURE IF EXISTS CLN_Case4_Reto1;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Enhorabuena Cristina, está genial!!

Resultado: OK
Código: OK.
Legibilidad: OK.

Muy bien organizado y me ha gustado mucho que lo hagas tan generalizado con las variables.

Sigue así ya queda nada!!


*/
