/* Alumno: Sergio Díaz */
/* CASO 2 - Ejercicio 5: Veces que ha usado cada topping en pedido exitoso*/

WITH ingredientes_pizzas --CTE para obtener los ingredientes de cada pizza en columna
AS (
	SELECT pizza_id
		,topping_id
	FROM (
		SELECT *
		FROM case02.pizza_recipes_split
		) toppings
	UNPIVOT(topping_id FOR Topping IN (
				topping_1
				,topping_2
				,topping_3
				,topping_4
				,topping_5
				,topping_6
				,topping_7
				,topping_8
				)) AS unpvt
	)
	,n_pizzas_pedidos --CTE para obtener el número de pizzas pedidas con éxito de cada tipo
AS (
	SELECT cust_orders.pizza_id AS pizza
		,count(cust_orders.pizza_id) AS n_pizzas
	FROM case02.customer_orders cust_orders
	JOIN case02.runner_orders runners_orders 
	ON cust_orders.order_id = runners_orders.order_id
	WHERE runners_orders.duration <> 'null' --quitamos los cancelados
	GROUP BY cust_orders.pizza_id
	)
	,toppings_excluidos --CTE para obtener los ingredientes excluidos
AS (
	SELECT topping_id_excluido
		,COUNT(topping_id_excluido) AS n_veces_excluido
	FROM (
		SELECT cust_orders.order_id
			,CASE 
				WHEN value = 'beef'
					THEN 3
				WHEN value = NULL
					THEN 0
				WHEN value = 'null'
					THEN 0
				ELSE value
				END AS topping_id_excluido
		FROM case02.customer_orders cust_orders
		CROSS APPLY STRING_SPLIT(exclusions, ',') --dividimos los extras por comas (obtenemos 1 por fila)
		JOIN case02.runner_orders runners_orders 
		ON cust_orders.order_id = runners_orders.order_id
		WHERE runners_orders.duration <> 'null' --quitamos los cancelados
			AND value NOT IN (
				''
				,'null'
				,'0'
				)
		) AS excluidos
	GROUP BY topping_id_excluido
	)
	,topping_extras --CTE para obtener los ingresdientes extras
AS (
	SELECT value AS topping_extra_id
		,count(value) AS n_veces_extra
	FROM case02.customer_orders cust_orders
	CROSS APPLY STRING_SPLIT(extras, ',') --dividimos los extras por comas (obtenemos 1 por fila)
	JOIN case02.runner_orders runners_orders 
	ON cust_orders.order_id = runners_orders.order_id
	WHERE runners_orders.duration <> 'null' --quitamos los cancelados
		AND value NOT IN (
			''
			,'null'
			)
	GROUP BY value
	)
	,toppings_pizza_1 -- CTE para obtener el número de ingredientes usados en las pizzas de tipo 1
AS (
	SELECT toppings.topping_id
		,topping_name
		,pizzas_pedidos.n_pizzas AS n_veces
	FROM case02.pizza_toppings toppings
	LEFT JOIN ingredientes_pizzas ingr_pizzas 
	ON ingr_pizzas.topping_id = toppings.topping_id
	LEFT JOIN n_pizzas_pedidos pizzas_pedidos 
	ON ingr_pizzas.pizza_id = pizzas_pedidos.pizza
	WHERE pizzas_pedidos.pizza = 1
	)
	,toppings_pizza_2 -- CTE para obtener el número de ingredientes usados en las pizzas de tipo 2
AS (
	SELECT toppings.topping_id
		,topping_name
		,pizzas_pedidos.n_pizzas AS n_veces
	FROM case02.pizza_toppings toppings
	LEFT JOIN ingredientes_pizzas ingr_pizzas 
	ON ingr_pizzas.topping_id = toppings.topping_id
	LEFT JOIN n_pizzas_pedidos pizzas_pedidos 
	ON ingr_pizzas.pizza_id = pizzas_pedidos.pizza
	WHERE pizzas_pedidos.pizza = 2
	)
	,veces_toppings -- CTE para obtener el número total de veces usado de cada ingrediente
AS (
	SELECT COALESCE(pizza1.n_veces, 0) + COALESCE(pizza2.n_veces, 0) - COALESCE(excluidos.n_veces_excluido, 0) + COALESCE(extras.n_veces_extra, 0) AS N_VECES_TOTAL
		,STRING_AGG(toppings.topping_name, ' ,') AS INGREDIENTES
	FROM case02.pizza_toppings toppings
	LEFT JOIN toppings_pizza_1 AS pizza1 
	ON pizza1.topping_name = toppings.topping_name
	LEFT JOIN toppings_pizza_2 AS pizza2 
	ON pizza2.topping_name = toppings.topping_name
	LEFT JOIN toppings_excluidos excluidos 
	ON toppings.topping_id = excluidos.topping_id_excluido
	LEFT JOIN topping_extras extras 
	ON toppings.topping_id = extras.topping_extra_id
	GROUP BY COALESCE(pizza1.n_veces, 0) + COALESCE(pizza2.n_veces, 0) - COALESCE(excluidos.n_veces_excluido, 0) + COALESCE(extras.n_veces_extra, 0)
	)
	
	
SELECT ROW_NUMBER() OVER ( --Select final para mostrar la solucion
		ORDER BY n_veces_total DESC
		) AS RANKING
	,*
FROM veces_toppings
ORDER BY n_veces_total DESC

/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Perfecto!

Resultado: OK
Código: OK.
Legibilidad: OK.


*/
