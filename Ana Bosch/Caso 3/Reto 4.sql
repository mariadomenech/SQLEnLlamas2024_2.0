-- RETO 4:
-- Evoluciona el procedimiento de ayer para que podamos elegir el tipo de cálculo que nos devuelva por mes y cliente:
-- "Balance: depósito - compra - retiros"; "Total depositado"; "Total de compras"; "Total de retiros".

CREATE OR ALTER PROCEDURE RETO_4
	@customer_id INT, 
	@month INT,
	@movimiento INT
AS
BEGIN
	-- Declaro variables 
	DECLARE 
		@Max_customer INT, -- para controlar la entrada de cliente
		@Min_customer INT, -- para controlar la entrada de cliente
		@msg nvarchar(256), -- mensaje de salida
		@movimiento_txt nvarchar(256), -- movimiento a realizar
		@movimientos_txt_es nvarchar(256), -- variable para reutilizar texto
		@total INT, -- variable para reutilizar calculos
		@depositos INT, -- variable para almacenar depositos
		@retiros INT, -- variable para almacenar retiros
		@compras INT -- variable para almacenar compras
		
	-- Establezco el valor maximo y minimo de cliente en función de la información que tenemos en la tabla
	SELECT 
		@Max_customer = MAX(customer_id),
		@Min_customer =  MIN(customer_id)
	FROM case03.customer_transactions

	-- Establezco el valor de las variables para automatizar en una unica select las consultas de los 3 movimientos
	SET @movimiento_txt  = 
		CASE 
			WHEN @movimiento = 2 THEN 'deposit'
			WHEN @movimiento = 3 THEN 'purchase'
			WHEN @movimiento = 4 THEN 'withdrawal'
		END

	-- Establezco el valor de las variables a mostrar para unificar lo máximo posible el mensaje sin repetir código
	SET @movimientos_txt_es = 
		CASE 
			WHEN @movimiento = 1 THEN 'balance'
			WHEN @movimiento = 2 THEN 'depositado'
			WHEN @movimiento = 3 THEN 'comprado'
			WHEN @movimiento = 4 THEN 'retirado'
		END

	--Controlo las entradas
	IF @month BETWEEN 1 AND 12 -- Que los meses sean de enero a diciembre

		IF @customer_id BETWEEN @Min_customer AND @Max_customer -- Que el cliente exista en la BD
		BEGIN

			-- Calculo en función del movimiento que quiero hacer (en este caso depositos, compras y retiros)
			IF @movimiento IN (2,3,4)
				
				SELECT @total = COALESCE(SUM(txn_amount),0)
				FROM case03.customer_transactions
				WHERE txn_type = @movimiento_txt and customer_id = @customer_id and month(txn_date) = @month

			-- Calculo en función del movimiento que quiero hacer (en este caso balance)
			-- establezco como columnas los diferentes movimientos y almaceno en variables la suma de cada columna
			ELSE IF @movimiento = 1
			BEGIN
				-- Establezco las columnas
				SELECT 
					@depositos = COALESCE(SUM(deposit),0),
					@compras = COALESCE(SUM(purchase),0),
					@retiros = COALESCE(SUM(withdrawal),0)
				FROM (
					SELECT *
					FROM (
						SELECT *
						FROM case03.customer_transactions
					) AS prueba 
					PIVOT (
							SUM(txn_amount) 
							FOR txn_type IN ([deposit], [purchase], [withdrawal])
					)AS Tabla_Pivotada
				) A
				WHERE customer_id = @customer_id and month(txn_date) = @month

				-- Calculo el total del balance
				SET @total = @depositos - @compras - @retiros
			END

			-- Establezco el mensaje a mostrar
			SET @msg = 
				CASE 
					WHEN @movimiento IN (2,3,4) THEN CONCAT('El cliente ', @customer_id, ' ha ', @movimientos_txt_es, ' un total de ', @total, ' EUR en el mes de ', DATENAME(MONTH, DATEADD(MONTH, @month, -1)))
					WHEN @movimiento = 1 THEN CONCAT('El cliente ', @customer_id, ' tiene un ', @movimientos_txt_es, ' de ', @total, ' EUR en el mes de ', DATENAME(MONTH, DATEADD(MONTH, @month, -1)))
					ELSE 'El movimiento no existe'
				END
		END

		ELSE
			SET @msg = 'El cliente no existe'
	ELSE
		SET @msg = 'El mes no existe'

	SELECT @msg AS msg
END;
		
-- Comprobación del procedure
EXEC RETO_4 1, 3, 1; 
EXEC RETO_4 0, 3, 1; 
EXEC RETO_4 1, 0, 1; 
EXEC RETO_4 1, 3, 0; 

-- Borro procedure asegurandome que no falle y salga error si no existe
DROP PROCEDURE IF EXISTS RETO_4 


-- COMENTARIO: he intentado reutilizar código en lo máximo posible. Lo he realizado en los calculos evitando repetir consultas y en los mensajes de salida evitando repetir texto



/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Me encanta la solución y el uso de la lógica de programación. Solución muy completa y reutilizable. Enhorabuena! :)

*/
