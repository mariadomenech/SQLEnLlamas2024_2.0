WITH temp_customer_orders AS (
    SELECT ORDER_ID,
    CUSTOMER_ID,
    PIZZA_ID,
    CASE EXCLUSIONS
        WHEN 'beef' THEN '3'
        WHEN 'null' THEN ''
        ELSE COALESCE (EXCLUSIONS, '')
        END AS mod_exclusions,
    CASE EXTRAS
        WHEN 'null' THEN ''
        ELSE COALESCE (EXTRAS, '')
        END AS mod_extras,
    ORDER_TIME
    FROM SQL_EN_LLAMAS_ALUMNOS.case02.CUSTOMER_ORDERS),
temp_runner_orders AS (
    SELECT ORDER_ID,
    RUNNER_ID,
    CASE PICKUP_TIME
        WHEN 'null' THEN ''
        ELSE PICKUP_TIME
        END AS mod_pickuptime,
    CASE
        WHEN distance='null' THEN ''
        WHEN PATINDEX('%[^1234567890.]%', duration) =0 THEN distance
        ELSE STUFF(distance, PATINDEX('%[^1234567890.]%', distance),10,'')
        END AS mod_distance,
    CASE
        WHEN PATINDEX('%[^1234567890.]%', duration) =0 THEN duration
        ELSE STUFF(duration, PATINDEX('%[^1234567890.]%', duration),10,'')
        END AS mod_duration,
    CASE CANCELLATION
        WHEN 'null' THEN ''
        ELSE COALESCE(CANCELLATION, '')
        END AS mod_cancellation
FROM SQL_EN_LLAMAS_ALUMNOS.case02.RUNNER_ORDERS),

pedidos_por_runner AS (
    SELECT r.RUNNER_ID, COUNT (r.order_id) AS num_Pedidos_Totales
    FROM temp_runner_orders r
    GROUP BY r.RUNNER_ID),
exito_por_runner AS (
    SELECT r.RUNNER_ID, COUNT (r.order_id) AS num_Pedidos_Entregados
    FROM temp_runner_orders r
    WHERE mod_cancellation = ''
    GROUP BY r.RUNNER_ID),
pizzas_entregadas AS (
    SELECT r.runner_id, COUNT(c.pizza_id) AS num_Pizzas
    FROM temp_customer_orders c
		JOIN temp_runner_orders r ON c.order_id = r.order_id
    WHERE mod_cancellation = ''
    GROUP BY r.runner_id),
pizzas_modificadas AS (
    SELECT r.runner_id, COUNT(c.pizza_id) AS num_Modificadas
    FROM temp_customer_orders c
		JOIN temp_runner_orders r ON c.order_id = r.order_id
    WHERE mod_cancellation = '' AND (mod_exclusions != '' OR mod_extras != '')
    GROUP BY r.runner_id
)
SELECT
    ru.runner_id,
    COALESCE (e.num_Pedidos_Entregados, 0) AS Pedidos_Entregados,
    COALESCE (pe.num_Pizzas,0) AS Num_Pizzas,
    COALESCE ((e.num_Pedidos_Entregados * 100 / pr.num_Pedidos_Totales), 0) AS Porcentaje_exito,
    COALESCE (ROUND((CAST (pm.num_Modificadas AS Decimal) * 100 / CAST (pe.num_Pizzas AS Decimal)),2), 0) AS Porcentaje_Modificadas
FROM SQL_EN_LLAMAS_ALUMNOS.case02.runners ru
	LEFT JOIN exito_por_runner e ON ru.runner_id = e.runner_id
	LEFT JOIN pizzas_entregadas pe ON ru.runner_id = pe.runner_id
	LEFT JOIN pedidos_por_runner pr ON ru.runner_id = pr.runner_id
	LEFT JOIN pizzas_modificadas pm ON ru.runner_id = pm.runner_id;
