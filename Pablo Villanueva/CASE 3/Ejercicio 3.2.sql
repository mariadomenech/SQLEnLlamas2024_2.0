-- Tabla temporal para contabilizar las transacciones agrupadas por tipo
WITH temp_transactions as(
SELECT customer_id
    ,YEAR(txn_date) AS anyo
    ,FORMAT(txn_date, 'MMM', 'ES') AS mes
    ,CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END AS deposit
    ,CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END AS purchase
    ,CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END AS withdrawal

FROM case03.customer_transactions
)
-- Consulta final
SELECT anyo
    ,mes
    ,COUNT(customer_id) AS clientes
FROM (
    SELECT customer_id
        ,anyo
        ,mes
        ,SUM(deposit) AS total_deposit
        ,SUM(purchase) AS total_purchase
        ,SUM(withdrawal) AS total_withdrawal
    FROM temp_transactions
    GROUP BY customer_id, anyo, mes
) AS grouped_transactions
WHERE (total_deposit > 1 AND total_purchase > 1) OR total_withdrawal > 1
GROUP BY anyo, mes
ORDER BY clientes ASC;


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Todo perfecto!

RESULTADO: Correcto
CÓDIGO: Correcto.
LEGIBILIDAD: Correcto.

*/
