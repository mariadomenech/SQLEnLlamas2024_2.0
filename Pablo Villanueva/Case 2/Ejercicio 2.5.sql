-- CTE para contar los pedidos exitosos y cancelados por cada runner
WITH order_status AS (
    SELECT
        runner_id,
        order_id,
        CASE
            WHEN cancellation = '' OR cancellation = 'null' OR cancellation IS NULL THEN 1
            ELSE 0
        END AS orders_done,
        CASE
            WHEN cancellation <> '' AND cancellation <> 'null' AND cancellation IS NOT NULL THEN 1
            ELSE 0
        END AS orders_cancelled
    FROM case02.runner_orders
),

-- CTE para contar las pizzas entregadas con éxito por cada runner
pizzas_delivered AS (
    SELECT
        os.runner_id,
        COUNT(co.pizza_id) AS total_pizzas_ok
    FROM order_status os
    JOIN case02.customer_orders co 
        ON os.order_id = co.order_id
    WHERE os.orders_done = 1
    GROUP BY os.runner_id
)

-- Seleccionamos los resultados finales
SELECT
	pt.topping_id,
	Count(*) as topping_veces_usados,
	topping_name
FROM
    order_status os
LEFT JOIN
    pizzas_delivered pd
    ON os.runner_id = pd.runner_id
JOIN case02.customer_orders co 
    ON os.order_id = co.order_id
JOIN [case02].[pizza_recipes_split] pres
	ON pres.pizza_id= co.pizza_id
JOIN 
    case02.pizza_toppings pt ON pt.topping_id IN (pres.topping_1, pres.topping_2, pres.topping_3, pres.topping_4, pres.topping_5, pres.topping_6, pres.topping_7, pres.topping_8)
GROUP BY
    pt.topping_id,topping_name
ORDER BY
    topping_veces_usados DESC;
