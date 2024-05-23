--Creamos el Procedimiento--
CREATE OR ALTER PROCEDURE Ejercicio_4_1_CRM
    @NOMBRE_BD VARCHAR(20),
    @NOMBRE_ESQUEMA VARCHAR(10),
    @NOMBRE_TABLA VARCHAR(20)
AS
BEGIN
    DECLARE @RESULTADO VARCHAR(100)
    DECLARE @NUM_REP INT

    IF @NOMBRE_BD <> 'SQL_EN_LLAMAS'
    BEGIN
        SET @RESULTADO = 'Inserte una BD correcta (SQL_EN_LLAMAS)'
    END
    ELSE IF @NOMBRE_ESQUEMA <> 'case04'
    BEGIN
        SET @RESULTADO = 'Inserte un esquema correcto (case04)'
    END
    ELSE
    BEGIN
        -- Calcular duplicados según la tabla especificada
        IF @NOMBRE_TABLA = 'product_details'
        BEGIN
            SELECT @NUM_REP = COUNT(*)
            FROM (
                SELECT PRODUCT_ID
                FROM case04.product_details
                GROUP BY PRODUCT_ID
                HAVING COUNT(*) > 1
            ) AS REPETIDOS
        END
        ELSE IF @NOMBRE_TABLA = 'product_hierarchy'
        BEGIN
            SELECT @NUM_REP = COUNT(*)
            FROM (
                SELECT ID
                FROM case04.product_hierarchy
                GROUP BY ID
                HAVING COUNT(*) > 1
            ) AS REPETIDOS
        END
        ELSE IF @NOMBRE_TABLA = 'product_prices'
        BEGIN
            SELECT @NUM_REP = COUNT(*)
            FROM (
                SELECT ID
                FROM case04.product_prices
                GROUP BY ID
                HAVING COUNT(*) > 1
            ) AS REPETIDOS
        END
        ELSE IF @NOMBRE_TABLA = 'sales'
        BEGIN
            SELECT @NUM_REP = COUNT(*)
            FROM (
                SELECT PROD_ID, TXN_ID
                FROM case04.sales
                GROUP BY PROD_ID, TXN_ID
                HAVING COUNT(*) > 1
            ) AS REPETIDOS
        END
        ELSE
        BEGIN
            SET @RESULTADO = 'La tabla introducida no existe'
        END

        -- Si @NUM_REP tiene un valor, entonces la tabla era válida
        IF @NUM_REP IS NOT NULL
        BEGIN
            SET @RESULTADO = 'La tabla ' + @NOMBRE_TABLA + ' tiene un total de ' + CAST(@NUM_REP AS VARCHAR(10)) + ' registros duplicados.'
        END
    END

    SELECT @RESULTADO AS RESULTADO
END;


--Ejecutamos el Procedimiento Almacenado--
DECLARE @BD VARCHAR(20) = 'SQL_EN_LLAMAS'
DECLARE @ESQUEMA VARCHAR(10) = 'case04'
DECLARE @TABLA VARCHAR(20) = 'product_details'

EXEC Ejercicio_4_1_CRM 'SQL_EN_LLAMAS', 'case04', 'product_details';
EXEC Ejercicio_4_1_CRM 'SQL_EN_LLAMAS', 'case04', 'sales';
EXEC Ejercicio_4_1_CRM 'SQL_CARLOS_TOP1', 'case04', 'sales';
EXEC Ejercicio_4_1_CRM 'SQL_EN_LLAMAS', 'case04', 'product_prices';

