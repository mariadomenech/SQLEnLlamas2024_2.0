--Definimos los parámetros de entrada--
DECLARE @check_customer_id INT, @check_year INT, @check_month_name VARCHAR(10);
SET @check_customer_id = 1;
SET @check_year = 2020;
SET @check_month_name = 'marzo';
--Realizamos una consulta para obtener el resultado deseado--
SELECT 
    CASE 
        WHEN total_purchase IS NULL THEN
            CASE 
                WHEN customer_count = 0 THEN
                    'EL CLIENTE ' + CAST(@check_customer_id AS VARCHAR(10)) +
                    ' NO HA REALIZADO NINGUNA COMPRA. PRUEBE CON OTRO IDENTIFICADOR.'
                ELSE
                    CASE 
                        WHEN year_count = 0 THEN
                            'EL CLIENTE ' + CAST(@check_customer_id AS VARCHAR(10)) + 
                            ' NO HA REALIZADO NINGUNA COMPRA EN EL AÑO ' +
                            CAST(@check_year AS VARCHAR(4)) + '. PRUEBE CON ALGUNO DE ESTOS AÑOS: ' +
                            all_years
                        ELSE
                            CASE 
                                WHEN month_count = 0 THEN
                                    'EL CLIENTE ' + CAST(@check_customer_id AS VARCHAR(10)) +
                                    ' NO HA REALIZADO NINGUNA COMPRA EN EL MES DE ' +
                                    UPPER(@check_month_name) + ' DEL AÑO ' + CAST(@check_year AS VARCHAR(4)) +
                                    '. PRUEBE CON ALGUNO DE ESTOS MESES: ' + all_month_names
                                ELSE
                                    'EL CLIENTE ' + CAST(@check_customer_id AS VARCHAR(10)) + 
                                    ' SE HA GASTADO UN TOTAL DE ' +
                                    CAST(total_purchase AS VARCHAR(23)) + ' EUR EN COMPRAS DE PRODUCTOS EN EL MES DE ' +
                                    UPPER(@check_month_name) + ' DEL AÑO ' + CAST(@check_year AS VARCHAR(4))
                            END
                    END
            END
    --Si el total de compras no es NULL, mostramos el total de compras para el cliente en el mes y año especificado--
    ELSE
            'EL CLIENTE ' + CAST(@check_customer_id AS VARCHAR(10)) + 
            ' SE HA GASTADO UN TOTAL DE ' +
            CAST(total_purchase AS VARCHAR(23)) + ' EUR EN COMPRAS DE PRODUCTOS EN EL MES DE ' +
            UPPER(@check_month_name) + ' DEL AÑO ' + CAST(@check_year AS VARCHAR(4))
    END AS result_message
FROM (
  --Subconsulta para calcular los totales y contar los registros para el cliente, año y mes especificado--
    SELECT 
        SUM(CASE WHEN txn_type LIKE 'purchase' THEN txn_amount ELSE 0 END) AS total_purchase,
        COUNT(customer_id) AS customer_count,
        SUM(CASE WHEN YEAR(txn_date) = @check_year THEN 1 ELSE 0 END) AS year_count,
        STUFF((
            SELECT DISTINCT ', ' + CONVERT(VARCHAR(4), YEAR(txn_date))
            FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
            WHERE customer_id = @check_customer_id
            FOR XML PATH('')), 1, 2, '') AS all_years,
        SUM(CASE WHEN LOWER(DATENAME(month, txn_date)) LIKE LOWER(@check_month_name) THEN 1 ELSE 0 END) AS month_count,
  --Concatenamos los registos para el mes especificado con la función STUFF--
        STUFF((
            SELECT DISTINCT ', ' + DATENAME(month, txn_date)
            FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
            WHERE customer_id = @check_customer_id
                AND YEAR(txn_date) = @check_year
            FOR XML PATH('')), 1, 2, '') AS all_month_names
    FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
    WHERE customer_id = @check_customer_id
) AS subquery_result;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto, aunque se podía hacerlo en un procedimiento almacenado. 

*/
