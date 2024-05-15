--CASO 3: Ejercicio 4
--Creamos el Stored Procedure
CREATE PROCEDURE SPGetCustomerTransactions
    @customer_id INT, 
    @month INT, --Valores entre 1-12
    @calculation_type VARCHAR(5) --Valores: 'B' = Balance / 'R' = Retiros / 'C' = Compras / 'D' = Depósitos
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

    DECLARE @result INT;

    -- Calculamos el valor según el tipo de cálculo seleccionado
    IF @calculation_type = 'B'
    BEGIN
        SELECT @result = ISNULL(
	    			SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount
                                         WHEN txn_type = 'purchase' THEN -txn_amount
                                         WHEN txn_type = 'withdrawal' THEN -txn_amount
                                      END), 0)
        FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
        WHERE customer_id = @customer_id
        AND MONTH(txn_date) = @month;
    END
    ELSE IF @calculation_type = 'D'
    BEGIN
        SELECT @result = ISNULL(SUM(txn_amount), 0)
        FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
        WHERE customer_id = @customer_id
        AND txn_type = 'deposit'
        AND MONTH(txn_date) = @month;
    END
    ELSE IF @calculation_type = 'C'
    BEGIN
        SELECT @result = ISNULL(SUM(txn_amount), 0)
        FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
        WHERE customer_id = @customer_id
        AND txn_type = 'purchase'
        AND MONTH(txn_date) = @month;
    END
    ELSE IF @calculation_type = 'R'
    BEGIN
        SELECT @result = ISNULL(SUM(txn_amount), 0)
        FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
        WHERE customer_id = @customer_id
        AND txn_type = 'withdrawal'
        AND MONTH(txn_date) = @month;
    END
    ELSE
    BEGIN
        PRINT 'El tipo de cálculo ingresado no es válido.'; -- Imprime un mensaje de error si el tipo de cálculo no es válido
        RETURN; -- Sale del procedimiento
    END

    -- Generamos el mensaje de salida
    DECLARE @message VARCHAR(MAX);
    DECLARE @calculation_name VARCHAR(50);

    IF @calculation_type = 'B'
        SET @calculation_name = 'Balance';
    ELSE IF @calculation_type = 'D'
        SET @calculation_name = 'Total depositado';
    ELSE IF @calculation_type = 'C'
        SET @calculation_name = 'Total de compras';
    ELSE IF @calculation_type = 'R'
        SET @calculation_name = 'Total de retiros';

    SET @message = 'El resultado para el cliente ' + CAST(@customer_id AS VARCHAR(10)) +
                   ' en el mes de ' + DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), @month, 1)) +
                   ' según el tipo de cálculo "' + @calculation_name + '" es: ' + CAST(@result AS VARCHAR(20)) + '.';

    -- Imprimimos el mensaje
    PRINT @message;
END

--Test:

EXEC SPGetCustomerTransactions @customer_id = 429, @month = 3, @calculation_type = 'B';
EXEC SPGetCustomerTransactions @customer_id = 4, @month = 12, @calculation_type = 'Total depositado';
EXEC SPGetCustomerTransactions @customer_id = 4, @month = 1, @calculation_type = 'D';
EXEC SPGetCustomerTransactions @customer_id = 1, @month = '03', @calculation_type = 'B';
EXEC SPGetCustomerTransactions @customer_id = 1000, @month = 3, @calculation_type = 'B';
EXEC SPGetCustomerTransactions @customer_id = 1, @month = 12, @calculation_type = 'B';
EXEC SPGetCustomerTransactions @customer_id = 1, @month = 13, @calculation_type = 'B';

--Drop:

DROP PROCEDURE SPGetCustomerTransactions
