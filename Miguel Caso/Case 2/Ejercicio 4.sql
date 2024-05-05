/* Partiendo de las recetas de PIZZA_RECIPES_SPLIT, ¿cuántas veces se repite cada ingrediente? */

WITH recipes_unsplit AS (	
	SELECT
		prs.pizza_id,
		CONCAT_WS(',', prs.topping_1, prs.topping_2, prs.topping_3, prs.topping_4, prs.topping_5, prs.topping_6, prs.topping_7, prs.topping_8) AS topping
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.PIZZA_RECIPES_SPLIT prs),

cuenta_ingredientes AS (
	SELECT
		pizza_id,
		TRIM (value) AS topping
	FROM recipes_unsplit ru
		CROSS APPLY string_split(ru.topping, ','))

SELECT
	pt.topping_name,
	COUNT (ci.topping) AS num_repeticiones
FROM SQL_EN_LLAMAS_ALUMNOS.case02.pizza_toppings pt
	JOIN cuenta_ingredientes ci ON pt.topping_id = ci.topping
	GROUP BY pt.topping_name
	ORDER BY COUNT (ci.topping) DESC;


/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*
RESULTADO: Correcto.
CÓDIGO: Correcto.
LEGIBILIDAD: Correcto. Muy fácil de entender cómo estás haciendo el código.

Perfect!!!

*/
