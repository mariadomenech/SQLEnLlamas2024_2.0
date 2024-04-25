WITH OrdersCleaned AS (
    SELECT 
        runner_id,
        order_id,
        IIF(pickup_time = 'null', NULL, CAST(pickup_time AS DATETIME)) AS pickup_time,
        COALESCE(CAST(SUBSTRING(distance, 1, PATINDEX('%[^0-9.]%', distance + 'a') - 1) AS FLOAT), 0) as cleaned_distance,
        COALESCE(CAST(SUBSTRING(duration, 1, PATINDEX('%[^0-9.]%', duration + 'a') - 1) AS FLOAT)/60, 0) as cleaned_duration,
        IIF(cancellation IN ('', 'null'), NULL, cancellation) AS cancellation
    FROM case02.runner_orders
),
CompletedOrders AS (
    SELECT
        runner_id,
        order_id
    FROM OrdersCleaned
    WHERE cancellation IS NULL
),
OrdersWithDetails AS (
    SELECT
        order_id,
        customer_id,
        pizza_id,
        CASE WHEN exclusions IN ('', 'null') THEN NULL ELSE exclusions END AS exclusions,
        CASE WHEN extras IN ('', 'null') THEN NULL ELSE extras END AS extras,
        order_time
    FROM case02.customer_orders
),
OrderAndPizzaCounts AS (
    SELECT
        co.runner_id,
        COUNT(DISTINCT co.order_id) as total_successful_orders,
        COUNT(*) as total_successful_pizzas
    FROM CompletedOrders AS co
    LEFT JOIN OrdersWithDetails AS od
        ON co.order_id = od.order_id
    GROUP BY co.runner_id
),
OrderSuccessRate AS (
    SELECT
        oc.runner_id,
        100.00*COUNT(co.order_id)/COUNT(oc.order_id) AS successful_orders_percentage
    FROM OrdersCleaned AS oc
    LEFT JOIN CompletedOrders AS co
        ON oc.order_id = co.order_id
    GROUP BY oc.runner_id
),
AlteredPizzaRate AS (
    SELECT
        co.runner_id,
        COUNT(*) AS total_successful_altered_pizzas
    FROM CompletedOrders AS co
    LEFT JOIN OrdersWithDetails AS od
        ON co.order_id = od.order_id
    WHERE od.exclusions IS NOT NULL OR od.extras IS NOT NULL
    GROUP BY co.runner_id
),
FinalResult AS (
    SELECT
        r.runner_id,
        COALESCE(opc.total_successful_orders, 0) AS total_successful_orders,
        COALESCE(opc.total_successful_pizzas, 0) AS total_successful_pizzas,
        FORMAT(COALESCE(osr.successful_orders_percentage, 0), 'N1') AS delivered_orders_percentage,
        FORMAT(COALESCE(100.00*apr.total_successful_altered_pizzas/opc.total_successful_pizzas, 0), 'N1') AS delivered_altered_pizzas_percentage
    FROM case02.runners AS r
    LEFT JOIN OrderAndPizzaCounts AS opc
        ON r.runner_id = opc.runner_id
    LEFT JOIN OrderSuccessRate AS osr
        ON r.runner_id = osr.runner_id
    LEFT JOIN AlteredPizzaRate AS apr
        ON r.runner_id = apr.runner_id
)

SELECT *
FROM FinalResult
ORDER BY runner_id;
