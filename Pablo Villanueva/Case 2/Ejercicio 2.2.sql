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

-- CTE para obtener información sobre las pizzas y sus modificaciones
pizza_modifications AS (
    SELECT
        order_id,
        pizza_id,
        CASE
            WHEN exclusions = '' OR exclusions = 'null' OR exclusions IS NULL THEN 0
            ELSE 1
        END AS has_exclusions,
        CASE
            WHEN extras = '' OR extras = 'null' OR extras IS NULL THEN 0
            ELSE 1
        END AS has_extras
    FROM case02.customer_orders
),

-- CTE para contar las pizzas entregadas con éxito por cada runner
pizzas_delivered AS (
    SELECT
        os.runner_id,
        COUNT(pm.pizza_id) AS total_pizzas_ok
    FROM order_status os
    JOIN pizza_modifications pm ON os.order_id = pm.order_id
    WHERE os.orders_done = 1
    GROUP BY os.runner_id
),

-- CTE para contar las pizzas entregadas con modificaciones por cada runner
pizzas_with_mods AS (
    SELECT
        os.runner_id,
        COUNT(pm.pizza_id) AS total_pizzas_modificadas
    FROM order_status os
    JOIN pizza_modifications pm ON os.order_id = pm.order_id
    WHERE os.orders_done = 1 AND (pm.has_exclusions = 1 OR pm.has_extras = 1)
    GROUP BY os.runner_id
)

-- Consulta final para obtener los resultados requeridos
SELECT
    r.runner_id,
    ISNULL(SUM(CASE WHEN os.orders_done = 1 THEN 1 ELSE 0 END), 0) AS num_pedidos_ok,
    ISNULL(pd.total_pizzas_ok, 0) AS num_pizzas_ok,
    ISNULL(ROUND((SUM(CASE WHEN os.orders_done = 1 THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(os.order_id), 0), 2), 0) AS pct_pedidos_ok,
    ISNULL(ROUND((pwm.total_pizzas_modificadas * 100.0) / NULLIF(pd.total_pizzas_ok, 0), 2), 0) AS pct_pizzas_ok_mod
FROM case02.runners r
LEFT JOIN order_status os ON r.runner_id = os.runner_id
LEFT JOIN pizzas_delivered pd ON r.runner_id = pd.runner_id
LEFT JOIN pizzas_with_mods pwm ON r.runner_id = pwm.runner_id
GROUP BY r.runner_id, pd.total_pizzas_ok, pwm.total_pizzas_modificadas
ORDER BY r.runner_id;
