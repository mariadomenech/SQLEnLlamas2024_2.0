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
	BEGIN
		IF @mes < 1 OR @mes > 12 --Comprobamos que el mes introducido está en el rango deseado, si no mostramos un mensaje de error
			SET @OutputMensaje = 'No existe el mes elegido. Por favor, introduzca un número válido (entre 1 y 12).'
		ELSE
			BEGIN
				SELECT 
				@totalCompras = ISNULL(SUM(txn_amount),0) 
				FROM case03.customer_transactions
				WHERE customer_id = @customerID
					AND MONTH(txn_date) = @mes
					AND txn_type = 'purchase'
				SET @OutputMensaje = 'El cliente ' + CAST(@customerID AS VARCHAR(5)) + ' se ha gastado un total de ' + CAST(@totalCompras AS VARCHAR(10)) + '€ en el mes de ' + DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), @mes, 1))
			END
	END	
	ELSE --Si el cliente no existe mostramos un mensaje indicándolo
		SET @OutputMensaje = 'No existe el usuario con el id ' + CAST(@customerID AS VARCHAR(5))

	SELECT @OutputMensaje AS Mensaje
	-- También tendríamos la opción de mostrarlo por pantalla al compilar con la opción PRINT @OutputMensaje
END;

EXEC TotalComprasClienteMes @customerID = 123, @mes = 3;
EXEC TotalComprasClienteMes @customerID = 999, @mes = 3;
EXEC TotalComprasClienteMes @customerID = 123, @mes = 78;


DROP PROCEDURE TotalComprasClienteMes;
