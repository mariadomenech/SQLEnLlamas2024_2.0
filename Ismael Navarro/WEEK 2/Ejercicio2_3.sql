WITH PizzaCost AS (
    -- Coste pizzas sin extras de cada pedido.
    SELECT 
        ord.order_id,
        SUM(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) AS base_pizza_cost
    FROM case02.customer_orders ord
    GROUP BY ord.order_id
),
ExtraIngredients AS (
    -- Se obtienen los extras de cada pedido
    SELECT 
        order_id,
        SUM(CASE 
            WHEN (extras IS NULL OR extras = 'null' OR extras = '') THEN 0 
            ELSE LEN(extras) - LEN(REPLACE(extras, ',', '')) + 1 
        END) AS extra_ingredients_count
    FROM case02.customer_orders
    GROUP BY order_id
),
OrderCost AS (
    -- Se obtiene el coste del pedido del cliente.
    SELECT 
        p.order_id,
        p.base_pizza_cost + e.extra_ingredients_count AS total_order_cost
    FROM PizzaCost p
    INNER JOIN ExtraIngredients e ON p.order_id = e.order_id
),
RunnerCosts AS (
    -- Se calcula el coste del reparto
    SELECT 
        order_id,
        (CAST(CASE 
            WHEN (distance IS NULL OR distance = 'null') THEN '0'
            ELSE REPLACE(distance, 'km', '') 
        END AS DECIMAL(3,1)))*0.3 AS delivery_cost
    FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders
    WHERE (CASE 
        WHEN (cancellation IS NULL OR cancellation = 'null' OR cancellation = '') THEN 0 
        ELSE 1 
    END) = 0
)
SELECT 
    SUM(pc.total_order_cost) AS total_order_revenue,
    SUM(pc.total_order_cost) - SUM(rc.delivery_cost) AS net_profit_Guiseppe,
    SUM(rc.delivery_cost) AS total_delivery_costs,
    SUM(ei.extra_ingredients_count) AS total_extra_ingredients
FROM OrderCost pc
INNER JOIN RunnerCosts rc ON rc.order_id = pc.order_id
INNER JOIN ExtraIngredients ei ON ei.order_id = pc.order_id;
