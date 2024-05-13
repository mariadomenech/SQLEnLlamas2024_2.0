CREATE OR ALTER PROCEDURE TotalComprasClienteMes
    @customerID INT
    ,@mes INT
AS
BEGIN
    DECLARE @totalCompras INT
	DECLARE @OutputMensaje VARCHAR(100)
	IF EXISTS --Comprobamos que el cliente que buscamos existe en la base de datos
		(SELECT
			customer_id
		FROM case03.customer_transactions
		WHERE customer_id = @customerID)
		BEGIN --Si existe realizamos la suma de las compras del mismo para el mes indicado
			SELECT 
				@totalCompras = ISNULL(SUM(txn_amount),0) 
			FROM case03.customer_transactions
			WHERE customer_id = @customerID
				AND MONTH(txn_date) = @mes
				AND txn_type = 'purchase'
			SET @OutputMensaje = 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' se ha gastado un total de ' + CAST(@totalCompras AS VARCHAR(10)) + '€ en el mes de ' + DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), @mes, 1))
			SELECT @OutputMensaje AS Mensaje --Mostramos el mensaje arriba indicado
		END
	ELSE --Si el cliente no existe mostramos un mensaje indicándolo
		BEGIN
			SET @OutputMensaje = 'No existe el usuario con el id ' + CAST(@customerID AS VARCHAR(5))
			SELECT @OutputMensaje AS Mensaje
			-- También tendríamos la opción de mostrarlo por pantalla al compilar con la opción PRINT @OutputMensaje
		END
END;

EXEC TotalComprasClienteMes @customerID = 123, @mes = 3;
EXCE TotalComprasClientesMes @customerID = 999, @mes = 3;
