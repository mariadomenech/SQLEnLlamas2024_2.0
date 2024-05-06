-- RETO 4: ¿Cuántas veces se repite cada topping/ingrediente?

WITH CTE_PIVOTADA
AS (
	SELECT topping_id, 
		COUNT(*) AS repeticiones
	FROM (
		SELECT * 
		FROM case02.pizza_recipes_split
	) AS pizzas_recipes_split  
	UNPIVOT (
		topping_id FOR toppings IN (
			topping_1, 
			topping_2, 
			topping_3, 
			topping_4, 
			topping_5,
			topping_6, 
			topping_7, 
			topping_8
		)  
	) AS tabla_pivotada
	GROUP BY topping_id
)

SELECT topping_name,
	repeticiones
FROM CTE_PIVOTADA CTE
JOIN case02.pizza_toppings AS PT
	ON CTE.topping_id = PT.topping_id
ORDER BY 2 desc


