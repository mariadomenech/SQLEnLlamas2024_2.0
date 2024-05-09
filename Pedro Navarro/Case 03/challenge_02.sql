-- RETO 2. PARA CADA MES, ¿CUÁNTOS CLIENTES REALIZAN MÁS DE 1 DEPÓSITO Y 1 COMPRA, Ó 1 RETIRO EN UN SOLO MES?
;WITH
	CUSTOMER_TRANSACTIONS_PIVOT_COUNT_TXN_TYPE AS (
		SELECT
			customer_id
			,YEAR(txn_date) AS txn_year
			,DATENAME(month, txn_date) AS txn_month
			,SUM(CASE
				WHEN txn_type LIKE 'deposit' THEN 1
				ELSE 0
			END) AS deposit_count
			,SUM(CASE
				WHEN txn_type LIKE 'purchase' THEN 1
				ELSE 0
			END) AS purchase_count
			,SUM(CASE
				WHEN txn_type LIKE 'withdrawal' THEN 1
				ELSE 0
			END) AS withdrawal_count
		FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
		GROUP BY
			customer_id
			,YEAR(txn_date)
			,DATENAME(month, txn_date)
	)

	,FINAL AS (
		SELECT
			txn_year
			,txn_month
			,COUNT(customer_id) AS customer_count
		FROM CUSTOMER_TRANSACTIONS_PIVOT_COUNT_TXN_TYPE
		WHERE
			(deposit_count > 1 AND purchase_count > 1)
			OR withdrawal_count > 1
		GROUP BY
			txn_year
			,txn_month
	)

SELECT *
FROM FINAL;
