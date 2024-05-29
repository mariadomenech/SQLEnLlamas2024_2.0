WITH mod_customer_nodes AS (
	SELECT
		cn.customer_id,
		cn.node_id,
		cn.start_date,
		cn.end_date,
		DATEDIFF(day,cn.start_date, cn.end_date) AS days,
		CASE
			WHEN LEAD(cn.node_id, 1) OVER (PARTITION BY cn.customer_id ORDER BY cn.start_date) = cn.node_id THEN 0
			ELSE 1
			END AS node_change
	FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_nodes cn),

dim_customer_nodes AS (
	SELECT
		cn.customer_id,
		--cn.node_id,
		--cn.node_change,
		cn.start_date,
		cn.end_date,
		SUM(cn.node_change) OVER (ORDER BY cn.customer_id, start_date) AS change_id,
		cn.days + (1-cn.node_change) AS total_days -- Cuando no hay cambio de nodo, suma 1 día. Cuando lo hay, suma 0.
	FROM mod_customer_nodes cn),

changed_nodes AS (
	SELECT
		cn.change_id,
		cn.customer_id,
		SUM (cn.total_days) AS days_per_change
	FROM dim_customer_nodes cn
	WHERE YEAR(end_date) <> 9999
	GROUP BY cn.change_id,cn.customer_id)

SELECT
	ROUND(AVG (CAST(cn.days_per_change AS FLOAT)),2) AS media_global
FROM changed_nodes cn;
