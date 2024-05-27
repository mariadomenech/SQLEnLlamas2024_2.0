-- ¿En cuántos días de media se reasignan los clientes a un nodo diferente?

-- Obtiene en una columna el nodo previo 
WITH CTE_PREV_NODE
AS (
	SELECT customer_id
		,node_id
		,LAG(node_id, 1, 0) OVER (PARTITION BY customer_id ORDER BY start_date ASC) AS prev_node
		,start_date
		,end_date
	FROM case03.customer_nodes
	WHERE end_date != '9999-12-31'
),  

--Calcula la fecha final en la que sale de cada nodo
CTE_END_DATE
AS (
	SELECT customer_id
		,node_id
		,start_date
		,DATEADD(DAY, -1, LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date ASC)) AS end_date
	FROM CTE_PREV_NODE
	WHERE node_id != prev_node
)

--Query final para calcular la media de los días que pasa en cada nodo y mostrar el resultado en el formato adecuado
SELECT avg_day
	,CONCAT('Los clientes se reasignan a un nodo diferente cada ', avg_day, ' días de media.') as texto
FROM (
	SELECT CAST(AVG(CAST(DATEDIFF(DAY, start_date, end_date) AS DECIMAL(5,2)))AS DECIMAL(5,2)) AS avg_day
	FROM CTE_END_DATE
) 
