/*Evoluciona el procedimiento de ayer para que podamos elegir el tipo de cálculo que nos devuelva por mes y cliente:
- Balance: Depósito - Compra - Retiros
- Total depositado
- Total de compras
- Total de retiros*/


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE CLN_Case3_Reto4

@id_cliente_entrada INT,
@fecha_mes_entrada INT,
@tipo_calculo INT

AS

DECLARE @id_cliente INT = @id_cliente_entrada,
		@des_cliente VARCHAR(10) = CONVERT(VARCHAR(10),@id_cliente_entrada),
		@fecha_mes INT = @fecha_mes_entrada,
		@des_salida VARCHAR(200),
		@fecha_mes_texto VARCHAR(15) = '0',
		@cod_tipo_calculo INT = @tipo_calculo,
		@des_tipo_calculo VARCHAR(15) = CASE WHEN @tipo_calculo = 1	THEN 'balance'
											 WHEN @tipo_calculo = 2 THEN 'deposit'
											 WHEN @tipo_calculo = 3 THEN 'purchase'
											 WHEN @tipo_calculo = 4 THEN 'withdrawal'
											 ELSE '0'
										END,
		@int_total_compras INT = 0,
		@int_total_depositos INT = 0,
		@int_total_retiros INT = 0
	
BEGIN
	-- Validación 1 sin acceso a la tabla: tipo de movimiento sea correcto
	IF @cod_tipo_calculo < 1 OR @cod_tipo_calculo > 4
		SET @des_salida = 'El número de movimientos debe ser entre 1 y 4'
	ELSE
		BEGIN
			-- Validación sin acceso a la tabla: se comprueba que el mes esté dentro del rango  
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
							SELECT @int_total_depositos = COALESCE(SUM(CASE WHEN txn_type = 'deposit'    THEN txn_amount END),0)
								, @int_total_compras  = COALESCE(SUM(CASE WHEN txn_type = 'purchase'   THEN txn_amount END),0) 
								, @int_total_retiros   = COALESCE(SUM(CASE WHEN txn_type = 'withdrawal' THEN txn_amount END),0)
								, @fecha_mes_texto = CONVERT(VARCHAR(15),COALESCE (MAX(DATENAME (MONTH,txn_date)), '0'))
							FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
							WHERE customer_id = @id_cliente
							AND MONTH(txn_date) = @fecha_mes	

							IF  @fecha_mes_texto <> '0' AND @cod_tipo_calculo IN (1)
								SET @des_salida = 'El cliente ' + CAST(@id_cliente AS VARCHAR(5)) + ' tiene un balance de ' + CAST(@int_total_depositos-@int_total_compras-@int_total_retiros AS VARCHAR(10)) + ' de euros en el mes de ' + @fecha_mes_texto
							IF  @fecha_mes_texto <> '0' AND @cod_tipo_calculo IN (2) --deposit
								SET @des_salida = 'El cliente ' + @des_cliente + ' tiene un total de ' + CAST(@int_total_depositos AS VARCHAR(6)) + ' eur en ' + @des_tipo_calculo + ' en el mes de ' + @fecha_mes_texto
							IF  @fecha_mes_texto <> '0' AND @cod_tipo_calculo IN (3) --purchase
								SET @des_salida = 'El cliente ' + @des_cliente + ' tiene un total de ' + CAST(@int_total_compras AS VARCHAR(6)) + ' eur en ' + @des_tipo_calculo + ' en el mes de ' + @fecha_mes_texto
							IF  @fecha_mes_texto <> '0' AND @cod_tipo_calculo IN (4) --withdrawal
								SET @des_salida = 'El cliente ' + @des_cliente + ' tiene un total de ' + CAST(@int_total_retiros AS VARCHAR(6)) + ' eur en ' + @des_tipo_calculo + ' en el mes de ' + @fecha_mes_texto
							IF @fecha_mes_texto = '0'
								SET @des_salida = 'El cliente ' + @des_cliente + ' no puede mostrar información porque no tiene datos en el mes introducido'						
						END
				END
		END
		SELECT @des_salida AS des_salida_informacion
END
GO
;

-- Ahora lanzamos el procedure creado para ver resultados
-- 1. Mes incorrecto
EXEC CLN_Case3_Reto4 1, 13,1;
-- 2. El cliente no existe 
EXEC CLN_Case3_Reto4 2006, 6,1 ;
-- 3. No existe ni el cliente ni el mes (debe ir por el caso 1, de no existe el mes)
EXEC CLN_Case3_Reto4 2006, 13,1;
-- 4. No ha introducido la opción correcta de cálculo
EXEC CLN_Case3_Reto4 1, 3, 5;
-- 5. Insertamos el cliente que nos solicita el ejercicio
EXEC CLN_Case3_Reto4 1, 3, 1;
EXEC CLN_Case3_Reto4 1, 3, 2;
EXEC CLN_Case3_Reto4 1, 3, 3;
EXEC CLN_Case3_Reto4 5, 3, 4;
-- 6. Insertamos el cliente que nos solicita el ejercicio pero con un mes que no tiene
EXEC CLN_Case3_Reto4 1, 6, 1;
-- 7. Insertamos datos para un cliente que no tiene el tipo solicitado
EXEC CLN_Case3_Reto4 1, 3, 4;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Muy bien Cristina, enhorabuena!!

Resultado: OK
Código: OK.
Legibilidad: OK.

Muy bueno siempre el punto de dar ejemplos para ver la funcionalidad del procedimiento fácilmente.


*/
