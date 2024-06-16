-- CTE para contar los pedidos exitosos y cancelados por cada runner
WITH order_status AS (
    SELECT
        runner_id,
        order_id,
        CASE
            WHEN cancellation = '' OR cancellation = 'null' OR cancellation IS NULL THEN 1
            ELSE 0
        END AS orders_done
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
),

-- CTE para contar los ingredientes usados en pizzas entregadas con éxito
ingredient_usage AS (
    SELECT
        pt.topping_id,
        pt.topping_name,
        COUNT(*) AS veces_usado
    FROM order_status os
    JOIN case02.customer_orders co
        ON os.order_id = co.order_id
    JOIN case02.pizza_recipes_split prs
        ON prs.pizza_id = co.pizza_id
    JOIN case02.pizza_toppings pt
        ON pt.topping_id IN (prs.topping_1, prs.topping_2, prs.topping_3, prs.topping_4, prs.topping_5, prs.topping_6, prs.topping_7, prs.topping_8)
    WHERE os.orders_done = 1
    GROUP BY pt.topping_id, pt.topping_name
),

-- CTE para contar los ingredientes adicionales
ing_extras AS (
    SELECT 
        pt.topping_id,
        pt.topping_name,
        COUNT(1) AS veces_extras
    FROM case02.customer_orders co
    CROSS APPLY STRING_SPLIT(co.extras, ',') AS extra
    JOIN case02.pizza_toppings pt ON TRY_CAST(extra.value AS INT) = pt.topping_id
    WHERE co.order_id NOT IN (
        SELECT order_id FROM case02.runner_orders WHERE UPPER(cancellation) LIKE '%CANCELLATION%'
    )
    GROUP BY pt.topping_id, pt.topping_name
),

-- CTE para contar las exclusiones de ingredientes
ing_exclusions AS (
    SELECT 
        pt.topping_id,
        pt.topping_name,
        COUNT(1) AS veces_exclusions
    FROM case02.customer_orders co
    CROSS APPLY STRING_SPLIT(co.exclusions, ',') AS exclusion
    JOIN case02.pizza_toppings pt ON TRY_CAST(exclusion.value AS INT) = pt.topping_id
    WHERE co.order_id NOT IN (
        SELECT order_id FROM case02.runner_orders WHERE UPPER(cancellation) LIKE '%CANCELLATION%'
    )
    GROUP BY pt.topping_id, pt.topping_name
),

-- CTE para sumar los ingredientes usados, extras y restar las exclusiones
ing_total AS (
    SELECT 
        pt.topping_id,
        pt.topping_name,
        COALESCE(iu.veces_usado, 0) + COALESCE(ie.veces_extras, 0) - COALESCE(ix.veces_exclusions, 0) AS num_ingredientes_gen
    FROM case02.pizza_toppings pt
    LEFT JOIN ingredient_usage iu ON pt.topping_id = iu.topping_id
    LEFT JOIN ing_extras ie ON pt.topping_id = ie.topping_id
    LEFT JOIN ing_exclusions ix ON pt.topping_id = ix.topping_id
)

-- Seleccionamos los resultados finales
SELECT
    RANK() OVER (ORDER BY num_ingredientes_gen DESC) AS ranking,
    num_ingredientes_gen,
    STRING_AGG(topping_name, ', ') AS ingredientes
FROM ing_total
GROUP BY num_ingredientes_gen
ORDER BY ranking;


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

RESULTADO: Correcto.
CÓDIGO: Correcto.
LEGIBILIDAD: Correcta.

Todo perfecto! Me ha gustado mucho cómo has ido construyendo la solución con distintas CTEs para
hacerlo más legible.

Genial cómo muestras la salida generando una lista con STRING_AGG para cada conteo de uso de 
los toppings. 

Estupenda solución!


*/
