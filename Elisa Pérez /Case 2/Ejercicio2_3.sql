
WITH A AS
(
	SELECT	CO.order_id
			, SUM(CASE 
				WHEN CO.pizza_id = 1 THEN 12
				WHEN CO.pizza_id = 2 THEN 10
				ELSE 0
			END) AS ING_PIZZAS
			, MAX(CAST(REPLACE(distance, 'km', '')AS decimal(4,2))*0.3) AS COSTES
	FROM case02.customer_orders CO
	JOIN case02.runner_orders RO
	ON CO.order_id = RO.order_id
	WHERE RO.pickup_time <> 'null'
	GROUP BY CO.order_id
),
B AS(
	SELECT	order_id
			, COUNT(*) ING_EXTRAS
	FROM	case02.customer_orders
			CROSS APPLY STRING_SPLIT(extras, ',')
			WHERE extras <> '' AND extras <> 'null' AND extras IS NOT NULL
			GROUP BY order_id
)
SELECT SUM(ING_PIZZAS) ING_PIZZAS
		, SUM(ING_EXTRAS) ING_EXTRAS
		, SUM(COSTES) COSTES
FROM A
LEFT JOIN B
ON A.order_id = B.order_id;
