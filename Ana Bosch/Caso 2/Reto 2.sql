-- Reto 2: ¿Cuántos pedidos y cuántas pizzas se han entregado con éxito por cada runner, cuál es su porcentaje de éxito de cada runner? ¿Qué porcentaje de las pizzas entregadas tenían modificaciones?

-- CTE para la limpieza de la tabla CUSTOMERS_ORDERS
WITH CTE_limpieza_customers_orders
AS
(
	SELECT order_id
		,pizza_id
		,CASE 
			WHEN exclusions LIKE 'null' THEN '0'
			WHEN exclusions LIKE '' THEN '0'
			WHEN exclusions IS NULL THEN '0'
			else 1
			end exclusions
		,CASE 
			WHEN extras LIKE 'null' THEN '0'
			WHEN extras LIKE '' THEN '0'
			WHEN extras IS NULL THEN '0'
			else 1
			end extras
	FROM case02.customer_orders A
),

-- CTE para la limpieza de la tabla CUSTOMERS_RUNNERS
CTE_limpieza_runners
AS
(
	SELECT B.order_id
		,A.runner_id
		,C.pizza_id
		,C.exclusions
		,C.extras
		,COALESCE(CASE
			WHEN cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation') THEN 'No'
			ELSE cancellation
		END, 'No') AS cancellation
	FROM case02.runners A
	LEFT JOIN case02.runner_orders B
		ON A.runner_id = B.runner_id
	LEFT JOIN CTE_limpieza_customers_orders C
		ON B.order_id = C.order_id
),

-- CTE para calcular pedidos y pizzas OK
CTE_OK
AS
(
	SELECT runner_id
		,COUNT(DISTINCT order_id) AS pedidos_OK
		,COUNT(pizza_id) AS pizzas_OK
	FROM CTE_limpieza_runners
	WHERE cancellation LIKE 'No'
	GROUP BY runner_id
),

 -- CTE para calcular pedidos y pizzas KO
CTE_KO
AS
(
	SELECT runner_id
		,COUNT(DISTINCT order_id) AS pedidos_KO
		,COUNT(pizza_id) AS pizzas_KO
	FROM CTE_limpieza_runners
	WHERE cancellation NOT LIKE 'No'
	GROUP BY runner_id
),

 -- CTE para calcular pizzas modificadas
CTE_pizzas_MOD
AS
(
	SELECT runner_id
		,COUNT(pizza_id) AS pizzas_MOD
	FROM CTE_limpieza_runners
	WHERE cancellation LIKE 'No' AND (exclusions = '1' or extras = '1')
	GROUP BY runner_id
)

-- Query general con los cálculos finales
SELECT OK.runner_id
	,pedidos_OK
	,pizzas_OK
	,CASE 
		WHEN pedidos_OK = 0 THEN 0
		ELSE CONVERT(INT, CAST(pedidos_OK AS DECIMAL(5,2)) / CAST(pedidos_OK + COALESCE(pedidos_KO, 0) AS DECIMAL(5,2)) * 100)
		END AS percent_pedidos_OK
	,CASE 
		WHEN pizzas_OK = 0 THEN 0
		ELSE CAST(CAST(pizzas_MOD AS DECIMAL(5,2)) / CAST(pizzas_OK AS DECIMAL (5,2)) * 100 AS DECIMAL(5,2))
		END AS percent_pedidos_OK
FROM CTE_OK OK
LEFT JOIN CTE_KO KO
	ON OK.runner_id = KO.runner_id
LEFT JOIN CTE_pizzas_MOD pizzas_MOD
	ON OK.runner_id = pizzas_MOD.runner_id
ORDER BY 1 ASC
