--Crea un procedimieno almacenado que al introducir el identificador del cliente y el mes, calcule el total de compras (purchase) y 
-- que te devuelva el siguiente mensaje: "El cliente 1 se ha gastado un total de 1276 EUR en compras de productos en el mes de marzo".

-- Creo un procedimiento que permita la entrada de cliente y mes
CREATE OR ALTER PROCEDURE RETO_3 
	@customer_id INT, 
	@month INT
AS
BEGIN
	-- Declaro variables 
	DECLARE 
		@Max_customer INT, -- para controlar la entrada de cliente
		@Min_customer INT, -- para controlar la entrada de cliente
		@msg nvarchar(256) -- mensaje de salida

	-- Establezco el valor maximo y minimo de cliente en función de la información que tenemos en la tabla
	SELECT 
		@Max_customer = MAX(customer_id),
		@Min_customer =  MIN(customer_id)
	FROM case03.customer_transactions

	--Controlo las entradas
	IF @month BETWEEN 1 AND 12 -- Que los meses sean de enero a diciembre

		IF @customer_id BETWEEN @Min_customer AND @Max_customer -- Que el cliente exista en la BD

			SELECT @msg = CONCAT('El cliente ', @customer_id, ' se ha gastado un total de ', COALESCE(SUM(txn_amount),0), ' EUR en compras de productos en el mes de ', DATENAME(MONTH, DATEADD(MONTH, @month, -1)))
			FROM case03.customer_transactions
			WHERE txn_type = 'purchase' and customer_id = @customer_id and month(txn_date) = @month

		ELSE
			SET @msg = 'El cliente no existe'
	ELSE
		SET @msg = 'El mes no existe'

	SELECT @msg AS msg
END;
		
-- Comprobación del procedure
EXEC Reto_3 1, 3; 
EXEC Reto_3 506, 3; 
EXEC Reto_3 1, 13; 

-- Borro procedure asegurandome que no falle y salga error si no existe
DROP PROCEDURE IF EXISTS RETO_3 


/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Está perfecto. Contempla casos correctos y casos en que se introduzcan mal los datos.

*/
