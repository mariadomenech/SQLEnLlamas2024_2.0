WITH CTE_COUNT_TOPPINGS AS (
	SELECT 
		topping_id,
		COUNT(*) times_used
	FROM (
		SELECT * 
		FROM case02.pizza_recipes_split
		) AS pizza_split
	UNPIVOT (
		topping_id FOR item IN (
				topping_1,
				topping_2,
				topping_3,
				topping_4,
				topping_5,
				topping_6,
				topping_7,
				topping_8
				)
			) unpivote
	GROUP BY topping_id
)
SELECT B.topping_name,
A.times_used
FROM CTE_COUNT_TOPPINGS A
RIGHT JOIN case02.pizza_toppings B
	ON A.topping_id=B.topping_id
ORDER BY A.times_used DESC;
