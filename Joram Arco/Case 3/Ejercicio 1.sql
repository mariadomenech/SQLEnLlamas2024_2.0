/*
En esta parte generamos una tabla temporal con los mismos datos de la original, pero además añadiendo el nodo previo al que se conecta el cliente con la función LAG,
el primer valor de la fecha de conexión para ese cliente con FIRST_VALUE y el último con LAST_VALUE, para cuando un cliente cambia de fechas pero se mantiene en el 
mismo nodo, estas funciones hacen que podamos coger la primera fecha en la que se conecto a dicho nodo y la última.
Aquí hay una parte que he comentado (la última línea) que no entiendo porque no se pueden eliminar los infinitos desde el inicio para limpiarlos, ya que si se hace
desde el inicio, el resultado final en los días medios no es el mismo
*/
WITH cambios_mismo_nodo AS (
	SELECT 
		customer_id
		,node_id
		,LAG(node_id,1,0) OVER (PARTITION BY customer_id ORDER BY start_date) AS previous_node
		,start_date
		,FIRST_VALUE(start_date) OVER (PARTITION BY customer_id, node_id ORDER BY customer_id,start_date) AS start_date_aux
		,end_date
		,LAST_VALUE(end_date) OVER (PARTITION BY customer_id, node_id ORDER BY customer_id,start_date) AS end_date_aux
		--,DATEDIFF(DAY, start_date, end_date) AS diferencia_dias
	FROM case03.customer_nodes
	--WHERE end_date != '9999-12-31' --Quitamos los valores "infinitos" donde aún no se ha cambiado de nodo y por eso no interesan
),

/*
En esta parte obtenemos la diferencia de días que se obtiene entre la fecha inicial y la fecha final. Para ello, comprobamos en el CASE que el nodo actual y el nodo
previo son iguales, y si es así hacemos la diferencia de días entre la fecha de inicio -1 y la fecha final, en caso contrario hacemos la diferencia entre ambas 
fechas. Además, comprobamos si el nodo y el nodo previo son iguales y entonces marcamos a 0, si no a 1 y sumamos el resultado, ya que así agrupamos por periodos
donde los clientes son migrados a un mismo nodo (independientemente si en fechas correlativas o no).
*/
dias_nodo AS ( 
	SELECT 
		customer_id
		,node_id
		,start_date 
		,end_date
		,CASE WHEN node_id = previous_node 
			THEN DATEDIFF(DAY, DATEADD(day, -1, start_date), end_date) 
			ELSE DATEDIFF(DAY, start_date, end_date) 
		END AS diferencia_dias
		,SUM(CASE WHEN node_id = previous_node THEN 0 ELSE 1 END) OVER (ORDER BY  CUSTOMER_ID,START_DATE) dias_nodo
	FROM cambios_mismo_nodo
),

/*
En esta parte generamos un CASE para comprobar si la diferencia de días es mayor a 100 (que será en el caso que estemos generando la diferencia cuando la fecha
final es del tipo 9999-12-31, en ese caso ponemos un nulo en los días y en caso contrario pondremos la suma de la diferencía de días.
*/
suma_dias AS (
	SELECT
		dias_nodo
		,CASE WHEN SUM(diferencia_dias) > 100 THEN NULL ELSE SUM(diferencia_dias) END AS dias_por_nodo
	FROM dias_nodo
	GROUP BY dias_nodo
)

/*
En esta parte final obtenemos la media (redondeando a 2 decimales) de los dias por nodo en los que ha estado cada cliente, además añadimos otra columna donde
indicamos el resultado en texto
*/
SELECT 
	ROUND(AVG(CAST(dias_por_nodo AS FLOAT)),2) AS dias_reasignacion_media,
	concat('Los clientes se reasignan a un nodo diferente cada ', ROUND(AVG(CAST(dias_por_nodo AS FLOAT)),2), ' días de media') AS texto
FROM suma_dias;


/*
He seguido dando vueltas a la solución y he encontrado otra forma de hacerlo que creo más "limpia" ya que si quitamos los valores infinitos con el where
en la primera tabla temporal y luego obtenemos la fecha fin del siguiente registro (que sería el que coincide con el mismo nodo en el cliente, por lo que sería
para clientes que mantienen el mismo nodo en el cambio).
*/
WITH cambios_mismo_nodo AS (
	SELECT 
		customer_id
		,node_id
		,LAG(node_id,1,0) OVER (PARTITION BY customer_id ORDER BY start_date) AS previous_node
		,start_date
		,end_date
	FROM case03.customer_nodes
	WHERE end_date != '9999-12-31' --Quitamos los valores "infinitos" donde aún no se ha cambiado de nodo y por eso no interesan
),

diferentes_nodos AS ( 
	SELECT 
		customer_id
		,previous_node
		,node_id
		,start_date 
		,end_date
		,LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY customer_id, start_date) AS next_end_date
	FROM cambios_mismo_nodo
	where node_id != previous_node
),

valor_solucion AS(
	SELECT
		ROUND(AVG(CAST(DATEDIFF(DAY, start_date, DATEADD(DAY, -1, next_end_date)) AS FLOAT)), 2) AS average_reassignment_days_between_different_nodes
	FROM diferentes_nodos
)

SELECT 
	average_reassignment_days_between_different_nodes
	,CONCAT('Los clientes se reasignan a un nodo diferente cada ', average_reassignment_days_between_different_nodes, ' días de media') AS texto
FROM valor_solucion;
