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

-- Calcula la fecha final en la que sale de cada nodo
CTE_END_DATE
AS (
	SELECT customer_id
		,node_id
		,start_date
		,DATEADD(DAY, -1, COALESCE(LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date ASC), DATEADD(DAY, 1, end_date))) AS end_date
	FROM CTE_PREV_NODE
	WHERE node_id != prev_node
)

--Query final para calcular la media de los días que pasa en cada nodo y mostrar el resultado en el formato adecuado
SELECT avg_day
	,CONCAT('Los clientes se reasignan a un nodo diferente cada ', avg_day, ' días de media.') as texto
FROM (
	SELECT CAST(AVG(CAST(DATEDIFF(DAY, start_date, end_date) AS DECIMAL(5,2)))AS DECIMAL(5,2)) AS avg_day
	FROM CTE_END_DATE
) A

-- Para calcular la media también estoy teniendo en cuenta el tiempo que pasa para cada cutomers en su último nodo, este resultado es algo menor que si no tuvieramos en cuenta esta fila (resultado web) 
-- no obstante creo que es importante tenerlo en cuenta para que no altere la media de tiempo por nodo. Pego ejemplo:

--Query sin calcular el tiempo que pasa en el último nodo
-- Customers   Node   Start_Date   End_Date     End_Date_Calculated
-- 1	         4  	  2020-01-02	 2020-01-03	  2020-01-14
-- 1	         2	    2020-01-15	 2020-01-16	  2020-01-16
-- 1	         5	    2020-01-17	 2020-01-28	  2020-01-28
-- 1	         3	    2020-01-29	 2020-02-18	  2020-02-18
-- 1	         2	    2020-02-19	 2020-03-16	  NULL

--Query calculando el tiempo que pasa en el último nodo
-- Customers   Node   Start_Date   End_Date     End_Date_Calculated
-- 1	         4  	  2020-01-02	 2020-01-03	  2020-01-14
-- 1	         2	    2020-01-15	 2020-01-16	  2020-01-16
-- 1	         5	    2020-01-17	 2020-01-28	  2020-01-28
-- 1	         3	    2020-01-29	 2020-02-18	  2020-02-18
-- 1	         2	    2020-02-19	 2020-03-16	  2020-03-16
