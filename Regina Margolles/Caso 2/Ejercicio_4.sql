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
