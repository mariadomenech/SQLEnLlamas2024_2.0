-- Reto 3: ¿Cuánto dinero le sobra a Giuseppe después de estas entregas?

-- CTE para limpiar la tabla RUNNER_ORDERS
WITH CTE_limpieza_runner_orders
AS
(
	SELECT order_id
		,COALESCE(TRY_CAST(CASE	
			WHEN PATINDEX('%[A-Za-z]%', distance) > 0 THEN STUFF(distance, PATINDEX('%[A-Za-z]%', distance), LEN(distance), '')	
			ELSE distance 
			END AS DECIMAL(5,1)),0) AS distance
		,COALESCE(CASE
			WHEN cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation') THEN 'No'
			ELSE cancellation
		END, 'No') AS cancellation
	FROM case02.runner_orders
),

-- CTE para limpiar la tabla CUSTOMERS_ORDERS
CTE_limpieza_customers_orders
AS
(
	SELECT order_id
		,pizza_id
		,CASE	
			WHEN VALUE LIKE 'null' THEN '0' 
			WHEN extras LIKE '' THEN '0'
			WHEN extras IS NULL THEN '0'
			ELSE 1
		END AS extras
	FROM case02.customer_orders
		CROSS APPLY STRING_SPLIT(extras, ',')
),	

-- CTE para calcular el precio extra por ingrediente
CTE_precios_extras
AS
(
	SELECT CTE_RO.order_id
		,SUM(extras) precio_extras
	FROM CTE_limpieza_customers_orders CTE_CO
	JOIN CTE_limpieza_runner_orders CTE_RO
		ON CTE_CO.order_id = CTE_RO.order_id
	WHERE cancellation LIKE 'No'
	group by CTE_RO.order_id
),

-- CTE para calcular el precio de cada pizza en función de la tipología
CTE_precios_pizzas
AS
(
	SELECT CO.order_id
		,SUM(CASE
			WHEN CO.pizza_id = 1 THEN 12
			WHEN CO.pizza_id = 2 THEN 10
			ELSE 0
		END) AS precio_pizzas
	FROM case02.customer_orders CO
	JOIN CTE_limpieza_runner_orders CTE_RO
		ON CO.order_id = CTE_RO.order_id
	WHERE cancellation LIKE 'No'
	group by CO.order_id
),

-- CTE para calcular el coste de la carrera
CTE_coste_carrera
AS
(
	SELECT CTE_RO.order_id
		,(distance * 0.3) AS coste_corredor
	FROM CTE_limpieza_runner_orders CTE_RO
	WHERE cancellation LIKE 'No'
	group by CTE_RO.order_id
		,distance
)

-- Query general para calcular las cifras totales
SELECT SUM(precio_pizzas) AS precio_pizzas
	,SUM(precio_extras) AS precio_extras
	,SUM(coste_corredor) AS coste_corredor
FROM CTE_precios_extras CTE_PE
JOIN CTE_precios_pizzas CTE_PP
	ON CTE_PE.order_id = CTE_PP.order_id
JOIN CTE_coste_carrera CTE_RO
	ON CTE_PE.order_id = CTE_RO.order_id
