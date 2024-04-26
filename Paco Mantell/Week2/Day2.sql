WITH CTE_CLEAN_ORDERS AS (
	SELECT order_id,
	customer_id,
	pizza_id,
	NULLIF(exclusions, '') exclusions,
	NULLIF(VALUE, '') AS extras
	FROM 
	(
		SELECT order_id,
			customer_id,
			pizza_id,
			VALUE AS exclusions,
			extras
		FROM case02.customer_orders
			CROSS APPLY STRING_SPLIT(exclusions, ',')
	) split_exclusions
		CROSS APPLY STRING_SPLIT(extras, ',')
), CTE_TOT_SUCCESS AS (
	SELECT A.runner_id,
		COUNT(DISTINCT B.order_id) success_order,
		COUNT(B.pizza_id) success_pizzas		
	FROM case02.runner_orders A
	LEFT JOIN CTE_CLEAN_ORDERS B
		ON A.order_id=B.order_id
	WHERE A.cancellation NOT LIKE('%Cancellation%')
	GROUP BY runner_id
), CTE_TOT_ORDERS AS (
	SELECT A.runner_id,
		COUNT(DISTINCT B.order_id) total_order,
		COUNT(B.pizza_id) total_pizzas		
	FROM case02.runner_orders A
	LEFT JOIN CTE_CLEAN_ORDERS B
		ON A.order_id=B.order_id
	GROUP BY runner_id
), CTE_TOT_PIZZAS_MOD AS (
SELECT A.runner_id,
	COUNT(DISTINCT pizza_id) num_pizzas
FROM case02.runner_orders A
JOIN CTE_CLEAN_ORDERS B
	ON A.order_id=B.order_id
WHERE exclusions NOT LIKE 'null'
	AND extras NOT LIKE 'null'
	AND A.cancellation NOT LIKE('%Cancellation%')
GROUP BY A.runner_id
)
SELECT A.runner_id,
	ISNULL(B.success_order, 0) success_orders,
	CONCAT(CONVERT(FLOAT, ISNULL((B.success_order * 1.0 / A.total_order),0)) *100, '%') success_rate,
	ISNULL(B.success_pizzas, 0) success_pizzas,
	CONCAT(CONVERT(FLOAT, ISNULL((C.num_pizzas * 1.0 / A.total_pizzas),0)) *100, '%') mod_rate
FROM CTE_TOT_ORDERS A
LEFT JOIN CTE_TOT_SUCCESS B
	ON A.runner_id=B.runner_id
LEFT JOIN CTE_TOT_PIZZAS_MOD C
	ON a.runner_id=c.runner_id


/*********************************************/
/*************COMENTARIO DANI*****************/
/* Resultado incorrecto, hay diferentes puntos donde podría residir el problema.
Lo primero es que el resultado que nos devuelve la consulta no contabiliza bien lo
que se pide, los resultados son erróneos. Uno de los puntos a destacar es el uso de
CROSS APPLY STRING_SPLIT, esta técnica no es recomendable ya que su uso en conjunto
de datos grandes empeoraría de manera considerable el rendimiento, te animo a buscarle
un enfoque diferente, una CTE por ejemplo te ayudaría a limpiar los datos de manera 
mas eficiente. Luego vemos que en la CTE_TOT_PIZZAS_MOD la claúsula WHERE filtra donde
exclusions y extras son 'null' sin embargo no maneja los casos en los que exclusions y
extras son cadenas vacías, te sugiero agregar alguna condición adicional para tener en
cuenta estas cadenas. Por otro lado te recomiendo mejorar un punto la legibilidad, no 
es mala, pero podría ser mejor, intenta indexar los atributos y campos, eso seguro que
te ayudará un montón. En cuanto tengas la consulta corregida plásmamela abajo de este
comentario. Ánimo Paco, sé que puedes, tu consulta muestra originalidad y habilidad
para resolver problemas! */
