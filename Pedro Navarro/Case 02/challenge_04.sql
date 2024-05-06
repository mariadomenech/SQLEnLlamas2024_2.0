-- RETO 4. PARTIENDO DE LA RECETA DE CADA UNA DE LAS PIZZAS DE LA TABLA PIZZA-RECIPES_SPLIT,
-- ¿CUÁNTAS VECES SE REPITE CADA TOPPING/INGREDIENTE. SI LA PIZZA MEATLOVER Y LA VEGETARIANA
-- LLEVAN QUESO, EL INGREDIENTE QUESO SE REPITE 2 VECES.
;WITH
	UNPIVOTED_PIZZA_RECIPES AS (
		SELECT
			pizza_id
			,topping
			,topping_id
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.pizza_recipes_split AS pvt
		UNPIVOT
			(topping_id FOR topping IN
				(topping_1, topping_2, topping_3, topping_4, topping_5, topping_6, topping_7, topping_8)
			) AS unpvt
	)

	,REPEATED_TOPPINGS AS (
		SELECT
			topping_id
			,COUNT(*) AS number_of_times_used
		FROM UNPIVOTED_PIZZA_RECIPES
		GROUP BY topping_id
	)

	,REPEATED_TOTAL_TOPPINGS AS (
		SELECT
			t.topping_name
			,ISNULL(rt.number_of_times_used, 0) AS number_of_times_used
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.pizza_toppings AS t
		LEFT JOIN REPEATED_TOPPINGS AS rt
			ON t.topping_id = rt.topping_id
	)

SELECT *
FROM REPEATED_TOTAL_TOPPINGS;


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

RESULTADO: Correcto
CÓDIGO: Correcto.
LEGIBILIDAD: Perfecta.

Perfecto Pedro, es justo lo que se esperaba!
*/
