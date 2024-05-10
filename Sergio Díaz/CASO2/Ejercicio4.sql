/* Alumno: Sergio Díaz */
/* CASO 2 - Ejercicio 4: Veces que se repite cada topping */

--CTE para despivotar la tabla de pizza_recipes
WITH pizza_recipes_unpivot (
	PIZZA_ID
	,TOPPING_ID
	)
AS (
	SELECT pizza_id
		,topping_id
	FROM (
		SELECT *
		FROM case02.pizza_recipes_split
		) toppings
	UNPIVOT(topping_id FOR Topping IN (
				topping_1
				,topping_2
				,topping_3
				,topping_4
				,topping_5
				,topping_6
				,topping_7
				,topping_8
				)) AS unpvt
	)

-- Query para solucionar el ejercicio	
SELECT toppings.topping_name AS NOMBRE_INGREDIENTE
	,COALESCE(COUNT(recipes.topping_id), 0) AS N_VECES_REPETIDO --Formateo del número de salida
FROM case02.pizza_toppings toppings
LEFT JOIN pizza_recipes_unpivot recipes  --Left join para mostrar todos los ingredientes
ON toppings.topping_id = recipes.topping_id
GROUP BY toppings.topping_name
ORDER BY N_VECES_REPETIDO DESC --Ordenamos para mostrar los ingredientes más repetidos primero
