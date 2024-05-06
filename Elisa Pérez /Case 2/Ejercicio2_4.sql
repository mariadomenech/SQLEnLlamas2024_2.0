SELECT	PT.topping_name, COUNT(*) AS num_ingredientes
FROM case02.pizza_recipes_split PR
JOIN case02.pizza_toppings PT
ON	PT.topping_id = PR.topping_1
	OR PT.topping_id = PR.topping_2
	OR PT.topping_id = PR.topping_3
	OR PT.topping_id = PR.topping_4
	OR PT.topping_id = PR.topping_5
	OR PT.topping_id = PR.topping_6
	OR PT.topping_id = PR.topping_7
	OR PT.topping_id = PR.topping_8
GROUP BY PT.topping_name
