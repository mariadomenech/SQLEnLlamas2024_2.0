CREATE OR ALTER PROCEDURE RETO_3 
    @customer_id INT, 
    @month INT
AS
BEGIN
    -- Declaro variables
    DECLARE 
        @customer_exists int,
        @month_valid int,
        @msg nvarchar(256);

    -- Verifico si el cliente existe
    SELECT 
        @customer_exists = CASE WHEN EXISTS (
            SELECT 1 
            FROM case03.customer_transactions 
            WHERE customer_id = @customer_id
        ) THEN 1 ELSE 0 END;

    -- Verifico si el mes es válido
    SET @month_valid = CASE WHEN @month BETWEEN 1 AND 12 THEN 1 ELSE 0 END;

    -- Construyo el mensaje de salida basado en las verificaciones
    IF @month_valid = 1 
    BEGIN
        IF @customer_exists = 1 
        BEGIN
            -- Obtengo el nombre del mes y el total gastado por el cliente en ese mes
            DECLARE @total_gasto DECIMAL(18, 2) = (
                SELECT COALESCE(SUM(txn_amount), 0)
                FROM case03.customer_transactions
                WHERE txn_type = 'purchase' 
                  AND customer_id = @customer_id 
                  AND MONTH(txn_date) = @month
            );

            DECLARE @nombre_mes NVARCHAR(50) = DATENAME(MONTH, DATEFROMPARTS(YEAR(GETDATE()), @month, 1));

            SET @msg = CONCAT('El cliente ', @customer_id, ' se ha gastado un total de ', @total_gasto, ' EUR en compras de productos en el mes de ', @nombre_mes);
        END
        ELSE
        BEGIN
            SET @msg = 'El cliente no existe';
        END
    END
    ELSE
    BEGIN
        SET @msg = 'El mes no existe';
    END

    -- Devuelvo el mensaje de salida
    SELECT @msg AS msg;
END;

--Compruebo:
EXEC Reto_3 2, 8; 
EXEC Reto_3 506, 13; 
EXEC Reto_3 7, 11; 


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

RESULTADO: Correcto
CÓDIGO: Correcto.
LEGIBILIDAD: Correcto.

Me ha gustado mucho el tratamiento de validación de los parámetros!

*/
