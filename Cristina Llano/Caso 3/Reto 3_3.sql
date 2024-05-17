/* Crea un procedimiento de almacenado que al introducir el identificador del cliente y el mes, 
calcule el total de compras (purchase) y que te devuelva el siguiente mensaje:
"El cliente 1 se ha gastado un total de 1276 eur en compras de productos en el mes de marzo."
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE CLN_Case3_Reto3

@id_cliente_entrada INT,
@fecha_mes_entrada INT

AS

DECLARE @id_cliente INT = @id_cliente_entrada,
		@des_cliente VARCHAR(10) = CONVERT(VARCHAR(10),@id_cliente_entrada),
		@fecha_mes INT = @fecha_mes_entrada,
		@des_salida VARCHAR(100),
		@int_productos_totales INT,
		@fecha_mes_texto VARCHAR(15) = '0'
	
BEGIN
	-- Validamos que los datos introducidos con son correctos:
	-- 1. En primer lugar para no acceder a la tabla, se comprueba que el mes esté dentro del rango  
	IF @fecha_mes < 1 OR @fecha_mes > 12 
			SET @des_salida = 'El mes introducido no es válido'
	ELSE
	-- 2. Validamos que exista el cliente
		BEGIN
			IF NOT EXISTS(	SELECT DISTINCT customer_id
							FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
							WHERE customer_id = @id_cliente
						 )
				SET @des_salida = 'El cliente introducido no existe en nuestra base de datos'
			ELSE
			-- Comienza lo que se solicita
				BEGIN
					SELECT @int_productos_totales= SUM (txn_amount) 
					, @fecha_mes_texto = CONVERT(VARCHAR(15),COALESCE (MAX(DATENAME (MONTH,txn_date)), '0'))
					FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
					WHERE customer_id = @id_cliente
						AND MONTH (txn_date) = @fecha_mes
						AND txn_type = 'purchase'
					GROUP BY customer_id
					-- Validamos que aunque sea un mes valido tenga datos el cliente
					IF @fecha_mes_texto = '0'
						SET @des_salida = 'El cliente ' + @des_cliente + ' no tiene información para mes introducido'
					ELSE
					-- Mostramos la información correcta
						SET @des_salida = 'El cliente ' + @des_cliente + ' se ha gastado un total de ' + CAST(@int_productos_totales AS VARCHAR(6)) + ' eur en compras de productos en el mes de ' + @fecha_mes_texto
				END
		END
	SELECT @des_salida AS des_salida_informacion
END
GO
;

-------------
-- Ahora lanzamos el procedure creado para ver resultados
-- 1. Mes incorrecto
EXEC CLN_Case3_Reto3 1, 13;
-- 2. El cliente no existe 
EXEC CLN_Case3_Reto3 2006, 6;
-- 3. No existe ni el cliente ni el mes (debe ir por el caso 1, de no existe el mes)
EXEC CLN_Case3_Reto3 2006, 13;
-- 4. Insertamos el cliente que nos solicita el ejercicio
EXEC CLN_Case3_Reto3 1, 3;
-- 4. Insertamos el cliente que nos solicita el ejercicio pero con un mes que no tiene
EXEC CLN_Case3_Reto3 1, 6;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Enhorabuena Cristina, está genial!!

Resultado: OK
Código: OK.
Legibilidad: OK.

Controlas muy bien todas las casuísticas que se pueden dar incluyendo un mensaje para cada tipo de error; además de mostrar la información correctamente.


*/
