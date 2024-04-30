-- Primero, creamos una tabla con todos los toppings de todas las pizzas
WITH AllToppings AS (
    SELECT prs.pizza_id, pt.topping_name 
    FROM case02.pizza_recipes_split prs 
-- La función CROSS APPLY con VALUES permite tratar cada topping como una fila separada de la consulta, lo que facilita el conteo de cuántas veces se utiliza cada topping
    CROSS APPLY (VALUES (topping_1), (topping_2), (topping_3), (topping_4), (topping_5), (topping_6), (topping_7), (topping_8)) AS t(topping_id)
    JOIN case02.pizza_toppings pt ON t.topping_id = pt.topping_id
)
-- Luego, realizamos la consulta en la tabla AllToppings
SELECT topping_name
    ,COALESCE(COUNT(*),0) AS times_used
FROM AllToppings
GROUP BY topping_name
ORDER BY times_used DESC;

select* from case02.pizza_recipes_split


/***************************************************/
/***************COMENTARIO DANI*********************/
/***************************************************/
/* Resultado correcto!. Simple y sencillo, buen uso del CROSS_APPLY. 
A destacar te diría el JOIN, intentemos enfocarlo con un JOIN mas 
específico, eso nos evitará problemas de rendimiento en caso de que 
la tabla o tablas contengan mas datos de los que pensamos. Ánimo Ismael,
la queryPower te invade poco a poco*/
