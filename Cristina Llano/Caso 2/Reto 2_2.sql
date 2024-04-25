/* ¿Cúantos pedidos y cuántas pizzas se han entregado con éxito por cada runner, cuál es su porcentaje de éxito de cada runner?
  ¿Qué porcentaje de las pizzas entregadas tenía modificaciones?
  Debes mostrar toda la información en una misma venta de resultado.*/

-- Se calcula una tabla de apoyo para los cálculos solicitados
-- En este caso he decidido utilizar # para crear la tabla temporal en vez de con with ya que la suelo utilizar más en mi día a día.
-- La ventaja que tiene es que no tienes que lanzar siempre toda la query
SELECT runner_id
	, SUM ( CASE WHEN (cancellation is null OR cancellation = 'null' or run.cancellation = '') THEN 1
				 ELSE 0 END 
			) AS pedidos_totales_OK
	, SUM ( CASE WHEN (cancellation is null OR cancellation = 'null' or run.cancellation = '') THEN 0
				 ELSE 1 END 
			) AS pedidos_totales_KO
	, SUM ( CASE WHEN (cancellation is null OR cancellation = 'null' or run.cancellation = '') THEN pedido.pizzas_pedido
				 ELSE 0 END 
			) AS pizzas_totales_OK
	, SUM (CASE WHEN (cancellation is null OR cancellation = 'null' or run.cancellation = '') AND pedido.intredientes_extras = 0 THEN pedido.intredientes_menos 
				      WHEN (cancellation is null OR cancellation = 'null' or run.cancellation = '') AND pedido.intredientes_menos = 0 THEN pedido.intredientes_extras
				      WHEN (cancellation is null OR cancellation = 'null' or run.cancellation = '') AND (pedido.intredientes_menos = 1 AND pedido.intredientes_extras = 1) THEN pedido.intredientes_extras
				ELSE 0 END ) AS pizzas_modificadas
INTO #base_runner_orders
FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders run
INNER JOIN 
(
	SELECT order_id
	, SUM ( CASE WHEN (extras is null OR extras = 'null' or extras = '') THEN 0
				       ELSE 1 END
			  ) AS intredientes_extras
	, SUM ( CASE WHEN (exclusions is null OR exclusions = 'null' or exclusions = '') THEN 0
				       ELSE 1 END
			  ) AS intredientes_menos
	, COUNT (customer_id) AS pizzas_pedido
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.customer_orders
	GROUP BY order_id
) pedido
	ON run.order_id = pedido.order_id
GROUP BY run.runner_id

SELECT run.runner_id
	, COALESCE(run_or.pedidos_totales_OK, 0) AS pedidos_totales_OK
	, COALESCE(run_or.pizzas_totales_OK, 0) AS pizzas_totales_OK
	, CONCAT(COALESCE(CAST ((run_or.pedidos_totales_OK*1.00 / (run_or.pedidos_totales_OK*1.00 + run_or.pedidos_totales_KO*1.00))*100 AS DECIMAL(5,2)),0.00), '%') AS por_pedido_OK
	, CONCAT(COALESCE(CAST ((run_or.pizzas_modificadas*1.00 / (run_or.pizzas_totales_OK*1.00))*100 AS DECIMAL(5,2)),0.00), '%') as por_pizzas_OK
FROM #base_runner_orders run_or
RIGHT JOIN SQL_EN_LLAMAS_ALUMNOS.case02.runners run
	ON run.runner_id = run_or.runner_id
ORDER BY 1;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Todo correcto Cristina, enhorabuena!!

Resultado: OK
Código: OK.
Legibilidad: OK.

Me ha gustado mucho el uso de # para crear la tabla temporal; no lo había visto hacer así aún a nadie.


*/
