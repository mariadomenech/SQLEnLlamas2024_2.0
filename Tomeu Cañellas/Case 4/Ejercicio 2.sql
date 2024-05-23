--CASO 4: Ejercicio 2
--Cruzamos la tabla de Sales con Product_details para obtener los descriptivos de los productos
WITH product_names AS (
    SELECT  sales.txn_id,
            sales.prod_id,
            details.product_name
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case04].[sales] sales
    INNER JOIN [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_details] details
        ON sales.prod_id = details.product_id
    GROUP BY sales.txn_id, sales.prod_id, details.product_name
),

--Calculamos el número de productos distintos en cada transacción y filtramos aquellas con 3 productos distintos o más
txn_count AS (
    SELECT  txn_id,
            COUNT(DISTINCT prod_id) AS product_count
    FROM product_names
    GROUP BY txn_id
    HAVING COUNT(DISTINCT prod_id) >= 3
),

--Agregamos por transacción los nombres de los productos
txn_agg AS (
    SELECT  names.txn_id,
            STRING_AGG(names.product_name, ',') WITHIN GROUP (ORDER BY names.product_name) AS prod_combination
    FROM product_names names
    INNER JOIN txn_count txncount 
        ON names.txn_id = txncount.txn_id
    GROUP BY names.txn_id
)

--Presentamos el resultado en formato de mensaje
SELECT  prod_count,
        'La combinación de productos más repetida es: ' + prod_combination AS resultado
FROM (
    SELECT TOP 1 prod_combination,
                 COUNT(*) AS prod_count
    FROM txn_agg
    GROUP BY prod_combination
    ORDER BY prod_count DESC
) top1
;

