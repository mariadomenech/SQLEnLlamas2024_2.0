WITH TABLA_INGREDIENTES_TRASPUESTA AS (SELECT
	A.PIZZA_ID, C.TOPPING_NAME
FROM CASE02.PIZZA_RECIPES_SPLIT A
CROSS APPLY (VALUES (TOPPING_1), (TOPPING_2), (TOPPING_3), (TOPPING_4), (TOPPING_5), (TOPPING_6), (TOPPING_7), (TOPPING_8)) AS B(TOPPING_ID)
JOIN CASE02.PIZZA_TOPPINGS C ON B.TOPPING_ID=C.TOPPING_ID)

SELECT
	TOPPING_NAME,
	COUNT(TOPPING_NAME) AS NUM_VECES_USADO
FROM TABLA_INGREDIENTES_TRASPUESTA
GROUP BY TOPPING_NAME;

/*********************************************************/
/***************** COMENTARIO MARÍA  *********************/
/*********************************************************/
/*

Resultado correcto! 
Legibilidad perfecta!
Aunque la idea de este ejercicio era que utilizaseis la funcion UNPIVOT, porque es más genérico y puedes usarlo en otros gestores.
Pero, vamos, ninguna pega.

*/
