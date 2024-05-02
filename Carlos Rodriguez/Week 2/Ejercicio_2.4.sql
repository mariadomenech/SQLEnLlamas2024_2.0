SELECT topping_name,
       COALESCE(COUNT(*), 0) AS veces_usado
FROM (
    SELECT prs.pizza_id, pt.topping_name 
    FROM case02.pizza_recipes_split prs 
    CROSS APPLY (VALUES (topping_1), (topping_2), (topping_3), (topping_4), (topping_5), (topping_6), (topping_7), (topping_8)) AS t(topping_id)
    JOIN case02.pizza_toppings pt ON t.topping_id = pt.topping_id
) AS AllToppings
GROUP BY topping_name
ORDER BY veces_usado DESC;
;
