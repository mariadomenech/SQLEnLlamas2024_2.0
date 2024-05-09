--CASO 3: Ejercicio 2
--Creamos una primera tabla temporal, obteniendo el mes/año y la cuenta de cada registro, agrupando por cliente/mes/año y tipo de transacción
WITH txn_per_month AS (
    SELECT  customer_id, 
            MONTH(txn_date) AS month,
            YEAR(txn_date) AS year,
            txn_type,
            COUNT(*) AS txn_count
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_transactions]
    GROUP BY customer_id, 
             MONTH(txn_date),
             YEAR(txn_date),
             txn_type
),

--En esta tabla temporal obtenemos la suma del conteo anterior dependiendo del tipo de transaccion agrupada por cliente/mes/año
txn_per_type AS (
    SELECT  customer_id,
            month,
            year,
            SUM(CASE WHEN txn_type = 'withdrawal' THEN txn_count 
                     ELSE 0 END) AS withdrawals,
            SUM(CASE WHEN txn_type = 'purchase' THEN txn_count 
                     ELSE 0 END) AS purchases,
	    SUM(CASE WHEN txn_type = 'deposit' THEN txn_count 
                     ELSE 0 END) AS deposits
    FROM txn_per_month
    GROUP BY customer_id,
             month,
             year
)

--Obtenemos el número de clientes que cumplen las condiciones del enunciado en la clausula WHERE y agrupamos por mes/año
SELECT  year,
        month,
        COUNT(*) AS client_count
FROM txn_per_type
WHERE (deposits > 1 AND purchases > 1) OR (withdrawals > 1)
GROUP BY year,
         month
;
