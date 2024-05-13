WITH CTE_ORDERS AS (
	/*Asignamos precio y limpiamos un poco*/
	SELECT B.runner_id,
		A.order_id,
		customer_id,
		pizza_id,
		CASE
			WHEN pizza_id=1 THEN 12
			WHEN pizza_id=2 THEN 10
			ELSE 0
		END price,
		CASE
			WHEN extras IS NULL OR extras like '%null%' OR extras='' THEN 'No'
			ELSE extras
		END extras,
		NULLIF(NULLIF(B.cancellation,'null'),'') cancellation
	FROM case02.customer_orders A
	JOIN case02.runner_orders B
	ON A.order_id=B.order_id
), CTE_SALES_EXTRAS AS (
	/*Ventas de extras por pedido*/
	SELECT runner_id,
	order_id,
	SUM(CASE
		WHEN VALUE='No' THEN 0
		ELSE 1
	END) extra_sales,
	cancellation
	FROM CTE_ORDERS
	CROSS APPLY STRING_SPLIT(EXTRAS, ',')
	WHERE cancellation IS NULL
	GROUP BY runner_id, order_id,cancellation
), CTE_SALES AS(
	/*Ventas por pedido*/
	SELECT 
	A.order_id,
	SUM(price) pizza_sales,
	extra_sales
	FROM CTE_ORDERS A
	JOIN CTE_SALES_EXTRAS B
		ON A.order_id=B.order_id
	WHERE A.cancellation IS NULL
	GROUP BY A.order_id, extra_sales
), CTE_RUNNERS AS (
	/*Tabla de distancias por runner*/
	SELECT
		A.runner_id runner,
		B.order_id,
		CASE WHEN PATINDEX('%[A-z]%', B.distance) > 0 THEN
			CAST(LEFT(B.distance, PATINDEX('%[A-z]%', B.distance) - 1) AS FLOAT) * 0.3
			ELSE ISNULL(CAST(B.distance AS FLOAT), 0) * 0.3
		END cost,
		NULLIF(NULLIF(B.cancellation, ''), 'null') cancellation
	FROM case02.runners A
	LEFT JOIN case02.runner_orders B
		ON A.runner_id = B.runner_id
	WHERE NULLIF(NULLIF(B.cancellation, ''), 'null') IS NULL
)
/*Calculamos venta neta*/
SELECT SUM(pizza_sales) + SUM(extra_sales) - SUM(cost) net_sales
FROM CTE_SALES A
JOIN CTE_RUNNERS B
	ON A.order_id=B.order_id
