SELECT 
    pt.topping_name,
    COALESCE(COUNT(*), 0) AS veces_usado
FROM 
    case02.pizza_recipes_split prs
JOIN 
    case02.pizza_toppings pt ON pt.topping_id IN (prs.topping_1, prs.topping_2, prs.topping_3, prs.topping_4, prs.topping_5, prs.topping_6, prs.topping_7, prs.topping_8)
GROUP BY 
    pt.topping_name
ORDER BY 
    veces_usado DESC;


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Genial, lo has hecho super simple, justo lo esperado!

RESULTADO: Correcto
CÓDIGO: Correcto.
LEGIBILIDAD: Perfecta.


*/
