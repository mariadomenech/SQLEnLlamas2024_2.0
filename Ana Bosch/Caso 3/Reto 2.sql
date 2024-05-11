-- RETO 2: Para cada mes, ¿Cuántos clientes realizan más de un depósito Y una compra O un retiro en un solo mes?

-- CTE para poder dividir los tipos de acciones que realizan los clientes
WITH CTE_DIVISION
AS (
	SELECT customer_id
		,YEAR(txn_date) AS anyo
		,FORMAT(txn_date, 'MMM', 'ES') AS mes
		,SUM(CASE
			WHEN txn_type = 'deposit' THEN 1
			ELSE 0
		END) deposit
		,SUM(CASE
			WHEN txn_type = 'purchase' THEN 1
			ELSE 0
		END) purchase
		,SUM(CASE
			WHEN txn_type = 'withdrawal' THEN 1
			ELSE 0
		END) withdrawal
	FROM case03.customer_transactions
	GROUP BY customer_id
	,YEAR(txn_date)
	,FORMAT(txn_date, 'MMM', 'ES')

)

-- Query para conocer el calculo final
SELECT anyo
	,mes
	,COUNT(customer_id) AS clientes
FROM CTE_DIVISION
WHERE (deposit > 1 AND purchase > 1) OR withdrawal > 1
GROUP BY anyo
	,mes
ORDER BY 3 ASC

