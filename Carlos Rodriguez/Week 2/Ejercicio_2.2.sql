-- Primero, calculamos los pedidos exitosos y las pizzas exitosas y modificadas para cada runner_id
WITH pedidos_exitosos AS (
    SELECT 
        r.runner_id,
        -- Contamos los pedidos exitosos
        COUNT(DISTINCT a.order_id) AS num_pedidos_ok,
        -- Sumamos las pizzas exitosas
        SUM(CASE WHEN b.pizza_id IS NOT NULL THEN 1 ELSE 0 END) AS num_pizzas_ok,
        -- Sumamos las pizzas modificadas
        SUM(CASE WHEN b.pizza_id IS NOT NULL AND (COALESCE(b.exclusions ,'') NOT IN ( '', 'null') OR COALESCE(b.extras ,'') NOT IN ( '', 'null')) THEN 1 ELSE 0 END) AS pizza_con_modificaciones
    FROM 
        CASE02.runners r
        LEFT JOIN CASE02.runner_orders a ON a.runner_id = r.runner_id AND coalesce(a.cancellation,'') NOT LIKE '%cancellation%'
        LEFT JOIN case02.customer_orders b ON a.order_id = b.order_id
    GROUP BY r.runner_id
),
-- Luego, calculamos el total de pedidos y pizzas para cada runner_id
total_pedidos AS (
    SELECT 
        r.runner_id,
        -- Contamos el total de pedidos
        COUNT(DISTINCT a.order_id) AS total_pedidos,
        -- Contamos el total de pizzas
        COUNT(b.pizza_id) AS total_pizzas
    FROM 
        CASE02.runners r
        LEFT JOIN CASE02.runner_orders a ON a.runner_id = r.runner_id
        LEFT JOIN case02.customer_orders b ON a.order_id = b.order_id
    GROUP BY r.runner_id
)
-- Finalmente, calculamos los porcentajes de éxito y modificación para cada runner_id
SELECT 
    p.runner_id,
    p.num_pedidos_ok,
    p.num_pizzas_ok,
    -- Calculamos el porcentaje de pedidos exitosos
    CAST(CASE WHEN t.total_pedidos = 0 THEN 0 ELSE p.num_pedidos_ok * 100.0 / t.total_pedidos END AS DECIMAL(16,2)) AS PCT_Pedidos_ok,
    -- Calculamos el porcentaje de pizzas modificadas
    CAST(CASE WHEN p.num_pizzas_ok = 0 THEN 0 ELSE p.pizza_con_modificaciones * 100.0 / p.num_pizzas_ok END AS DECIMAL(16,2)) AS PCT_Pizzas_ok_mod
FROM 
    pedidos_exitosos p
    JOIN total_pedidos t ON p.runner_id = t.runner_id
ORDER BY p.runner_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto!

*/
