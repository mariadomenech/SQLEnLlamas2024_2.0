-- Función para el Balance
CREATE OR ALTER FUNCTION dbo.fn_CalculateBalance(
    @customer_id INT,
    @year INT,
    @month_name VARCHAR(10)
)
RETURNS DECIMAL(20, 2)
AS
BEGIN
    DECLARE @balance DECIMAL(20, 2);
    
    SELECT @balance = ISNULL(SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE 0 END), 0)
                      - ISNULL(SUM(CASE WHEN txn_type = 'purchase' THEN txn_amount ELSE 0 END), 0)
                      - ISNULL(SUM(CASE WHEN txn_type = 'withdrawal' THEN txn_amount ELSE 0 END), 0)
    FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
    WHERE customer_id = @customer_id
        AND YEAR(txn_date) = @year
        AND LOWER(DATENAME(month, txn_date)) = LOWER(@month_name);

    RETURN @balance;
END;

-- Función para el Total Depositado
CREATE OR ALTER FUNCTION dbo.fn_CalculateTotalDepositado(
    @customer_id INT,
    @year INT,
    @month_name VARCHAR(10)
)
RETURNS DECIMAL(20, 2)
AS
BEGIN
    DECLARE @totalDepositado DECIMAL(20, 2);

    SELECT @totalDepositado = ISNULL(SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE 0 END), 0)
    FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
    WHERE customer_id = @customer_id
        AND YEAR(txn_date) = @year
        AND LOWER(DATENAME(month, txn_date)) = LOWER(@month_name);

    RETURN @totalDepositado;
END;

-- Función para el Total de Compras
CREATE OR ALTER FUNCTION dbo.fn_CalculateTotalCompras(
    @customer_id INT,
    @year INT,
    @month_name VARCHAR(10)
)
RETURNS DECIMAL(20, 2)
AS
BEGIN
    DECLARE @totalCompras DECIMAL(20, 2);

    SELECT @totalCompras = ISNULL(SUM(CASE WHEN txn_type = 'purchase' THEN txn_amount ELSE 0 END), 0)
    FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
    WHERE customer_id = @customer_id
        AND YEAR(txn_date) = @year
        AND LOWER(DATENAME(month, txn_date)) = LOWER(@month_name);

    RETURN @totalCompras;
END;

-- Función para el Total de Retiros
CREATE OR ALTER FUNCTION dbo.fn_CalculateTotalRetiros(
    @customer_id INT,
    @year INT,
    @month_name VARCHAR(10)
)
RETURNS DECIMAL(20, 2)
AS
BEGIN
    DECLARE @totalRetiros DECIMAL(20, 2);

    SELECT @totalRetiros = ISNULL(SUM(CASE WHEN txn_type = 'withdrawal' THEN txn_amount ELSE 0 END), 0)
    FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
    WHERE customer_id = @customer_id
        AND YEAR(txn_date) = @year
        AND LOWER(DATENAME(month, txn_date)) = LOWER(@month_name);

    RETURN @totalRetiros;
END;
-- Modificación del Procedimiento Almacenado
CREATE OR ALTER PROCEDURE case02.PNG_Ejercicio3_5_Procedimiento
    @customer_id INT,
    @year INT,
    @month_name VARCHAR(10),
    @calculation_type VARCHAR(20) -- Nuevo parámetro para elegir el tipo de cálculo: 'Balance', 'TotalDepositado', 'TotalCompras', 'TotalRetiros'
AS
BEGIN
    -- Variables para almacenar los resultados
    DECLARE @result DECIMAL(20, 2);

    -- Lógica para calcular el resultado según el tipo seleccionado
    IF @calculation_type = 'Balance'
    BEGIN
        -- Llamamos a la función para calcular el balance
        SELECT @result = dbo.fn_CalculateBalance(@customer_id, @year, @month_name);
    END
    ELSE IF @calculation_type = 'TotalDepositado'
    BEGIN
        -- Llamamos a la función para calcular el total depositado
        SELECT @result = dbo.fn_CalculateTotalDepositado(@customer_id, @year, @month_name);
    END
    ELSE IF @calculation_type = 'TotalCompras'
    BEGIN
        -- Llamamos a la función para calcular el total de compras
        SELECT @result = dbo.fn_CalculateTotalCompras(@customer_id, @year, @month_name);
    END
    ELSE IF @calculation_type = 'TotalRetiros'
    BEGIN
        -- Llamamos a la función para calcular el total de retiros
        SELECT @result = dbo.fn_CalculateTotalRetiros(@customer_id, @year, @month_name);
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
EXECUTE case02.PNG_Ejercicio3_5_Procedimiento 
    @customer_id = @customer_id, 
    @year = @year, 
    @month_name = @month_name, 
    @calculation_type = @calculation_type;


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Todo perfecto!

RESULTADO: Correcto
CÓDIGO: Correcto.
LEGIBILIDAD: Correcto.

*/
