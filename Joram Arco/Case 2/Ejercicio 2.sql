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
ORDER BY runner_id;

/* COMENTARIOS 
Se ha añadido el símbolo % para que los resultados sean más representativos. Si este resultado se incorporase en tablas, quitaríamos ese carácter y solo utilizaríamos el número.
También se ha ordenador por defecto por el runner, para mostrar un listado desde el runner 1 hacia el 4, pero dependería del resultado que se quisiera mostrar, si buscamos algo más
"ejecutivo" podríamos ordenador por el resultado de porcentaje de pedidos ok (que en este caso coincide con el runner) o si es un resultado de cara a cambiar la carta del restaurante,
por ejemplo, se podría ordenar por el porcentaje de pizzas modificadas, así se comprobaría cuáles son las más modificadas.
También como curiosidad, me gustaría saber si hay una forma de obtener el mismo resultado con un número menor de tablas temporales, le he dado algunas vueltas pero no lo he visto fácil,
igualmente le seguiré dando otras cuantas para ver si veo alguna forma :)
*/


/* SOLUCIÓN 2
He estado dando algunas vueltas más al ejercicio y he visto que hay otra manera donde no es necesario crear tantas tablas temporales y la consulta en sí se quedaría algo más limpia
*/
WITH orders_cleaned AS(
	SELECT
		runners.runner_id AS runner_id
		,COALESCE(runner_orders.order_id, 0) AS order_id
		,CASE WHEN UPPER(cancellation) LIKE '%CANCELLATION%' OR pickup_time IS NULL THEN 0 ELSE 1 END AS pedidos_completados
		,CASE WHEN COALESCE(exclusions, '') IN ('', 'null') THEN 0 ELSE 1 END AS exclusiones
		,CASE WHEN COALESCE(extras, '') IN ('', 'null') THEN 0 ELSE 1 END as extras
	FROM case02.runner_orders runner_orders
	JOIN case02.customer_orders customer_orders
		ON runner_orders.order_id = customer_orders.order_id
	RIGHT JOIN case02.runners runners
		ON runner_orders.runner_id = runners.runner_id
),

orders_total AS (
	SELECT 
		runner_id
		,CAST( COUNT( DISTINCT CASE WHEN pedidos_completados = 1 THEN order_id ELSE NULL END) AS FLOAT) AS num_pedidos_ok
		,COUNT (DISTINCT order_id) as num_pedidos
		,CAST( COUNT( CASE WHEN pedidos_completados = 1 THEN order_id ELSE NULL END) AS FLOAT) AS num_pizzas_ok
		,CAST( SUM( CASE WHEN pedidos_completados = 1 AND (exclusiones = 1 OR extras = 1) THEN 1 ELSE 0 END ) AS FLOAT) AS num_pizzas_modificadas
	FROM orders_cleaned
	GROUP BY runner_id
)

SELECT
	runner_id
	,num_pedidos_ok
	,num_pizzas_ok
	,CONCAT (CASE WHEN num_pedidos = 0 THEN 0 ELSE (num_pedidos_ok * 100 / num_pedidos) END ,'%') AS pct_pedidos_ok
	,CONCAT (CASE WHEN num_pizzas_ok = 0 THEN 0 ELSE ROUND((num_pizzas_modificadas * 100 / num_pizzas_ok), 2) END, '%') AS pct_pizzas_ok_mod
FROM orders_total;

/*COMENTARIOS JUANPE
Bien por las dos opciones, ambas muy bien ordenadas y usando los with se consigue un código más limpio y facil de seguir. La primera aunque con más with valida igual pero me gusta la segunda que se hace en menos lineas de código. 
En cuanto al simbolo de porcentaje también me parece bien sobre todo porque lo has anotado en comentarios, porque es cierto que al ponerle el simbolo pasas un numero a char y si hace falta usarlo te tocaria volver a pasar a number y quitarle el simbolo
pero al reflejarlo en el comentario me parece perfecto, pues demuestras no solo que lo pones para que quede guay si no que sabes las consecuencias de ponerlo, por ello ¡genial!
En cuanto al orden de moestrarlos si que tiene sentido que sea por % de exito que en este caso coincide con id runner.
Y aunque me parece todo genial en el ejercicio si quiero hacerte un comentario, cuando haces "CAST" no es necesario si lo que hay dentro es un conteo o una suma que por defecto el conteo y la suma ya te devuelven valor numerico, si fuera para forzar a que
tengas un determinado numero de decimales si, pero en este caso son números enteros, num_pedidos_ok,num_pizzas_ok,num_pizzas_modificadas no te hace falta el cast.
Pero todo genial.*/
