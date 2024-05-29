WITH selected_customers AS (
	SELECT
		ct.customer_id,
		CONVERT(varchar(3),DATENAME(mm,txn_date))+ '.' AS txn_month,
		YEAR (txn_date) AS txn_year,
		txn_type,
		COUNT (txn_type) AS txn_number
	FROM SQL_EN_LLAMAS_ALUMNOS.CASE03.CUSTOMER_TRANSACTIONS ct
	GROUP BY ct.customer_id, ct.txn_date, ct.txn_type
),
selected_txn AS (
	SELECT
		sc.txn_month,
		sc.txn_year,
		sc.customer_id,
		SUM (CASE txn_type
			WHEN 'deposit' THEN sc.txn_number
			ELSE 0
			END) AS deposit_qty,
		SUM (CASE txn_type
			WHEN 'purchase' THEN sc.txn_number
			ELSE 0
			END) AS purchase_qty,
		SUM (CASE txn_type
			WHEN 'withdrawal' THEN sc.txn_number
			ELSE 0
			END) AS withdrawal_qty
	FROM selected_customers sc
	GROUP BY sc.txn_year, sc.txn_month, sc.customer_id
)
SELECT 
	txn_year,
	txn_month,
	COUNT (customer_id) AS client_number
FROM selected_txn st
WHERE (st.deposit_qty > 1 AND st.purchase_qty>1) OR st.withdrawal_qty > 1
GROUP BY txn_year, txn_month;
