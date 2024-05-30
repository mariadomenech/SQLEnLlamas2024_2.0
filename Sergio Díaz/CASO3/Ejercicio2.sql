/* Alumno: Sergio Díaz */
/* CASO 3 - Ejercicio 2: N clientes que realizan más de 1 depósito y 1 compra/retiro al mes */


WITH CTE_RESUMEN_MES -- CTE para añadir el mes en formato yyyymm y las columnas contando cada tipo de transacción
AS (
	SELECT customer_id
		,CONCAT (
			YEAR(txn_date)
			,FORMAT(MONTH(txn_date), '00')
			) AS ANIO_MES
		,SUM(CASE 
				WHEN TXN_TYPE = 'deposit'
					THEN 1
				ELSE 0
				END) AS depositos
		,SUM(CASE 
				WHEN TXN_TYPE = 'purchase'
					THEN 1
				ELSE 0
				END) AS compras
		,SUM(CASE 
				WHEN TXN_TYPE = 'withdrawal'
					THEN 1
				ELSE 0
				END) AS retiros
	FROM case03.customer_transactions
	GROUP BY customer_id
		,CONCAT (
			YEAR(txn_date)
			,FORMAT(MONTH(txn_date), '00')
			)
	)
	
	
SELECT ANIO_MES -- select principal para obtener la solución
	,COUNT(CUSTOMER_ID) AS N_CLIENTES
FROM CTE_RESUMEN_MES
WHERE ( -- Filtros para cumplir con las condiciones del caso
		DEPOSITOS > 1
		AND COMPRAS > 1
		)
	OR (RETIROS > 1)
GROUP BY ANIO_MES
