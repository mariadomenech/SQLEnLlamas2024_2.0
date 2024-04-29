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
