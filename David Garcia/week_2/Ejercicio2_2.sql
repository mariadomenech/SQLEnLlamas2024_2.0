WITH Order_good AS (
    SELECT 
        runner_id,
        order_id,
        CASE cancellation
            WHEN 'Restaurant Cancellation' THEN 0
            WHEN 'Customer Cancellation' THEN 0
            ELSE 1
        END AS Fin
    FROM case02.runner_orders
),

Sum_order AS (
    SELECT 
        runner_id,
        CAST(SUM(Fin) AS FLOAT) AS pizzas_entregadas,
        CAST(COUNT(order_id) AS FLOAT) AS pedidos_realizados
    FROM Order_good
    GROUP BY runner_id
),
Porcent_ex_pizza AS (
    SELECT 
        runner_id,
        pizzas_entregadas,
        pedidos_realizados,
        (pizzas_entregadas / pedidos_realizados) * 100 AS Porcent_entrega_Pizza
    FROM Sum_order
),

Clean_pizza AS (
    SELECT 
        order_id,
        CASE exclusions
            WHEN ' ' THEN 0
            WHEN 'null' THEN 0
            ELSE 1
        END AS exclusions,
        CASE extras
            WHEN ' ' THEN 0
            WHEN 'null' THEN 0
            ELSE 1
        END AS extras
    FROM case02.customer_orders
),

Count_pizza_camb AS (
    SELECT 
        runner_id,
        COUNT(DISTINCT(cp.order_id)) AS pizza_cambios
    FROM Clean_pizza cp
    LEFT JOIN Order_good og ON cp.order_id = og.order_id
    WHERE (exclusions = 1 AND extras = 0) OR (exclusions = 0 AND extras = 1) OR (exclusions = 1 AND extras = 1) AND fin = 1
    GROUP BY runner_id
),

Count_pizza AS (
    SELECT 
        runner_id,
        COUNT(cp.order_id) AS numero_pizzas
    FROM Clean_pizza cp
    LEFT JOIN Order_good og ON cp.order_id = og.order_id
    WHERE fin = 1
    GROUP BY runner_id
),

Porcent_camb_pizza AS (
    SELECT 
        og.runner_id,
        ROUND((pizza_cambios / pizzas_entregadas) * 100, 3) AS Porcent_cambios_pizza
    FROM Count_pizza_camb cp
    LEFT JOIN Sum_order og ON cp.runner_id = og.runner_id
    LEFT JOIN Count_pizza cp1 ON cp.runner_id = cp1.runner_id
)

SELECT 
    px.runner_id,
    pizzas_entregadas,
    Porcent_entrega_Pizza,
    numero_pizzas,
    Porcent_cambios_pizza
FROM Porcent_ex_pizza px
LEFT JOIN Porcent_camb_pizza pc ON px.runner_id = pc.runner_id
LEFT JOIN Count_pizza cp ON pc.runner_id = cp.runner_id;
