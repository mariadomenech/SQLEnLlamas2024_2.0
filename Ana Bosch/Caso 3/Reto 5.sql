-- RETO 5:
-- Guarda el cálculo del balance, total depositado, total de compras y total de retiros en distintas funciones y aplícalas en el procedimiento de ayer. 
-- Recordatorio: el procedimiento debe dejarnos elegir la operación, el mes y el cliente.

-- Creo una función reutilizable para cualquier tipo de movimiento (no llevaría comprobaciones 
-- ya que estas las dejo dentro del procedure evitando entrar en la función si no cumple las condiciones
CREATE OR ALTER FUNCTION dbo.getMov (
	@customer_id INT,
	@month INT,
	@movimiento INT
)
RETURNS NVARCHAR(256)
AS
BEGIN
	DECLARE 
		@depositos INT,
		@compras INT,
		@retiros INT

	-- Pivoto la tabla para tener depositos, compras y retiros como columnas y almacenar en variables sus sumas
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

	-- En función del tipo de operación devuelvo un mensaje
	RETURN (SELECT
				CASE 
					WHEN @movimiento = 1 THEN CONCAT('El cliente ', @customer_id, ' tiene un balance de ', @depositos - @compras - @retiros, ' EUR en el mes de ', DATENAME(MONTH, DATEADD(MONTH, @month, -1)))
					WHEN @movimiento = 2 THEN CONCAT('El cliente ', @customer_id, ' ha depositado un total de ', @depositos, ' EUR en el mes de ', DATENAME(MONTH, DATEADD(MONTH, @month, -1)))
					WHEN @movimiento = 3 THEN CONCAT('El cliente ', @customer_id, ' ha comprado un total de ', @compras, ' EUR en el mes de ', DATENAME(MONTH, DATEADD(MONTH, @month, -1)))
					WHEN @movimiento = 4 THEN CONCAT('El cliente ', @customer_id, ' ha retirado un total de ', @retiros, ' EUR en el mes de ', DATENAME(MONTH, DATEADD(MONTH, @month, -1)))
				END)
END;

-- Creo un procedimiento que permita la entrada de cliente y mes
CREATE OR ALTER PROCEDURE procMov 
	@customer_id INT, 
	@month INT,
	@movimiento INT
AS
BEGIN
	-- Declaro variables 
	DECLARE 
		@Max_customer INT, -- para controlar la entrada de cliente
		@Min_customer INT, -- para controlar la entrada de cliente
		@msg NVARCHAR(256) -- mensaje de salida
		
	-- Establezco el valor maximo y minimo de cliente en función de la información que tenemos en la tabla
	SELECT 
		@Max_customer = MAX(customer_id),
		@Min_customer =  MIN(customer_id)
	FROM case03.customer_transactions

	--Controlo las entradas
	IF @month BETWEEN 1 AND 12 -- Que los meses sean de enero a diciembre

		IF @customer_id BETWEEN @Min_customer AND @Max_customer -- Que el cliente exista en la BD
		
			IF @movimiento IN (1,2,3,4) -- Que el movimiento exista
				SET @msg = dbo.getMov(@customer_id,@month,@movimiento) -- si existe llamamos a la función
			ELSE 
				SET @msg = 'El movimiento no existe'
		ELSE
			SET @msg = 'El cliente no existe'
	ELSE
		SET @msg = 'El mes no existe'

	SELECT @msg AS msg
END;
		
-- Comprobación del procedure
EXEC Reto_3 1, 3, 1; 
EXEC Reto_3 1, 3, 2; 
EXEC Reto_3 1, 3, 3; 
EXEC Reto_3 1, 3, 4; 
EXEC Reto_3 0, 3, 1; 
EXEC Reto_3 1, 0, 1; 
EXEC Reto_3 1, 3, 0; 

-- Borro procedure asegurandome que no falle y salga error si no existe
DROP PROCEDURE IF EXISTS procMov 

-- Borro función asegurandome que no falle y salga error si no existe
DROP FUNCTION IF EXISTS dbo.getMov
