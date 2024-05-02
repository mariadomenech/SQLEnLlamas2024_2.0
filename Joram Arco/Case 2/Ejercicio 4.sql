SELECT topping_name
	,COALESCE(COUNT(*),0) AS veces_usado
FROM (
  SELECT topping_name 
	FROM case02.pizza_recipes_split prs 
	JOIN case02.pizza_toppings pt 
		ON prs.topping_1 = pt.topping_id
  UNION ALL
  SELECT topping_name 
	FROM case02.pizza_recipes_split prs 
	JOIN case02.pizza_toppings pt 
		ON prs.topping_2 = pt.topping_id
  UNION ALL
  SELECT topping_name 
	FROM case02.pizza_recipes_split prs 
	JOIN case02.pizza_toppings pt 
		ON prs.topping_3 = pt.topping_id
  UNION ALL
  SELECT topping_name 
	FROM case02.pizza_recipes_split prs 
	JOIN case02.pizza_toppings pt 
		ON prs.topping_4 = pt.topping_id
  UNION ALL
  SELECT topping_name 
	FROM case02.pizza_recipes_split prs 
	JOIN case02.pizza_toppings pt 
		ON prs.topping_5 = pt.topping_id
  UNION ALL
  SELECT topping_name 
	FROM case02.pizza_recipes_split prs 
	JOIN case02.pizza_toppings pt 
		ON prs.topping_6 = pt.topping_id
  UNION ALL
  SELECT topping_name 
	FROM case02.pizza_recipes_split prs 
	JOIN case02.pizza_toppings pt 
		ON prs.topping_7 = pt.topping_id
  UNION ALL
  SELECT topping_name 
	FROM case02.pizza_recipes_split prs 
	JOIN case02.pizza_toppings pt 
		ON prs.topping_8 = pt.topping_id
) AS toppings
GROUP BY topping_name
ORDER BY veces_usado DESC;
/*
Con cada consulta obtenemos los dos ingredientes que tiene cada pizza en ese número de topping. Al unirlos con el UNION ALL, ponemos todos los ingredientes 
resultantes de cada pizza en una sola columna, por lo que ya solo tenemos que generar el count(*) de la lista combinada anterior para comprobar cuántos 
ingredientes se repiten y que nos saque el conteo de cada uno.
*/

/*
UPDATE 1.0
Después de ver varias soluciones he conocido la función UNPIVOT, que viene mucho mejor para dejar en columnas las filas (como trasponer una matriz) y hace que se puedan obtener
los resultados de forma más sencilla  y limpia, por lo que dejo por aquí también un par de resultados más. El primero sería utilizando la función UNPIVOT sobre la tabla
pizza_recipes_split (recomendada para hacer este ejercicio) y el segundo sería otro resultado utilizando la función STRING_SPLIT sobre la tabla pizza_recipes, donde ambas
soluciones darían también la misma respuesta al ejercicio, teniendo estas menos código que la primera solución aportada :)
*/
SELECT
	topping_name
	,COALESCE(COUNT(toppings.topping_id),0) AS veces_usado
FROM case02.pizza_recipes_split prs
UNPIVOT (topping_id FOR topping IN ([topping_1],[topping_2],[topping_3],[topping_4],[topping_5],[topping_6],[topping_7],[topping_8])) AS toppings
JOIN case02.pizza_toppings pt
	ON toppings.topping_id = pt.topping_id
GROUP BY topping_name
ORDER BY veces_usado DESC;

SELECT
	topping_name
	,COALESCE(COUNT(VALUE),0) as veces_usado
FROM case02.pizza_recipes pr
CROSS APPLY STRING_SPLIT(toppings, ',') 
JOIN case02.pizza_toppings pt
	ON value = pt.topping_id
GROUP BY topping_name
ORDER BY veces_usado DESC;
