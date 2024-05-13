WITH CTE_SPLIT_ING AS (
	/*Pivot de ingredientes*/
	SELECT
	pizza_id,
	Ing_1, Ing_2, Ing_3, Ing_4, Ing_5, Ing_6, Ing_7, Ing_8
	FROM (
		SELECT 
			pizza_id,
			CAST(value AS INT) topping_id,
			CONCAT('Ing_',ROW_NUMBER() OVER (PARTITION BY pizza_id order by pizza_id)) topp
		FROM case02.pizza_recipes
		CROSS APPLY STRING_SPLIT(toppings, ',')
	) split_T
	PIVOT(
	SUM(topping_id) FOR topp IN (Ing_1, Ing_2, Ing_3, Ing_4, Ing_5, Ing_6, Ing_7, Ing_8)) pivot_T
), CTE_ORDERS AS (
	/*Limpio pedidos*/
	SELECT 
		B.runner_id,
		A.order_id,
		customer_id,
		pizza_id,
		CASE
			WHEN exclusions IS NULL OR exclusions like '%null%' OR exclusions='' THEN 'No'
			WHEN exclusions LIKE 'beef' THEN '3'
			ELSE exclusions
		END exclusions,
		CASE
			WHEN extras IS NULL OR extras like '%null%' OR extras='' THEN 'No'
			ELSE extras
		END extras
	FROM case02.customer_orders A
	JOIN case02.runner_orders B
	ON A.order_id=B.order_id
	WHERE NULLIF(NULLIF(B.cancellation,'null'),'') IS NULL
), CTE_UNPIVOT AS (
	/*Cuento ingredientes por pizza*/
	SELECT 
		pizza_id,
		topping_id,
		COUNT(*) times_used
	FROM (
		SELECT * 
		FROM CTE_SPLIT_ING
		) AS pizza_split
	UNPIVOT (
		topping_id FOR item IN (
				Ing_1, Ing_2, Ing_3, Ing_4, Ing_5, Ing_6, Ing_7, Ing_8
				)
			) unpivote
	GROUP BY pizza_id,topping_id
), CTE_TOTAL_PEDIDOS AS (
	/*Pizzas entregadas*/
	SELECT
		A.pizza_id,
		COUNT(A.pizza_id) times
	FROM CTE_ORDERS A
	GROUP BY A.pizza_id
), CTE_ING_USED AS (
	/*Veces que se ha usado cad aingrediente en una entrega*/
	SELECT topping_id,
	SUM(times) times_used
	FROM CTE_TOTAL_PEDIDOS A
	JOIN CTE_UNPIVOT B
		ON A.pizza_id=B.pizza_id
	GROUP BY topping_id
), CTE_ING_AS_EXTRA AS (
	/*Ingredientes como extras*/
	SELECT 
		CAST(VALUE AS INT) AS extra,
		COUNT(CAST(VALUE AS INT)) times
	FROM CTE_ORDERS
		CROSS APPLY STRING_SPLIT(extras, ',')
	WHERE extras != 'No'
	GROUP BY CAST(VALUE AS INT)
), CTE_ING_AS_EXCL AS (
	/*Ingredientes como exclusiones*/
	SELECT 
		CAST(VALUE AS INT) AS exclusions,
		COUNT(CAST(VALUE AS INT)) times
	FROM CTE_ORDERS
		CROSS APPLY STRING_SPLIT(exclusions, ',')
	WHERE exclusions != 'No'
	GROUP BY CAST(VALUE AS INT)
)
/*Veces que aparece cada ingrediente en las pizzas entregadas*/
SELECT STRING_AGG(A.topping_name, ', ') ingredient,
B.times_used + ISNULL(C.times,0) - ISNULL(D.times,0) times_used
FROM case02.pizza_toppings A
LEFT JOIN CTE_ING_USED B
	ON A.topping_id=B.topping_id
LEFT JOIN CTE_ING_AS_EXTRA C
	ON A.topping_id=C.extra
LEFT JOIN CTE_ING_AS_EXCL D
	ON A.topping_id=D.exclusions
GROUP BY B.times_used,C.times, D.times
ORDER BY times_used DESC;
