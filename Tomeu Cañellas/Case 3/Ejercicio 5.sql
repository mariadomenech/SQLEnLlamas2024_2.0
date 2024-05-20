--CASO 3: Ejercicio 5
--Creamos la función para calcular el balance con la lógica del ejercicio anterior
CREATE FUNCTION dbo.CalculateBalance(
    @customer_id INT,
    @month INT
)
RETURNS INT
AS
BEGIN
    DECLARE @balance INT;

    SELECT @balance = ISNULL(SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount
                                      WHEN txn_type = 'purchase' THEN -txn_amount
                                      WHEN txn_type = 'withdrawal' THEN -txn_amount
                                 END), 0)
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
    WHERE customer_id = @customer_id
    AND MONTH(txn_date) = @month;

    RETURN @balance;
END;

--Creamos la función para calcular el total depositado con la lógica del ejercicio anterior
CREATE FUNCTION dbo.CalculateTotalDeposits(
    @customer_id INT,
    @month INT
)
RETURNS INT
AS
BEGIN
    DECLARE @totalDeposits INT;

    SELECT @totalDeposits = ISNULL(SUM(txn_amount), 0)
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
    WHERE customer_id = @customer_id
    AND txn_type = 'deposit'
    AND MONTH(txn_date) = @month;

    RETURN @totalDeposits;
END;

--Creamos la función para calcular el total comprado con la lógica del ejercicio anterior
CREATE FUNCTION dbo.CalculateTotalPurchases(
    @customer_id INT,
    @month INT
)
RETURNS INT
AS
BEGIN
    DECLARE @totalPurchases INT;

    SELECT @totalPurchases = ISNULL(SUM(txn_amount), 0)
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
    WHERE customer_id = @customer_id
    AND txn_type = 'purchase'
    AND MONTH(txn_date) = @month;

    RETURN @totalPurchases;
END;

--Creamos la función para calcular el total retirado con la lógica del ejercicio anterior
CREATE FUNCTION dbo.CalculateTotalWithdrawals(
    @customer_id INT,
    @month INT
)
RETURNS INT
AS
BEGIN
    DECLARE @totalWithdrawals INT;

    SELECT @totalWithdrawals = ISNULL(SUM(txn_amount), 0)
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
    WHERE customer_id = @customer_id
    AND txn_type = 'withdrawal'
    AND MONTH(txn_date) = @month;

    RETURN @totalWithdrawals;
END;

--Creamos el Stored Procedure sustituyendo la lógica del ejercicio anterior por llamadas a las funciones.
--(Se ha modificado el SP usando RAISEERROR en lugar de MESSAGE)
CREATE PROCEDURE SPGetCustomerTransactions
    @customer_id INT, 
    @month INT, --Valores entre 1-12
    @calculation_type VARCHAR(5) --Valores: 'B' = Balance / 'R' = Retiros / 'C' = Compras / 'D' = Depósitos
AS
BEGIN
    -- Verificamos si el mes ingresado es válido (de 1 a 12)
    IF @month < 1 OR @month > 12
    BEGIN
        RAISERROR('El mes ingresado no es válido.', 16, 1); -- Genera un error si el mes no está en el rango válido
        RETURN; -- Sale del procedimiento
    END;

    -- Verificamos si el cliente existe
    IF NOT EXISTS (SELECT 1 FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions] WHERE customer_id = @customer_id)
    BEGIN
        RAISERROR('El cliente %d no existe.', 16, 1, @customer_id); -- Genera un error si el cliente no existe
        RETURN; -- Sale del procedimiento
    END;

    DECLARE @result INT;

    -- Calculamos el valor según el tipo de cálculo seleccionado
    IF @calculation_type = 'B'
    BEGIN
        SELECT @result = dbo.CalculateBalance(@customer_id, @month);
    END
    ELSE IF @calculation_type = 'D'
    BEGIN
        SELECT @result = dbo.CalculateTotalDeposits(@customer_id, @month);
    END
    ELSE IF @calculation_type = 'C'
    BEGIN
        SELECT @result = dbo.CalculateTotalPurchases(@customer_id, @month);
    END
    ELSE IF @calculation_type = 'R'
    BEGIN
        SELECT @result = dbo.CalculateTotalWithdrawals(@customer_id, @month);
    END
    ELSE
    BEGIN
        RAISERROR('El tipo de cálculo ingresado no es válido.', 16, 1); -- Genera un error si el tipo de cálculo no es válido
        RETURN; -- Sale del procedimiento
    END

    -- Generamos el mensaje de salida
    DECLARE @message VARCHAR(MAX);
    DECLARE @calculation_name VARCHAR(50);

    SELECT @calculation_name = CASE WHEN @calculation_type = 'B' THEN 'Balance'
                                    WHEN @calculation_type = 'D' THEN 'Total depositado'
                                    WHEN @calculation_type = 'C' THEN 'Total de compras'
                                    WHEN @calculation_type = 'R' THEN 'Total de retiros'
                               END;

    SET @message = 'El resultado para el cliente ' + CAST(@customer_id AS VARCHAR(10)) +
                   ' en el mes de ' + DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), @month, 1)) +
                   ' según el tipo de cálculo "' + @calculation_name + '" es: ' + CAST(@result AS VARCHAR(20)) + '.';

    -- Imprimimos el mensaje
    PRINT @message;
END

--Tests:

EXEC SPGetCustomerTransactions @customer_id = 429, @month = 3, @calculation_type = 'B';
EXEC SPGetCustomerTransactions @customer_id = 4, @month = 12, @calculation_type = 'D';
EXEC SPGetCustomerTransactions @customer_id = 4, @month = 1, @calculation_type = 'D';
EXEC SPGetCustomerTransactions @customer_id = 1, @month = 3, @calculation_type = 'B';
EXEC SPGetCustomerTransactions @customer_id = 1000, @month = 3, @calculation_type = 'B';
EXEC SPGetCustomerTransactions @customer_id = 1, @month = 12, @calculation_type = 'B';
EXEC SPGetCustomerTransactions @customer_id = 1, @month = 13, @calculation_type = 'B'; 

--Drop:

DROP PROCEDURE SPGetCustomerTransactions;
DROP FUNCTION dbo.CalculateBalance;
DROP FUNCTION dbo.CalculateTotalDeposits;
DROP FUNCTION dbo.CalculateTotalPurchases;
DROP FUNCTION dbo.CalculateTotalWithdrawals;


/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Perfecto! Controlas casos indeterminados, separas la lógica y tienes en cuenta todas las situaciones. Buen trabajo, enhorabuena! :)

*/
