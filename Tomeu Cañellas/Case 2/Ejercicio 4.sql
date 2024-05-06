--CASO 2: Ejercicio 4
--Seleccionamos el nombre del topping y la cuenta de las veces que se repite en las pizzas
SELECT pizza_toppings.topping_name, COUNT(*) AS repeat_count
FROM (
    --Ordenamos los toppings en columnas, conservando el id de pizza a la que pertenecen
    SELECT pizza_id, topping_1 AS ingredient FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_recipes_split]
    UNION ALL
    SELECT pizza_id, topping_2 FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_recipes_split]
    UNION ALL
    SELECT pizza_id, topping_3 FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_recipes_split]
    UNION ALL
    SELECT pizza_id, topping_4 FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_recipes_split]
    UNION ALL
    SELECT pizza_id, topping_5 FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_recipes_split]
    UNION ALL
    SELECT pizza_id, topping_6 FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_recipes_split]
    UNION ALL
    SELECT pizza_id, topping_7 FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_recipes_split]
    UNION ALL
    SELECT pizza_id, topping_8 FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_recipes_split]
) AS pizza_ingredients
--Realizamos un INNER JOIN con la tabla de toppings para cruzar y obtener los nombres de los toppings
INNER JOIN [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_toppings] pizza_toppings
	ON pizza_ingredients.ingredient = pizza_toppings.topping_id
--Agrupamos por topping y ordenamos por su cuenta de forma descendente
GROUP BY pizza_toppings.topping_name
ORDER BY 2 DESC;

/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Tengo que decirte que me ha sorprendido la solución, no me la esperaba jajaja, no es la más elegante pero es 
igualmente válida. Se podría haber hecho uso de CTEs con UNPIVOT o CROSS APPLY por ejemplo para un código más
"moderno" pero sigue siendo válida. Esta tarde añado alguna solución usando esos ejemplos por si le quieres echar
un vistazo. ;)

*/
