
-- CTE para obtener el número de ingredientes extra por pizza
WITH ingredientes_extra AS (
    SELECT 
        pizza_id,
        SUM(CASE 
                WHEN value <> 'null' AND value <> '' THEN 1
                ELSE 0
            END) AS n_ingredientes
    FROM 
        case02.customer_orders cust_orders
    CROSS APPLY 
        STRING_SPLIT(extras, ',')
    JOIN 
        case02.runner_orders runners_orders 
    ON 
        runners_orders.order_id = cust_orders.order_id
    WHERE 
        runners_orders.duration <> 'null'
    GROUP BY 
        pizza_id
),

-- CTE para obtener el desglose de pizzas, su precio y el número de ingredientes extra
desglose_pizzas AS (
    SELECT 
        cust_orders_2.pizza_id AS pizza,
        COUNT(cust_orders_2.pizza_id) AS n_pizzas,
        MAX(ingredientes_extra.n_ingredientes) AS n_ingredientes,
        CASE 
            WHEN cust_orders_2.pizza_id = 1 THEN 12
            ELSE 10
        END AS precio_unitario,
        CASE 
            WHEN cust_orders_2.pizza_id = 1 THEN 12
            ELSE 10
        END * COUNT(cust_orders_2.pizza_id) AS precio_total_pizzas
    FROM 
        case02.customer_orders cust_orders_2
    JOIN 
        ingredientes_extra  
    ON 
        cust_orders_2.pizza_id = ingredientes_extra.pizza_id
    JOIN 
        case02.runner_orders runners_orders_2 
    ON 
        runners_orders_2.order_id = cust_orders_2.order_id
    WHERE 
        runners_orders_2.duration <> 'null'
    GROUP BY 
        cust_orders_2.pizza_id
)

-- Consulta final para calcular los ingresos y costes
SELECT 
    SUM(desglose_pizzas.precio_total_pizzas) AS ing_pizzas,
    SUM(desglose_pizzas.n_ingredientes) AS ing_ingredientes_extra,
    COALESCE(
        (SELECT SUM(CAST([case02].GetNumbers(runners_orders_3.distance) AS FLOAT)) * 0.3
        FROM case02.runner_orders runners_orders_3), 0
    ) AS costes
FROM 
    desglose_pizzas;



/*********************************************************/
/***************** COMENTARIO MANU *********************/
/*********************************************************/
/*

Todo perfecto!

RESULTADO: OK
CÓDIGO: OK
LEGIBILIDAD: OK


*/
