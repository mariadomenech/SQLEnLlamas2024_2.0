select  p.topping_name, COUNT (id_topping) as veces_usado
from
(
		select * 
		from case02.pizza_recipes_split
		unpivot
		(
		   id_topping
			for [topping] in ([topping_1],[topping_2],[topping_3],[topping_4],[topping_5],[topping_6],[topping_7],[topping_8])
		) as p

) as t

 left join case02.pizza_toppings as p
 	on id_topping = p.topping_id

group by id_topping, p.topping_name
order by veces_usado desc;


/*********************************************************/
/***************** COMENTARIO MARÍA  *********************/
/*********************************************************/
/*

Resultado correcto! 
Legibilidad perfecta!
La idea de este ejercicio era que utilizáseis la funcion UNPIVOT, porque es más genérico y puedes usarlo en otros gestores.
Perfecto!

Si es verdad, que en la línea 14, haríamos un RIGHT JOIN porque la tabla de toppings es una tabla de dimensiones de la receta. 
Puede haber más toppings en la tabla de toppings que los comentados en la tabla de recetas.

*/

/*********************************************************/
/***************** CORRECIÓN *********************/
/*********************************************************/


select  p.topping_name, COUNT (id_topping) as veces_usado
from
(
		select * 
		from case02.pizza_recipes_split
		unpivot
		(
		   id_topping
			for [topping] in ([topping_1],[topping_2],[topping_3],[topping_4],[topping_5],[topping_6],[topping_7],[topping_8])
		) as p

) as t

 right join case02.pizza_toppings as p
 	on id_topping = p.topping_id

group by id_topping, p.topping_name
order by veces_usado desc;
