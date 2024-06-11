CREATE OR ALTER PROCEDURE case02.PNG_Ejercicio3_4_Procedimiento
    @customer_id INT,
    @year INT,
    @month_name VARCHAR(10),
    @calculation_type VARCHAR(20) -- Nuevo parámetro para elegir el tipo de cálculo: 'Balance', 'TotalDepositado', 'TotalCompras', 'TotalRetiros'
AS
BEGIN
    -- Variable para almacenar el resultado
    DECLARE @result DECIMAL(20, 2);

    -- Lógica para calcular el resultado según el tipo seleccionado
    IF @calculation_type = 'Balance'
    BEGIN
        -- Calculamos el balance (Depósito - Compras - Retiros)
        SELECT @result = ISNULL(SUM(CASE WHEN txn_type LIKE 'deposit' THEN txn_amount ELSE 0 END), 0)
                        - ISNULL(SUM(CASE WHEN txn_type LIKE 'purchase' THEN txn_amount ELSE 0 END), 0)
                        - ISNULL(SUM(CASE WHEN txn_type LIKE 'withdrawal' THEN txn_amount ELSE 0 END), 0)
        FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
        WHERE customer_id = @customer_id
            AND YEAR(txn_date) = @year
            AND LOWER(DATENAME(month, txn_date)) = LOWER(@month_name);
    END
    ELSE IF @calculation_type = 'TotalDepositado'
    BEGIN
        -- Calculamos el total depositado
        SELECT @result = ISNULL(SUM(CASE WHEN txn_type LIKE 'deposit' THEN txn_amount ELSE 0 END), 0)
        FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
        WHERE customer_id = @customer_id
            AND YEAR(txn_date) = @year
            AND LOWER(DATENAME(month, txn_date)) = LOWER(@month_name);
    END
    ELSE IF @calculation_type = 'TotalCompras'
    BEGIN
        -- Calculamos el total de compras
        SELECT @result = ISNULL(SUM(CASE WHEN txn_type LIKE 'purchase' THEN txn_amount ELSE 0 END), 0)
        FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
        WHERE customer_id = @customer_id
            AND YEAR(txn_date) = @year
            AND LOWER(DATENAME(month, txn_date)) = LOWER(@month_name);
    END
    ELSE IF @calculation_type = 'TotalRetiros'
    BEGIN
        -- Calculamos el total de retiros
        SELECT @result = ISNULL(SUM(CASE WHEN txn_type LIKE 'withdrawal' THEN txn_amount ELSE 0 END), 0)
        FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
        WHERE customer_id = @customer_id
            AND YEAR(txn_date) = @year
            AND LOWER(DATENAME(month, txn_date)) = LOWER(@month_name);
    END

    -- Mostramos el resultado
    PRINT 'El resultado para el cliente ' + CAST(@customer_id AS VARCHAR(10)) +
          ' en el mes de ' + UPPER(@month_name) + ' del año ' + CAST(@year AS VARCHAR(4)) +
          ' según el tipo de cálculo "' + @calculation_type + '" es: ' + CAST(@result AS VARCHAR(20));
END;

-- Parámetros de entrada
DECLARE @customer_id INT, @year INT, @month_name VARCHAR(10), @calculation_type VARCHAR(20);
SET @customer_id = 1;
SET @year = 2020; 
SET @month_name = 'marzo'; 
SET @calculation_type = 'TotalCompras'; -- Tipo de cálculo ('Balance', 'TotalDepositado', 'TotalCompras', 'TotalRetiros')

-- Ejecución del procedimiento almacenado
EXECUTE case02.PNG_Ejercicio3_4_Procedimiento 
    @customer_id = @customer_id, 
    @year = @year, 
    @month_name = @month_name, 
    @calculation_type = @calculation_type;

-- Resultados:
-- Resultado de Balance: -952.00
-- Resultado de TotalDepositado: 324.00
-- Resultado de TotalCompras: 1276.00
-- Resultado de TotalRetiros: 0.00
