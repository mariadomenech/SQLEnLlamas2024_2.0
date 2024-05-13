--CASO 3: Ejercicio 3
--Creamos el Stored Procedure
CREATE PROCEDURE SPTotalPurchases
    @customer_id INT,
    @month INT
AS
BEGIN
    -- Verificamos si el mes ingresado es válido (de 1 a 12)
    IF @month < 1 OR @month > 12
    BEGIN
        PRINT 'El mes ingresado no es válido.'; -- Imprime un mensaje de error si el mes no está en el rango válido
        RETURN; -- Sale del procedimiento
    END;

    DECLARE @customerExists BIT;

    -- Verificamos si el cliente existe
    SELECT @customerExists = CASE WHEN EXISTS (
        SELECT 1 FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions] WHERE customer_id = @customer_id
    ) THEN 1 ELSE 0 END;

    IF @customerExists = 0
    BEGIN
        PRINT 'El cliente ' + CAST(@customer_id AS VARCHAR(10)) + ' no existe.'; -- Imprime un mensaje si el cliente no existe
        RETURN; -- Sale del procedimiento
    END;

    DECLARE @totalPurchases INT;

    -- Calculamos el total de compras para el cliente y mes introducidos
    SELECT @totalPurchases = SUM(txn_amount)
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
    WHERE customer_id = @customer_id
    AND txn_type = 'purchase'
    AND MONTH(txn_date) = @month;

    -- Generamos el mensaje de salida
    DECLARE @message VARCHAR(MAX);

    IF @totalPurchases IS NOT NULL
    BEGIN
        -- Construimos el mensaje si hay compras para ese cliente y mes
        SET @message = 'El cliente ' + CAST(@customer_id AS VARCHAR(10)) +
                       ' se ha gastado un total de ' + CAST(@totalPurchases AS VARCHAR(20)) +
                       ' EUR en compras de productos en el mes de ' + DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), @month, 1)) + '.';
    END
    ELSE
    BEGIN
        -- Construimos el mensaje si no hay compras para ese cliente y mes
        SET @message = 'El cliente ' + CAST(@customer_id AS VARCHAR(10)) +
                       ' no ha realizado compras de productos en el mes de ' + DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), @month, 1)) + '.';
    END

    -- Imprimie el mensaje
    PRINT @message;
END;

--Test:

EXEC SPTotalPurchases @customer_id = 1, @month = 3;
EXEC SPTotalPurchases @customer_id = 1, @month = '03';
EXEC SPTotalPurchases @customer_id = 1000, @month = 3;
EXEC SPTotalPurchases @customer_id = 1, @month = 12;
EXEC SPTotalPurchases @customer_id = 1, @month = 13;

--Drop:

DROP PROCEDURE SPTotalPurchases;
