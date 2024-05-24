/*Guarda el cálculo del Balance, total depositado, total de compras y total de retiros en distintas funciones
y aplícalas en el procedimiento de ayer. Recordatorio: el procedimiento debe dejarnos elegir la operación, el mes y el cliente.*/
-- Creamos la función de apoyo
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION CLN_CalculosBase
(	-- Parámetros recibidos
	@id_cliente_entrada INT,
	@fecha_mes_entrada INT,
	@tipo_calculo INT
) 
RETURNS VARCHAR (100)
AS 
BEGIN

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
		@int_total_retiros INT = 0,
		@int_balance INT = 0

		-- Se realizan los cálculos necesarios:
		SELECT @int_total_depositos = int_total_depositos
			, @int_total_compras = int_total_compras
			, @int_total_retiros = int_total_retiros
			, @fecha_mes_texto = fecha_mes_texto
			, @int_balance = (int_total_depositos-int_total_compras-int_total_retiros)
		FROM 
		(
			SELECT ISNULL(SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount END),0) AS int_total_depositos
				, ISNULL(SUM(CASE WHEN txn_type = 'purchase' THEN txn_amount END),0) AS int_total_compras
				, ISNULL(SUM(CASE WHEN txn_type = 'withdrawal' THEN txn_amount END),0) AS int_total_retiros
				, CONVERT(VARCHAR(15),COALESCE (MAX(DATENAME (MONTH,txn_date)), '0')) AS fecha_mes_texto
			FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
			WHERE customer_id = @id_cliente
			AND MONTH(txn_date) = @fecha_mes
		)A
		-- Siempre tenemos en cuenta que el cliente tenga datos en este mes
		IF  @fecha_mes_texto <> '0' AND @cod_tipo_calculo IN (1)
			SET @des_salida = 'El cliente ' + CAST(@id_cliente AS VARCHAR(5)) + ' tiene un balance de ' + CAST(@int_total_depositos-@int_total_compras-@int_total_retiros AS VARCHAR(10)) + ' de euros en el mes de ' + @fecha_mes_texto
		IF  @fecha_mes_texto <> '0' AND @cod_tipo_calculo IN (2,3,4) 
			SET @des_salida = 'El cliente ' + @des_cliente + ' tiene un total de ' + 
							   CASE WHEN @cod_tipo_calculo = 2 THEN CAST(@int_total_depositos AS VARCHAR(6)) 
									WHEN @cod_tipo_calculo = 3 THEN CAST(@int_total_compras AS VARCHAR(6)) 
									WHEN @cod_tipo_calculo = 4 THEN CAST(@int_total_retiros AS VARCHAR(6)) 
							   END	+
							   ' eur en ' + @des_tipo_calculo + ' en el mes de ' + @fecha_mes_texto
		-- El no tiene datos en el mes solicitado.
		IF @fecha_mes_texto = '0'
			SET @des_salida = 'El cliente ' + @des_cliente + ' no puede mostrar información porque no tiene datos en el mes introducido'						
		-- Return devuelto en la función
		RETURN @des_salida
END;

-- Creamos procedimiento que hará llamada a la función.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE CLN_Case3_Reto5
    -- Parámetros recibidos
	@id_cliente_entrada INT,
	@fecha_mes_entrada INT,
	@tipo_calculo INT
AS
BEGIN
	DECLARE @id_cliente INT = @id_cliente_entrada,
		@fecha_mes INT = @fecha_mes_entrada,
		@des_salida VARCHAR(200),
		@cod_tipo_calculo INT = @tipo_calculo
		
	-- Tipo de movimiento en rango
	IF @cod_tipo_calculo BETWEEN 1 AND 4
		-- Mes en rango  
		IF @fecha_mes BETWEEN 1 AND 12 
			-- Por último se accede a la tabla ver si existe el cliente
			IF EXISTS(	SELECT DISTINCT customer_id
						FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
						WHERE customer_id = @id_cliente
					 )
				-- Después de una validación mínima hacemos llamada la función para obtener los cálculos
				SET @des_salida = SQL_EN_LLAMAS_ALUMNOS.dbo.CLN_CalculosBase(@id_cliente_entrada, @fecha_mes_entrada, @tipo_calculo)
			ELSE 
				SET @des_salida = 'El cliente ' + CAST(@id_cliente_entrada AS VARCHAR(10)) + ' no existe en la bbdd'
		ELSE
			SET @des_salida = 'El mes introducido deber ser en 1 y 12'
	ELSE
		SET @des_salida = 'El cálculo debe ser entre 1 y 4'
		
	SELECT @des_salida AS des_salida_informacion	
END;		
		
-- Se realizan las misma ejecuciones que contemplan todas casuísticas.
EXEC CLN_Case3_Reto5 1, 13, 1; 	 -- 1. Mes incorrecto
EXEC CLN_Case3_Reto5 2006, 6, 1 ; -- 2. Cliente no existente
EXEC CLN_Case3_Reto5 2006, 13, 1; -- 3. No existe ni el cliente ni el mes (debe ir por el caso 1, de no existe el mes)
EXEC CLN_Case3_Reto5 1, 3, 5; -- 4. Cálculo fuera de rango
EXEC CLN_Case3_Reto5 1, 3, 1; -- 5. balance
EXEC CLN_Case3_Reto5 1, 3, 2; -- 6. deposit
EXEC CLN_Case3_Reto5 1, 3, 3; -- 7. purchase
EXEC CLN_Case3_Reto5 5, 3, 4; -- 8. withdrawal
EXEC CLN_Case3_Reto5 1, 6, 1; -- 9. Cliente con un mes sin datos
EXEC CLN_Case3_Reto5 1, 3, 4; -- 10. Cliente sin información tipo solicitado



/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Enhorabuena Cristina, perfecto, en la línea de este caso!!

Resultado: OK
Código: OK.
Legibilidad: OK.


*/
