WITH orders_cleaned AS(
	SELECT
		runner_id
		,order_id
		,CAST(SUM(CASE WHEN cancellation <> '' AND cancellation <> 'null' AND cancellation IS NOT NULL THEN 0 ELSE 1 END) AS FLOAT) AS orders_cancelled --obtenemos los pedidos que han sido cancelados
		,CAST(SUM(CASE WHEN cancellation = '' OR cancellation = 'null' OR cancellation IS NULL THEN 1 ELSE 0 END) AS FLOAT) AS orders_done --obtenemos los pedidos que han sido exitosos
		,CAST(COUNT(order_id) AS FLOAT) AS orders_total
	FROM case02.runner_orders
	GROUP BY runner_id
		,order_id
),

customer_orders_cleaned AS(
	SELECT
		order_id
		,pizza_id
		,CASE WHEN exclusions = '' OR exclusions = 'null' OR exclusions IS NULL THEN 0 ELSE 1 END AS exclusions --convertimos en flag para comprobar cuáles tienen ingredientes eliminados
		,CASE WHEN extras = '' OR extras = 'null' OR extras IS NULL THEN 0 ELSE 1 END AS extras --convertimos en flag para comprobar cuáles tienen ingredientes extras
	FROM case02.customer_orders
),

/* De aquí obtenemos el número de pizzas que han sido entregadas con éxito */
pizzas_delivered_without_cancellation AS(
	SELECT
		runner_id
		,CAST(COUNT(coc.pizza_id) AS FLOAT) as total_pizzas_ok
	FROM orders_cleaned oc
	JOIN customer_orders_cleaned coc
		ON oc.order_id = coc.order_id
	WHERE orders_cancelled = 1  --comprobamos que no han sido canceladas
	GROUP BY runner_id
),

/* De aquí obtenemos el número de pizzas que han sido entregadas modificadas (bien por exclusiones o bien por extras) */
pizzas_with_modification AS(
	SELECT
		runner_id
		,CAST(COUNT(coc.pizza_id) AS FLOAT) as total_pizzas_modificadas
	FROM orders_cleaned oc
	JOIN customer_orders_cleaned coc
		ON oc.order_id = coc.order_id
	WHERE orders_cancelled = 1 --comprobamos que no han sido canceladas
		AND (exclusions = 1 --comprobamos que tiene alguna exclusion o algún extra
		OR extras = 1)
	GROUP BY runner_id
)

SELECT
	runners.runner_id
	,SUM(COALESCE(orders_done,0)) AS num_pedidos_ok
	,COALESCE(total_pizzas_ok, 0) AS num_pizzas_ok
	,CONCAT(COALESCE((SUM(orders_done)/SUM(orders_total))*100,0) , '%') AS pct_pedidos_ok  
	,CONCAT(ROUND(COALESCE ((total_pizzas_modificadas * 100 / total_pizzas_ok), 0),2), '%') AS pct_pizzas_ok_mod
FROM orders_cleaned oc
JOIN pizzas_delivered_without_cancellation pdwc
	ON oc.runner_id = pdwc.runner_id
JOIN pizzas_with_modification pwm
	ON oc.runner_id = pwm.runner_id
RIGHT JOIN case02.runners runners
ON oc.runner_id = runners.runner_id
GROUP BY runners.runner_id
	,total_pizzas_ok
	,total_pizzas_modificadas
ORDER BY runner_id 

/* COMENTARIOS 
Se ha añadido el símbolo % para que los resultados sean más representativos. Si este resultado se incorporase en tablas, quitaríamos ese carácter y solo utilizaríamos el número.
También se ha ordenador por defecto por el runner, para mostrar un listado desde el runner 1 hacia el 4, pero dependería del resultado que se quisiera mostrar, si buscamos algo más
"ejecutivo" podríamos ordenador por el resultado de porcentaje de pedidos ok (que en este caso coincide con el runner) o si es un resultado de cara a cambiar la carta del restaurante,
por ejemplo, se podría ordenar por el porcentaje de pizzas modificadas, así se comprobaría cuáles son las más modificadas.
También como curiosidad, me gustaría saber si hay una forma de obtener el mismo resultado con un número menor de tablas temporales, le he dado algunas vueltas pero no lo he visto fácil,
igualmente le seguiré dando otras cuantas para ver si veo alguna forma :)
*/
