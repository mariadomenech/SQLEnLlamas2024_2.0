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
	COALESCE(repeticiones,0)
FROM CTE_PIVOTADA CTE
RIGHT JOIN case02.pizza_toppings AS PT
	ON CTE.topping_id = PT.topping_id
ORDER BY 2 desc

-- Aunque en este caso, los topping_ids de la tabla de hechos coinciden con la dimensión, se tiene en cuenta obtener todos los de la dimensión por si no siempre 
-- ocurriera esa casuística así como el tratamiento de los valores nulos.


/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Está perfecto. Solución correcta, limpia y usando el UNPIVOT que era lo que se pretendía como solución más "elegante", así que nada que añadir :)

*/
