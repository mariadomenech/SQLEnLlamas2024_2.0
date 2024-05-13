WITH CTE_ORDERS AS (
	SELECT 
		order_id,
		customer_id,
		pizza_id,
		CASE
			WHEN pizza_id=1 THEN 12
			WHEN pizza_id=2 THEN 10
			ELSE 0
		END price,
		CASE
			WHEN NULLIF(NULLIF(VALUE,'null'),'') IS NOT NULL THEN 1
			ELSE 0
		END supplement,
		NULLIF(NULLIF(VALUE,'null'),'') AS extra
	FROM case02.customer_orders
		CROSS APPLY STRING_SPLIT(extras, ',')
		
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
), CTE_RUNNER_COST AS (
	/*Coste por pedido*/
	SELECT
		order_id,
		SUM(cost) runner_cost
	FROM CTE_RUNNERS A
	GROUP BY order_id
), CTE_SALES AS (
	/*Ventas por pedido*/
	SELECT 
		A.order_id,
		SUM(A.price) price,
		SUM(A.supplement) supplement
	FROM CTE_ORDERS A
	JOIN CTE_RUNNERS B
		ON A.order_id=B.order_id
	GROUP BY A.order_id
)
/*Venta neta total*/
SELECT
SUM(A.price) + SUM(A.supplement) - SUM(runner_cost) net_sales
FROM CTE_SALES A
JOIN CTE_RUNNER_COST B
	ON A.order_id=B.order_id;
