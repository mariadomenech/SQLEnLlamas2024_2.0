/* Alumno: Sergio Díaz */
/* CASO 2 - Ejercicio 3: Dinero que sobra tras las entregas */


SELECT SUM(desglose_pizzas.precio_total_pizzas) AS INGRESOS_PIZZAS --ingresos debido a la venta de pizzas
	,SUM(desglose_pizzas.n_ingredientes) AS INGRESOS_INGREDIENTES -- ingresos debido a los ingredientes extras
	,(
		SELECT COALESCE(SUM(CAST([case02].GetNumbers(runners_orders_3.distance) AS FLOAT)), 0)
		FROM case02.runner_orders runners_orders_3
		) * 0.3 AS COSTES_ENVIO --costes de los envíos
	,SUM(desglose_pizzas.precio_total_pizzas) + SUM(desglose_pizzas.n_ingredientes) - (
		(
			SELECT COALESCE(SUM(CAST([case02].GetNumbers(runners_orders_3.distance) AS FLOAT)), 0)
			FROM case02.runner_orders runners_orders_3
			) * 0.3
		) AS DINERO_PARA_JOSEP --total dinero que le sobra a Josep
FROM (
	SELECT cust_orders_2.pizza_id AS pizza
		,count(cust_orders_2.pizza_id) AS n_pizzas
		,max(pizzas_ingredientes.n_ingredientes) AS n_ingredientes
		,CASE 
			WHEN cust_orders_2.pizza_id = 1
				THEN 12
			ELSE 10
			END AS precio_unitario
		,(
			CASE 
				WHEN cust_orders_2.pizza_id = 1
					THEN 12
				ELSE 10
				END
			) * count(cust_orders_2.pizza_id) AS precio_total_pizzas
	FROM case02.customer_orders cust_orders_2
	JOIN (
		SELECT pizza_id
			,SUM(CASE 
					WHEN value <> 'null'
						AND value <> ''
						THEN 1
					END) AS n_ingredientes --contamos solo los ingredientes no nulos
		FROM case02.customer_orders cust_orders
		CROSS APPLY STRING_SPLIT(extras, ',') --dividimos los extras por comas (obtenemos 1 por fila)
		JOIN case02.runner_orders runners_orders 
		ON runners_orders.order_id = cust_orders.order_id
		WHERE runners_orders.duration <> 'null' --quitamos los cancelados
		GROUP BY pizza_id
		) AS pizzas_ingredientes 
		ON cust_orders_2.pizza_id = pizzas_ingredientes.pizza_id
	JOIN case02.runner_orders runners_orders_2 
	ON runners_orders_2.order_id = cust_orders_2.order_id
	WHERE runners_orders_2.duration <> 'null' --quitamos los cancelados
	GROUP BY cust_orders_2.pizza_id
	) AS desglose_pizzas --query para obtener ingredientes, cantidad de pizzas de cada tipo y su precio


/*********************************************************/
/***************** COMENTARIO MARÍA  *********************/
/*********************************************************/
/*

Genial por incluir beneficios que era realmente lo que se pedia aunque por error la app no lo mostroba. 
Bien visto la función STRING_SPLIT
¡Todo perfecto!

*/
