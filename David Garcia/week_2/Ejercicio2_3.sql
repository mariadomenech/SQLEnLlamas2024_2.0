
WITH CleanRunner AS (
    SELECT 
        runner_id,
        order_id,
        pickup_time,
        COALESCE(CAST(LEFT(distance, PATINDEX('%[^0-9.]%', distance + ' ') - 1) AS FLOAT), 0) AS distancia,
        COALESCE(CAST(LEFT(duration, PATINDEX('%[^0-9.]%', duration + ' ') - 1) AS FLOAT) / 60, 0) AS duracion
    FROM case02.runner_orders
),
  
Order_good AS (
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
  
Clean_pizza AS (
    SELECT 
        order_id,
        pizza_id,
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
  
filtro AS (
    SELECT  
        og.order_id,
        og.runner_id,
        CASE pn.pizza_id
            WHEN 1 THEN 12
            ELSE 10
        END precio,
        cp.extras,
        distancia * 0.30 AS ganancia_runner
    FROM CleanRunner cr
    LEFT JOIN Clean_pizza cp ON cr.order_id = cp.order_id
    LEFT JOIN case02.pizza_names pn ON cp.pizza_id = pn.pizza_id
    LEFT JOIN Order_good og ON cp.order_id = og.order_id
    WHERE Fin = 1
    GROUP BY og.order_id, og.runner_id, pn.pizza_id, cp.extras, distancia
)
SELECT 
    COUNT(DISTINCT order_id) AS pedidos,
    SUM(extras) AS extras,
    SUM((precio + extras) - ganancia_runner) AS Ganancias
FROM filtro;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Resultado incorrecto David.

Resultado: Los resultados de ingresos y costes no están calculados correctamente.
            - Costes (ganancia runner): Hay que calcularlos por pedido, ya que los costes son los mismos independientemente de las pizzas que lleve y siempre procuramos redondear los resultados.
            - Ingresos: Tenemos que sumar antes los precios de las pizzas al hacer el case when.

Código: Aunque el resultado de los ingredientes extras es correcto, no sería la manera correcta de obtenerlo. Para ello tenemos que hacer un split de los extras. 
        Una manera de hacerlo sería utilizar la función CROSS APPLY STRING_SPLIT ((CASE WHEN (extras is null OR extras = 'null' or extras = '') THEN '0' ELSE extras END ), ',').

Legibilidad: OK.

Me ha gustado que hagas primero la limpieza de las tablas.
Te animo a darle una vuelta y que si tienes dudas preguntes por el grupo o a los correctores, que seguro se puede ayudar en algo, y como siempre, a utilizar la aplicación para comprobar que los resultados son los correctos.

Ánimo!!

*/
