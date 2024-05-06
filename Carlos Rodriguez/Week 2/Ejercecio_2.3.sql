SELECT 
    SUM(desglose_pizzas.precio_total_pizzas) AS ing_pizzas,
    SUM(desglose_pizzas.n_ingredientes) AS ing_ingredientes_extra,
    (
        SELECT COALESCE(SUM(CAST([case02].GetNumbers(runners_orders_3.distance) AS FLOAT)), 0)
        FROM case02.runner_orders runners_orders_3
    ) * 0.3 AS costes
FROM (
    SELECT 
        cust_orders_2.pizza_id AS pizza,
        COUNT(cust_orders_2.pizza_id) AS n_pizzas,
        MAX(pizzas_ingredientes.n_ingredientes) AS n_ingredientes,
        CASE 
            WHEN cust_orders_2.pizza_id = 1 THEN 12
            ELSE 10
        END AS precio_unitario,
        (
            CASE 
                WHEN cust_orders_2.pizza_id = 1 THEN 12
                ELSE 10
            END
        ) * COUNT(cust_orders_2.pizza_id) AS precio_total_pizzas
    FROM 
        case02.customer_orders cust_orders_2
    JOIN (
        SELECT 
            pizza_id,
            SUM(
                CASE 
                    WHEN value <> 'null' AND value <> '' THEN 1
                    ELSE 0
                END
            ) AS n_ingredientes
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
    ) AS pizzas_ingredientes 
    ON 
        cust_orders_2.pizza_id = pizzas_ingredientes.pizza_id
    JOIN 
        case02.runner_orders runners_orders_2 
    ON 
        runners_orders_2.order_id = cust_orders_2.order_id
    WHERE 
        runners_orders_2.duration <> 'null'
    GROUP BY 
        cust_orders_2.pizza_id
) AS desglose_pizzas;
;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Faltaría añadir el beneficio final, entiendo que se debe a que utilizas la app y en ella no aparece, asi que culpa nuestra :(

Por otro lado, de cara a la legibilidad del código, evitaría introducir retornos de carro despues de cada from/join/on ya que estira el código y dificulta un poco su lectura.

*/
