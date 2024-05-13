/* Alumno: Sergio Díaz */
/* CASO 2 - Ejercicio 2: Pedidas y pizzas con éxito, % de pedidos con éxito y % pizzas modificadas */

SELECT runners.runner_id AS RUNNER_ID
	,COALESCE(PRINCIPAL.N_PEDIDOS_EXITOSOS, 0) AS N_PEDIDOS_OK
	,COALESCE(PRINCIPAL.N_PIZZAS, 0) AS N_PIZZAS_OK
	,ROUND(COALESCE(PRINCIPAL.PORCENTAJE_EXITO * 100, 0),2) AS PORC_PEDIDOS_OK --Formateo del porcentaje sobre 100
	,ROUND(CAST(COALESCE(PRINCIPAL.PORCENTAJE_MODIFICADAS * 100, 0) AS FLOAT), 2) AS PORC_PIZZAS_MODIFICADAS --Formateo del porcentaje sobre 100 y 2 decimales
FROM case02.runners runners
LEFT JOIN (
	SELECT runner_orders.RUNNER_ID
		,COUNT(CASE 
				WHEN runner_orders.duration <> 'null'
					THEN 1
				END) AS N_PEDIDOS_EXITOSOS --Pedidos sin cancelar
		,SUM(PIZZAS.n_pizzas) AS N_PIZZAS
		,COUNT(CASE 
				WHEN runner_orders.duration <> 'null'
					THEN 1
				END) / cast(COUNT(runner_orders.ORDER_ID) AS FLOAT) AS PORCENTAJE_EXITO -- % Pedidos con éxito
		,SUM(PIZZAS.n_pizzas_modificadas) AS N_PIZZAS_MODIFICADAS
		,SUM(PIZZAS.n_pizzas_modificadas) / CAST(SUM(PIZZAS.N_PIZZAS) AS FLOAT) AS PORCENTAJE_MODIFICADAS
	FROM case02.runner_orders
	LEFT JOIN (
		SELECT cust_orders.order_id
			,COUNT(cust_orders.pizza_id) AS n_pizzas
			,COUNT(CASE 
					WHEN (
							cust_orders.exclusions <> 'null'
							AND cust_orders.exclusions IS NOT NULL
							AND cust_orders.exclusions <> ''
							)
						OR (
							cust_orders.extras <> 'null'
							AND cust_orders.extras IS NOT NULL
							AND cust_orders.extras <> ''
							)
						THEN 1
					END) AS n_pizzas_modificadas --clausulas para saber si una pizza está o no modificada
		FROM case02.customer_orders cust_orders
		JOIN case02.runner_orders runners_orders 
		ON cust_orders.order_id = runners_orders.order_id
		WHERE runners_orders.duration <> 'null' --filtro para quedarnos con las pizzas que no están canceladas
		GROUP BY cust_orders.order_id
		) AS PIZZAS 
		ON runner_orders.order_id = PIZZAS.order_id
	GROUP BY RUNNER_ID
	) AS PRINCIPAL 
	ON runners.runner_id = PRINCIPAL.runner_id
ORDER BY runners.runner_id


/*********************************************************/
/***************** COMENTARIO MARÍA  *********************/
/*********************************************************/
/*

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. 
Legibilidad: OK. 

¡Enhorabuena!
*/
