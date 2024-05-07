-- RETO 1. ¿EN CUÁNTOS DÍAS DE MEDIA SE REASIGNAN LOS CLIENTES A UN NODO DIFERENTE?
;WITH
	CUSTOMER_PREVIOUS_NODES AS (
		SELECT
			customer_id
			,region_id
			,node_id
			,start_date
			,LAG(node_id, 1, 0) OVER (PARTITION BY customer_id ORDER BY customer_id, start_date) AS previous_node_id
		FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_nodes
	)

	,CUSTOMER_PREVIOUS_NODES_NEXT_START_DATE AS (
		SELECT
			customer_id
			,region_id
			,node_id
			,start_date
			,previous_node_id
			,LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY customer_id, start_date) AS next_start_date
	FROM CUSTOMER_PREVIOUS_NODES
	WHERE node_id <> previous_node_id
	)

	,FINAL_RESULT AS (
	SELECT
		ROUND(AVG(
			CAST( DATEDIFF(day, start_date, DATEADD(day, -1, next_start_date)) AS FLOAT)), 2
		) AS average_reassignment_days_between_different_nodes
	FROM CUSTOMER_PREVIOUS_NODES_NEXT_START_DATE
	)

SELECT *
FROM FINAL_RESULT;
