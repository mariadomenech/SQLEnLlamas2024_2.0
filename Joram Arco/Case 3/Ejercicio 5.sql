/* CREACIÓN DE FUNCIONES */
-- Función para el cálculo general de cualquier tipo de movimiento, ya que se le pasan los 3 parámetros como al procedimiento
CREATE OR ALTER FUNCTION dbo.GetTotalImporte(@customerID INT, @mes INT, @movimiento INT) 
RETURNS VARCHAR (100)
AS 
BEGIN
	DECLARE
		@totalDepositos INT
		,@totalCompras INT
		,@totalRetiradas INT
		,@balance INT
		,@mesTexto VARCHAR(10)

	SELECT 
		 @totalCompras = ISNULL(SUM(CASE WHEN txn_type = 'purchase' THEN txn_amount END),0)
		,@totalDepositos = ISNULL(SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount END),0)
		,@totalRetiradas = ISNULL(SUM(CASE WHEN txn_type = 'withdrawal' THEN txn_amount END),0)
	FROM case03.customer_transactions 
	WHERE customer_id = @customerID 
		AND MONTH(txn_date) = @mes 
	
	SET @balance = @totalDepositos - @totalCompras - @totalRetiradas
	SET @mesTexto = DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), @mes, 1)) 
	
	RETURN CASE
				WHEN @movimiento = 1
					THEN 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' tiene un balance de ' + CAST(@balance AS VARCHAR(10)) + '€  en el mes de ' + @mesTexto
				WHEN @movimiento = 2
					THEN 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' ha depositado un total de ' + CAST(@totalDepositos AS VARCHAR(10)) + '€  en compras de productos en el mes de ' + @mesTexto
				WHEN @movimiento = 3
					THEN 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' se ha gastado un total de ' + CAST(@totalCompras AS VARCHAR(10)) + '€ en el mes de ' + @mesTexto
				ELSE 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' ha retirado un total de ' + CAST(@totalRetiradas AS VARCHAR(10)) + '€  en el mes de ' + @mesTexto
		END
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

	SELECT 
		@minUsuario = MIN(customer_id)
		,@maxUsuario = MAX(customer_id)
	FROM case03.customer_transactions

	IF @customerID BETWEEN @minUsuario AND @maxUsuario --Comprobar que el usuario elegido esté en la tabla
		IF @mes BETWEEN 1 AND 12 --Comprobar que el mes elegido esté entre Enero y Diciembre
			IF @movimiento IN (1,2,3,4) --Comprobar que el movimiento esté entre 1 y 4
				SET @OutputMensaje = dbo.GetTotalImporte(@customerID, @mes, @movimiento)
			ELSE
				SET @OutputMensaje = 'No existe el tipo de cálculo elegido. Por favor, introduzca un número válido (entre 1 y 4).'
		ELSE
			SET @OutputMensaje = 'No existe el mes elegido. Por favor, introduzca un número válido (entre 1 y 12).'
	ELSE
		SET @OutputMensaje = 'No existe el usuario con el id ' + CAST(@customerID AS VARCHAR(5)) + '. Por favor, escoja un valor entre ' + CAST(@minUsuario AS VARCHAR(5)) + ' y ' + CAST(@maxUsuario AS VARCHAR(5))

	SELECT @OutputMensaje AS Mensaje
END;

/* PRUEBAS DE EJECUCIONES 
MOVIMIENTOS: 1 = Balance - 2 = Depósitos - 3 = Compras - 4 = Retiradas */
EXEC TotalMovimientosporMes @customerID = 1, @mes = 3, @movimiento = 1;
EXEC TotalMovimientosporMes @customerID = 1, @mes = 3,  @movimiento = 2;
EXEC TotalMovimientosporMes @customerID = 1, @mes = 3,  @movimiento = 3; 
EXEC TotalMovimientosporMes @customerID = 1, @mes = 3,  @movimiento = 4;
EXEC TotalMovimientosporMes @customerID = 999, @mes = 3,  @movimiento = 1;
EXEC TotalMovimientosporMes @customerID = 123, @mes = 78,  @movimiento = 1;
EXEC TotalMovimientosporMes @customerID = 123, @mes = 3,  @movimiento = 5;

/* ELIMINACIÓN DEL PROCEDIMIENTO */
DROP PROCEDURE IF EXISTS TotalMovimientosporMes;

/* ELIMINACIÓN DE LAS FUNCIONES */
DROP FUNCTION GetTotalImporte;
