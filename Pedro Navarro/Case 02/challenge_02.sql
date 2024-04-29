-- RETO 2. ¿CUÁNTOS PEDIDOS Y CUÁNTAS PIZZAS SE HAN ENTREGADO CON ÉXITO POR CADA RUNNER, CUÁL ES SU
-- PORCENTAJE DE ÉXITO DE CADA RUNNER? ¿QUÉ PORCENTAJE DE LAS PIZZAS ENTREGADAS TENÍAN MODIFICACIONES?
-- DEBES MOSTRAR TODA LA INFORMACIÓN EN UNA MISMA VENTANA DE RESULTADOS
;WITH
	RUNNER_ORDERS_CLEANED AS (
		SELECT
			order_id
			,runner_id
			,CAST(NULLIF(pickup_time, 'null') AS DATETIME) AS pickup_time
			,CAST(
				CASE
					WHEN PATINDEX('%k%m%', distance) > 0 
						THEN TRIM(SUBSTRING(distance, 1, PATINDEX('%k%m%', distance)-1))
					ELSE REPLACE(LOWER(TRIM(distance)), 'null', 0)
				END AS FLOAT) AS distance_in_km
			,CAST(
				CASE
					WHEN PATINDEX('%min%', duration) > 0 
						THEN TRIM(SUBSTRING(duration, 1, PATINDEX('%min%', duration)-1))
					ELSE REPLACE(LOWER(TRIM(duration)), 'null', 0)
				END AS FLOAT) AS duration_in_min
			,CASE
				WHEN cancellation IN ('', 'null') THEN NULL
				ELSE cancellation
			END AS cancellation
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders
	)

	,CUSTOMER_ORDERS_CLEANED AS (
		SELECT
			order_id
			,customer_id
			,pizza_id
			,NULLIF(NULLIF(exclusions, ''), 'null') AS exclusions
			,NULLIF(NULLIF(extras, ''), 'null') AS extras
			,order_time
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.customer_orders
	)

	,RUNNER_SUCCESSFUL_ORDERS AS (
		SELECT
			runner_id
			,order_id
		FROM RUNNER_ORDERS_CLEANED
		WHERE cancellation IS NULL
	)

	,RUNNER_SUCCESSFUL_ORDERS_AND_PIZZAS AS (
		SELECT
			rso.runner_id
			,COUNT(DISTINCT rso.order_id) as total_successful_orders
			,COUNT(*) as total_successful_pizzas
		FROM RUNNER_SUCCESSFUL_ORDERS AS rso
		LEFT JOIN CUSTOMER_ORDERS_CLEANED AS co
			ON rso.order_id = co.order_id
		GROUP BY rso.runner_id
	)

	,RUNNER_SUCCESSFUL_ORDERS_PERCENTAGE AS (
		SELECT
			ro.runner_id
			,100.00*COUNT(rso.order_id)/COUNT(ro.order_id) AS successful_orders_in_percentage
		FROM RUNNER_ORDERS_CLEANED AS ro
		LEFT JOIN RUNNER_SUCCESSFUL_ORDERS AS rso
			ON ro.order_id = rso.order_id
		GROUP BY ro.runner_id
	)

	,RUNNER_SUCCESSFUL_ALTERED_PIZZAS_PERCENTAGE AS (
		SELECT
			rso.runner_id
			,COUNT(*) AS total_successful_altered_pizzas
		FROM RUNNER_SUCCESSFUL_ORDERS AS rso
		LEFT JOIN CUSTOMER_ORDERS_CLEANED AS co
			ON rso.order_id = co.order_id
		WHERE co.exclusions IS NOT NULL OR co.extras IS NOT NULL
		GROUP BY rso.runner_id
	)
	
	,RUNNERS_STATISTICS AS (
		SELECT
			r.runner_id
			,ISNULL(oap.total_successful_orders, 0) AS total_successful_orders
			,ISNULL(oap.total_successful_pizzas, 0) AS total_successful_pizzas
			,FORMAT(ISNULL(op.successful_orders_in_percentage, 0), 'N2') AS successful_orders_in_percentage
			,FORMAT(ISNULL(100.00*app.total_successful_altered_pizzas/oap.total_successful_pizzas, 0), 'N2') AS successful_altered_pizzas_in_percentage
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.runners AS r
		LEFT JOIN RUNNER_SUCCESSFUL_ORDERS_AND_PIZZAS AS oap
			ON r.runner_id = oap.runner_id
		LEFT JOIN RUNNER_SUCCESSFUL_ORDERS_PERCENTAGE AS op
			ON r.runner_id = op.runner_id
		LEFT JOIN RUNNER_SUCCESSFUL_ALTERED_PIZZAS_PERCENTAGE AS app
			ON r.runner_id = app.runner_id
	)

SELECT *
FROM RUNNERS_STATISTICS;


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

RESULTADO: Correcto
CÓDIGO: Correcto.
LEGIBILIDAD: Correcto.

Perfecto Pedro, me ha gustado mucho como lo has organizado, aunque es cierto que se puede conseguir es menos tablas,
a mi parecer, es mucho mejor de esta forma pues lo hace mucho más legible y fácil de seguir!

*/




