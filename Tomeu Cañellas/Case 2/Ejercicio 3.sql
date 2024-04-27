--CASO 2: Ejercicio 3
--Creamos la tabla temporal limpiando los registros de runner_orders
WITH runner_orders AS (
    SELECT  order_id,
            runner_id,
            REPLACE(pickup_time, 'null', '0000-00-00 00:00:00') AS pickup_time,
			CAST(LEFT(distance, PATINDEX('%[^0-9.]%', distance + 'x') - 1) AS FLOAT) AS distance_kms,
			CAST(LEFT(duration, PATINDEX('%[^0-9.]%', duration + 'x') - 1) AS FLOAT) AS duration_mins,
            ISNULL(NULLIF(cancellation, 'null'), '') AS cancellation
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[runner_orders] 
),

--Creamos otra tabla temporal limpiando los registros de customer_orders
customer_orders AS (
    SELECT  order_id,
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
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[customer_orders]
),

--En esta tabla sustituimos cada tipo de pizza por su precio y separamos los extras en columnas distintas
revenue AS (
	SELECT  CASE WHEN pizza_id = 1 THEN 12
				 ELSE 10 END AS pizza_profit,
			CASE WHEN extras LIKE '%,%' THEN LEFT(extras, CHARINDEX(',', extras) - 1)
				 ELSE extras END AS extras_1,
			CASE WHEN extras LIKE '%,%' THEN RIGHT(extras, LEN(extras) - CHARINDEX(',', extras))
				 ELSE NULL END AS extras_2
    --Desechamos las ordenes que han sido canceladas
	FROM (SELECT * FROM runner_orders WHERE runner_orders.cancellation NOT LIKE '%Cancellation%') runner_orders
	LEFT JOIN customer_orders
		ON runner_orders.order_id = customer_orders.order_id
),

--Creamos una tabla temporal con los ingresos totales de las pizzas y sustituimos cada extra por su precio
answer_1 AS (
	SELECT  1 AS answer_id, --Asignamos un ID para un futuro join
			SUM(pizza_profit) AS pizza_revenue,
			SUM(
			CASE WHEN extras_1 NOT LIKE '' THEN 1
				 ELSE 0 END) AS extras_revenue_1,
			SUM(
			CASE WHEN extras_2 NOT LIKE '' OR extras_2 IS NOT NULL THEN 1
				 ELSE 0 END) AS extras_revenue_2
	FROM revenue
),

--En esta última tabla temporal, obtenemos el coste de los repartidores
answer_2 AS (
	SELECT  1 AS answer_id, --Asignamos un ID para un futuro join
			SUM(distance_kms) * 0.3 AS runners_cost
	FROM runner_orders
	WHERE runner_orders.cancellation NOT LIKE '%Cancellation%'
)

--Obtenemos los datos solicitados en el caso, además de el beneficio final de Giuseppe después de los respartos
SELECT  answer.*,
		answer.pizza_revenue + answer.extras_revenue - answer.runners_cost AS Giuseppe_profit	
FROM (
    --En esta subconsulta, cruzamos por el ID anterior y obtenemos los ingresos de pizza y extras, además de los costes de reparto.
	SELECT  pizza_revenue,
			extras_revenue_1 + extras_revenue_2 AS extras_revenue,
			runners_cost
	FROM answer_1
	INNER JOIN answer_2
		ON answer_1.answer_id = answer_2.answer_id
		) answer;
