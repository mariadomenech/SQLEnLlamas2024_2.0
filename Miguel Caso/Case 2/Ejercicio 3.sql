WITH temp_customer_orders AS (
    SELECT 
	ORDER_ID,
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
    CAST (CASE
        WHEN distance='null' THEN ''
        WHEN PATINDEX('%[^1234567890.]%', duration) =0 THEN distance
        ELSE STUFF(distance, PATINDEX('%[^1234567890.]%', distance),10,'')
        END AS decimal (10,2)) AS mod_distance,
    CAST (CASE
        WHEN PATINDEX('%[^1234567890.]%', duration) =0 THEN duration
        ELSE STUFF(duration, PATINDEX('%[^1234567890.]%', duration),10,'')
        END AS decimal (10,2)) AS mod_duration,
    CASE CANCELLATION
        WHEN 'null' THEN ''
        ELSE COALESCE(CANCELLATION, '')	
        END AS mod_cancellation
FROM SQL_EN_LLAMAS_ALUMNOS.case02.RUNNER_ORDERS ),

conteo_extras AS (
	SELECT
		co.order_id,
		COUNT (*) AS num_extras
	FROM temp_customer_orders co
		JOIN temp_runner_orders ro ON co.order_id = ro.order_id
		CROSS APPLY string_split(mod_extras, ',')
	WHERE mod_extras <> '' AND mod_cancellation = ''
	GROUP BY co.order_id
	), 

ingresos_pedido AS (
    SELECT
		co.order_id,
      SUM (CASE pizza_id
			  WHEN 1 THEN 12
			  WHEN 2 THEN 10
			  ELSE 0
			  END) AS importe_pizza,
      ce.num_extras AS importe_extras,
      MAX (ro.mod_distance) * 0.30 AS salario
    FROM temp_customer_orders co
		LEFT JOIN temp_runner_orders ro ON co.order_id = ro.order_id
		LEFT JOIN conteo_extras ce ON co.order_id = ce.order_id
    WHERE ro.mod_cancellation = ''
	GROUP BY co.order_id, ce.num_extras
)

SELECT
  SUM(importe_pizza) AS ingresos_pizzas,
	SUM(importe_extras) AS ingresos_extras,
	SUM(salario) AS gastos_salario,
	SUM(importe_pizza) + SUM(importe_extras) - SUM(salario) AS Beneficios
FROM ingresos_pedido;


/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*
RESULTADO: Correcto. Me ha gustado que incluyas los beneficios, porque al final a Giuseppe es una de las cosas que más le puede interesar saber jeje
CÓDIGO: Correcto.
LEGIBILIDAD: Correcto.

Genial Miguel!!!

*/
