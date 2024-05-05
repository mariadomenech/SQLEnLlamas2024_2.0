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


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Resultado parcialmente correcto David!

Resultado y código: El porcentaje de pizzas con cambios no es correcto. El fallo estaría en el cálculo de las pizzas con cambios y en el divisor al hacer el porcentaje.
        Te dejo una manera de hacerlo:

WITH Order_good AS (
    SELECT 
        ro.runner_id,
        ro.order_id,
        CASE 
            WHEN ro.cancellation = 'Restaurant Cancellation' THEN 0
            WHEN ro.cancellation = 'Customer Cancellation' THEN 0
            ELSE 1
        END AS fin
    FROM case02.runner_orders ro
),
Sum_order AS (
    SELECT 
        og.runner_id,
        SUM(og.fin) AS total_successful_orders,
        COUNT(og.order_id) AS total_orders
    FROM Order_good og
    GROUP BY og.runner_id
),
Porcent_ex_pizza AS (
    SELECT 
        so.runner_id,
        so.total_successful_orders,
        so.total_orders,
        CASE 
            WHEN so.total_orders = 0 THEN 0
            ELSE (CAST(so.total_successful_orders AS FLOAT) / so.total_orders) * 100
        END AS delivered_orders_percentage
    FROM Sum_order so
),
Clean_pizza AS (
    SELECT 
        co.order_id,
        CASE 
            WHEN  co.exclusions IS NULL OR co.exclusions ='null' OR co.exclusions = ''  THEN 0
            ELSE 1
        END AS has_exclusions,
        CASE 
            WHEN co.extras IS NULL OR co.extras = 'null' OR  co.extras = '' THEN 0
            ELSE 1
        END AS has_extras
    FROM case02.customer_orders co
),
Count_pizza_camb AS (
    SELECT 
        og.runner_id,
        COUNT(*) AS total_altered_pizzas
    FROM Clean_pizza cp
    INNER JOIN Order_good og ON cp.order_id = og.order_id
    WHERE (cp.has_exclusions = 1 OR cp.has_extras = 1) AND og.fin = 1
    GROUP BY og.runner_id
),
Count_pizza AS (
    SELECT 
        og.runner_id,
        COUNT(cp.order_id) AS total_pizzas
    FROM Clean_pizza cp
    INNER JOIN Order_good og ON cp.order_id = og.order_id
    WHERE og.fin = 1
    GROUP BY og.runner_id
),
Porcent_camb_pizza AS (
    SELECT 
        cp.runner_id,
        CASE 
            WHEN cp.total_pizzas = 0 THEN 0
            ELSE (CAST(cpc.total_altered_pizzas AS FLOAT) / cp.total_pizzas) * 100
        END AS altered_pizzas_percentage
    FROM Count_pizza cp
    LEFT JOIN Count_pizza_camb cpc ON cp.runner_id = cpc.runner_id
)

SELECT 
    px.runner_id,
    px.total_successful_orders,
    px.delivered_orders_percentage,
    cp.total_pizzas,
    pc.altered_pizzas_percentage,
   cpc.total_altered_pizzas
FROM Porcent_ex_pizza px
LEFT JOIN Porcent_camb_pizza pc ON px.runner_id = pc.runner_id
LEFT JOIN Count_pizza cp ON pc.runner_id = cp.runner_id
LEFT JOIN Count_pizza_camb cpc ON cp.runner_id = cpc.runner_id
ORDER BY px.runner_id;

Código: OK

Legibilidad: OK.

Fuerza y a seguir practicando!!

*/
