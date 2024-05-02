WITH filtro AS (
    SELECT  
        ro.order_id,
        ro.runner_id,
        CASE pn.pizza_id
            WHEN 1 THEN 12
            ELSE 10
        END precio,
        CASE co.extras
            WHEN ' ' THEN 0
            WHEN 'null' THEN 0
            ELSE 1
        END AS extras,
        COALESCE(CAST(LEFT(ro.distance, PATINDEX('%[^0-9.]%', ro.distance + ' ') - 1) AS FLOAT), 0) * 0.30 AS ganancia_runner
    FROM case02.runner_orders ro
    LEFT JOIN case02.customer_orders co ON ro.order_id = co.order_id
    LEFT JOIN case02.pizza_names pn ON co.pizza_id = pn.pizza_id
    WHERE ro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
)
SELECT 
    COUNT(DISTINCT order_id) AS pedidos,
    SUM(extras) AS extras,
    SUM((precio + extras) - ganancia_runner) AS Ganancias
FROM filtro;
