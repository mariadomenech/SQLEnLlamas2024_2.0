/* Pariendo de la receta de cada una de las pizzas de la tabla pizza_recipes_split, 
¿cuántes veces se repite cada topping/ingrediente?
Si la pizza meatlover y la vegetariana llevan queso, el ingrediente queso se repite 2 veces.
*/
SELECT topp.topping_name AS des_name_topping
	-- Todos los ingredientes son utilizados, pero por asegurar lo correcto es control de nulos
	, COALESCE (repe.num_repeticion_ingrediente, 0) AS num_repeticion_ingrediente
FROM SQL_EN_LLAMAS_ALUMNOS.case02.pizza_toppings topp
LEFT JOIN 
(
	SELECT topping_id, count(*) AS num_repeticion_ingrediente
	FROM 
	(   SELECT pizza_id, topping_1, topping_2, topping_3, topping_4, topping_5, topping_6, topping_7, topping_8
		  FROM SQL_EN_LLAMAS_ALUMNOS.case02.pizza_recipes_split
	) AS base
	UNPIVOT 
	(
		topping_id FOR Categoria IN (topping_1, topping_2, topping_3, topping_4, topping_5, topping_6, topping_7, topping_8)
	) AS unpvt
	GROUP BY topping_id
) repe
ON  topp.topping_id  = repe.topping_id
ORDER BY 2 DESC;
