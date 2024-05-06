--CASO 2: Ejercicio 2
--Creamos la tabla temporal limpiando los registros de runner_orders
WITH runner_orders AS (
    SELECT  order_id,
            runner_id,
            REPLACE(pickup_time, 'null', '0000-00-00 00:00:00') AS pickup_time,
	    CAST(LEFT(distance, PATINDEX('%[^0-9.]%', distance + 'x') - 1) AS FLOAT) AS distance_kms,
	    CAST(LEFT(duration, PATINDEX('%[^0-9.]%', duration + 'x') - 1) AS FLOAT) AS duration_mins,
            COALESCE(NULLIF(cancellation, 'null'), '') AS cancellation
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[runner_orders] 
),

--Creamos otra tabla temporal con el total de ordenes entregadas y el total de ordenes. Cruzamos con la tabla de corredores y agrupamos por corredor
orders_ok AS (
    SELECT  runners.runner_id,
	    SUM(
	    CASE WHEN runner_orders.cancellation LIKE '%Cancellation%' OR runner_orders.cancellation IS NULL THEN 0
		 ELSE 1 END) AS orders_success,
	    SUM(
	    CASE WHEN runner_orders.cancellation IS NULL THEN 0
		 ELSE 1 END) AS orders_total
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[runners] runners
    LEFT JOIN runner_orders
	    ON runner_orders.runner_id = runners.runner_id
    GROUP BY runners.runner_id
),

--En esta tabla temporal obtenemos el % de pizzas etregadas con exito
order_answers AS (
    SELECT  orders_ok.runner_id,
	    orders_ok.orders_success,
	    CASE WHEN orders_total > 0 THEN orders_success / CAST(orders_total AS FLOAT) * 100 
		 ELSE 0 END AS success_rate
    FROM orders_ok
),

--Creamos otra tabla temporal limpiando los registros de customer_orders
customer_orders AS (
    SELECT  runners.runner_id, 
	    runner_orders.order_id,
	    runner_orders.cancellation AS cancellation,
            customer_id,
            pizza_id,
            ISNULL(
                CASE WHEN exclusions = 'beef' THEN '3'
                     WHEN exclusions = 'null' THEN ''
                     ELSE exclusions END, ''
            ) AS exclusions,
            ISNULL(
                REPLACE(extras, 'null', ''), ''
            ) AS extras,
            order_time			
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[runners] runners
    LEFT JOIN runner_orders
    	    ON runner_orders.runner_id = runners.runner_id
    LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case02].[customer_orders] customer_orders
	    ON runner_orders.order_id = customer_orders.order_id
),

--En esta tabla temporal obtenemos la cantidad de pizzas entregadas con éxito y la cantidad de pizzas con modificaciones
pizzas_ok AS(
    SELECT  runner_id,
	    SUM(
	    CASE WHEN customer_orders.cancellation LIKE '%Cancellation%' OR customer_orders.cancellation IS NULL THEN 0
	         ELSE 1 END) AS pizzas_success,
	    SUM(
	    CASE WHEN customer_orders.cancellation NOT LIKE '%Cancellation%' AND (customer_orders.exclusions <> '' OR customer_orders.extras <> '') THEN 1
	         ELSE 0 END) AS topping_pizzas
    FROM customer_orders
    GROUP BY runner_id
)

--Finalmente en la consulta, ordenamos las columnas con las respuestas al caso y obtenemos el % de pizzas modificadas:
SELECT  pizzas_ok.runner_id,
	order_answers.orders_success,
	pizzas_ok.pizzas_success,
	order_answers.success_rate,
	CASE WHEN pizzas_ok.topping_pizzas > 0 THEN ROUND(pizzas_ok.topping_pizzas / CAST(pizzas_ok.pizzas_success AS FLOAT) * 100, 2) 
	     ELSE 0 END AS topping_rate
FROM pizzas_ok
LEFT JOIN order_answers
	ON order_answers.runner_id = pizzas_ok.runner_id;


/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Está perfecto, tanto el tratamiento de los datos, como la limpieza y el resultado. Me gusta que le hayas dado una solución un poco más
general con el %Cancellation%. Nada que añadir!

*/
