/* Alumno: Sergio Díaz */
/* CASO 3 - Ejercicio 1: Media de días de reasignación de nodos a clientes */


WITH CTE_NODO_ANTERIOR -- CTE para añadir el nodo_anterior
AS (
	SELECT nodos_1.customer_id
		,nodos_1.node_id
		,nodos_1.start_date
		,nodos_1.end_date
		,LAG(node_id, 1, 0) OVER (
			PARTITION BY customer_id ORDER BY start_date
			) AS prev_node
	FROM case03.customer_nodes nodos_1
	)
	,CTE_FECHA_CAMBIO -- CTE para obtener la fecha fin de cambio
AS (
	SELECT customer_id
		,node_id
		,start_date
		,DATEADD(DAY, - 1, LEAD(start_date) OVER (
				PARTITION BY customer_id ORDER BY start_date
				)) AS end_date
	FROM CTE_NODO_ANTERIOR
	WHERE node_id <> prev_node
	)
SELECT MEDIA_DIAS_CAMBIO_NODO
	,CONCAT (
		'Cada nodo cambia de media cada '
		,MEDIA_DIAS_CAMBIO_NODO
		,' días'
		) AS MENSAJE
FROM (
	SELECT ROUND(AVG(CAST(DATEDIFF(DAY, start_date, end_date) AS FLOAT)), 2) AS MEDIA_DIAS_CAMBIO_NODO
	FROM CTE_FECHA_CAMBIO
	WHERE end_date IS NOT NULL
	) PRINCIPAL
