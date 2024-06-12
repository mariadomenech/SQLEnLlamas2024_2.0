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


/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*
RESULTADO: Correcto. 
CÓDIGO: Correcto. No hubiese hecho falta poner la primera cte, podrías haberlo hecho todo en la segunda, pero si es porque querías hacerlo por pasos para tenerlo todo más claro, también vale jeje.
Ejemplo de cómo hacerlo todo en una cte:
	WITH selected_txn
	AS (
		SELECT customer_id
			,YEAR(txn_date) AS txn_year
			,FORMAT(txn_date, 'MMM', 'ES') AS txn_month
			,SUM(CASE
				WHEN txn_type = 'deposit' THEN 1
				ELSE 0
			END) deposit_qty
			,SUM(CASE
				WHEN txn_type = 'purchase' THEN 1
				ELSE 0
			END) purchase_qty
			,SUM(CASE
				WHEN txn_type = 'withdrawal' THEN 1
				ELSE 0
			END) withdrawal_qty
		FROM case03.customer_transactions
		GROUP BY customer_id
		,YEAR(txn_date)
		,FORMAT(txn_date, 'MMM', 'ES')
	)
	SELECT 
		txn_year,
		txn_month,
		COUNT (customer_id) AS client_number
	FROM selected_txn st
	WHERE (st.deposit_qty > 1 AND st.purchase_qty>1) OR st.withdrawal_qty > 1
	GROUP BY txn_year, txn_month;

LEGIBILIDAD: Correcto.

Genial Miguel!!!

*/
