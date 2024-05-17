/* CREACIÓN DE FUNCIONES */
-- Función para el total de compras de un mes y cliente
CREATE OR ALTER FUNCTION dbo.GetTotalCompras (@customerID INT, @mes INT) 
RETURNS INT 
AS 
BEGIN
	DECLARE @totalCompras INT 
	SELECT 
		@totalCompras = ISNULL(SUM(txn_amount),0) 
	FROM case03.customer_transactions 
	WHERE customer_id = @customerID 
		AND MONTH(txn_date) = @mes 
		AND txn_type = 'purchase'
	RETURN @totalCompras
END;

-- Función para el total de depósitos en un mes y cliente
CREATE OR ALTER FUNCTION dbo.GetTotalDepositos (@customerID INT, @mes INT) 
RETURNS INT 
AS 
BEGIN
	DECLARE @totalDepositos INT 
	SELECT 
		@totalDepositos = ISNULL(SUM(txn_amount),0) 
	FROM case03.customer_transactions 
	WHERE customer_id = @customerID 
		AND MONTH(txn_date) = @mes 
		AND txn_type = 'deposit'
	RETURN @totalDepositos
END;

-- Función para el total de retiradas en un mes y cliente
CREATE OR ALTER FUNCTION dbo.GetTotalRetiradas (@customerID INT, @mes INT) 
RETURNS INT 
AS 
BEGIN
	DECLARE @totalRetiradas INT 
	SELECT 
		@totalRetiradas = ISNULL(SUM(txn_amount),0) 
	FROM case03.customer_transactions 
	WHERE customer_id = @customerID 
		AND MONTH(txn_date) = @mes 
		AND txn_type = 'withdrawal'
	RETURN @totalRetiradas
END;

-- Función para el balance en un mes y cliente
CREATE OR ALTER FUNCTION dbo.GetBalance(@customerID INT, @mes INT) 
RETURNS INT 
AS 
BEGIN
	DECLARE @balance INT
	SELECT 
		@balance = ISNULL(SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount END),0)
		- ISNULL(SUM(CASE WHEN txn_type = 'purchase' THEN txn_amount END),0)
		- ISNULL(SUM(CASE WHEN txn_type = 'withdrawal' THEN txn_amount END),0)
	FROM case03.customer_transactions 
	WHERE customer_id = @customerID 
		AND MONTH(txn_date) = @mes 
	RETURN @balance
END;

/* CREACIÓN DEL PROCEDURE */
CREATE OR ALTER PROCEDURE TotalMovimientosporMes
    @customerID INT
    ,@mes INT
	,@movimiento INT
AS
BEGIN
	DECLARE @OutputMensaje VARCHAR(100)
	DECLARE @tipoCalculo VARCHAR(20)
	DECLARE @tipoError INT
	DECLARE @minUsuario INT
	DECLARE @maxUsuario INT
	DECLARE @mesTexto VARCHAR(10)

	/* Hacemos la comprobación de errores y asignamos una variable entera el mismo
	Error 1 = Cuando no existe el usuario en la tabla que estamos buscando
	Error 2 = Cuando no existe el tipo de cálculo en la tabla que estamos buscando
	Error 3 = Cuando el mes introducide no es válido */
	SET @tipoError = CASE
		WHEN NOT EXISTS (
			SELECT *
			FROM case03.customer_transactions
			WHERE customer_id = @customerID
		)
			THEN 1
		WHEN @movimiento NOT IN (1,2,3,4)
			THEN 2
		WHEN @mes < 1 OR @mes > 12
			THEN 3
		END

	IF @tipoError = 1 --Si no existe el usuario mostramos un mensaje de error
		BEGIN
			SELECT 
				@minUsuario = MIN(customer_id)
				,@maxUsuario = MAX(customer_id)
			FROM case03.customer_transactions

			SET @OutputMensaje = 'No existe el usuario con el id ' + CAST(@customerID AS VARCHAR(5)) + '. Por favor, escoja un valor entre ' + CAST(@minUsuario AS VARCHAR(5)) + ' y ' + CAST(@maxUsuario AS VARCHAR(5))
		END
	ELSE IF @tipoError = 2 -- Si no existe el tipo de cálculo mostramos un mensaje de error
			SET @OutputMensaje = 'No existe el tipo de cálculo elegido. Por favor, introduzca un número válido (entre 1 y 4).'
	ELSE IF @tipoError = 3 -- Si el mes indicado no está en el rango adecuado
			SET @OutputMensaje = 'No existe el mes elegido. Por favor, introduzca un número válido (entre 1 y 12).'
	ELSE --Si no hay ningún error generamos el mensaje resultante con el tipo de acción elegida
		BEGIN 
			SET @mesTexto = DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), @mes, 1))
			SET @outputMensaje = CASE
				WHEN @movimiento = 1
					THEN 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' tiene un balance de ' + CAST(dbo.GetBalance(@customerID, @mes) AS VARCHAR(10)) + '€  en el mes de ' + @mesTexto
				WHEN @movimiento = 2
					THEN 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' se ha gastado un total de ' + CAST(dbo.GetTotalDepositos(@customerID, @mes) AS VARCHAR(10)) + '€  en compras de productos en el mes de ' + @mesTexto
				WHEN @movimiento = 3
					THEN 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' ha depositado un total de ' + CAST(dbo.GetTotalCompras(@customerID, @mes) AS VARCHAR(10)) + '€ en el mes de ' + @mesTexto
				ELSE 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' ha retirado un total de ' + CAST(dbo.GetTotalRetiradas(@customerID, @mes) AS VARCHAR(10)) + '€  en el mes de ' + @mesTexto
		END
	END
	SELECT @OutputMensaje AS Mensaje
END;

/* PRUEBAS DE EJECUCIONES 
MOVIMIENTOS: 1 = Balance - 2 = Depósitos - 3 = Compras - 4 = Retiradas */
EXEC TotalMovimientosporMes @customerID = 1, @mes = 3, @movimiento = 1;
EXEC TotalMovimientosporMes @customerID = 1, @mes = 3,  @movimiento = 2; --movimiento 3
EXEC TotalMovimientosporMes @customerID = 1, @mes = 3,  @movimiento = 3; --movimiento 2 --tiene un importe de 
EXEC TotalMovimientosporMes @customerID = 1, @mes = 3,  @movimiento = 4;
EXEC TotalMovimientosporMes @customerID = 999, @mes = 3,  @movimiento = 1;
EXEC TotalMovimientosporMes @customerID = 123, @mes = 78,  @movimiento = 1;
EXEC TotalMovimientosporMes @customerID = 123, @mes = 3,  @movimiento = 5;

/* ELIMINACIÓN DEL PROCEDIMIENTO */
DROP PROCEDURE IF EXISTS TotalMovimientosporMes;

/* ELIMINACIÓN DE LAS FUNCIONES */
DROP FUNCTION GetTotalCompras;
DROP FUNCTION GetTotalDepositos;
DROP FUNCTION GetTotalRetiradas;
DROP FUNCTION GetBalance;
